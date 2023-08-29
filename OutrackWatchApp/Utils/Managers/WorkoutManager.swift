//
//  WorkoutManager.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {

    @Published var running = false
    @Published var started = false
    @Published var workout: HKWorkout?
    @Published var showingWorkoutResult: Bool = false

    static private(set) var shared = WorkoutManager()

    var selectedWorkout: HKWorkoutActivityType?
    var builder: HKLiveWorkoutBuilder?
    var session: HKWorkoutSession?
    var endCallback: (() -> Void)?

    let healthStore = HKHealthStore()

    func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKObjectType.activitySummaryType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (_, error) in
            if let error = error {
                print("🚨 An error occured with HK authorization : \(error.localizedDescription)")
            }
        }
    }

    func startWorkout() {
        guard let activityType = selectedWorkout,
              let locationType = activityType.locationType else { return }

        let configuration = HKWorkoutConfiguration()
        configuration.activityType = activityType
        configuration.locationType = locationType

        do {
            session = try HKWorkoutSession(healthStore: healthStore, configuration: configuration)
            builder = session?.associatedWorkoutBuilder()
        } catch {
            return
        }

        session?.delegate = self
        builder?.delegate = self

        builder?.dataSource = HKLiveWorkoutDataSource(healthStore: healthStore,
                                                     workoutConfiguration: configuration)

        let startDate = Date()
        session?.startActivity(with: startDate)
        builder?.beginCollection(withStart: startDate) { (_, _) in
            DispatchQueue.main.async {
                self.started = true
                self.running = true
            }
        }
    }
}

// MARK: - Controller
extension WorkoutManager {
    func togglePause() {
        if running {
            pause()
        } else {
            resume()
        }
    }

    func end(waitingCallback: () -> Void, endCallback: @escaping (() -> Void)) {
        self.endCallback = endCallback
        started = false
        running = false
        waitingCallback()
        session?.end()
    }

    private func resume() {
        session?.resume()
        running = true
    }

    private func pause() {
        session?.pause()
        running = false
    }

    private func reset() {
        builder = nil
        workout = nil
        session = nil
        selectedWorkout = nil
    }
}

// MARK: - HKWorkoutSessionDelegate
extension WorkoutManager: HKWorkoutSessionDelegate {
    func workoutSession(_ workoutSession: HKWorkoutSession, didChangeTo toState: HKWorkoutSessionState,
                        from fromState: HKWorkoutSessionState, date: Date) {
        if toState == .ended {
            builder?.endCollection(withEnd: date) { (_, _) in
                self.builder?.finishWorkout { (workout, _) in
                    DispatchQueue.main.async {
                        self.workout = workout
                        self.reset()
                        self.endCallback?()
                        self.showingWorkoutResult = true
                    }
                }
            }
        }
    }

    func workoutSession(_ workoutSession: HKWorkoutSession, didFailWithError error: Error) {}
}

// MARK: - HKLiveWorkoutBuilderDelegate
extension WorkoutManager: HKLiveWorkoutBuilderDelegate {
    func workoutBuilderDidCollectEvent(_ workoutBuilder: HKLiveWorkoutBuilder) {}

    func workoutBuilder(_ workoutBuilder: HKLiveWorkoutBuilder, didCollectDataOf collectedTypes: Set<HKSampleType>) {
        print("LOG: \(collectedTypes)")
    }
}
