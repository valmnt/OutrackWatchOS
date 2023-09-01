//
//  WorkoutManager.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {

    // MARK: - States
    @Published private(set) var started = false
    @Published private(set) var running = false
    @Published var ended = false

    // MARK: - HK Variables
    @Published private(set) var workout: HKWorkout?

    private let healthStore = HKHealthStore()

    var builder: HKLiveWorkoutBuilder?
    private var session: HKWorkoutSession?
    var selectedWorkoutActivity: HKWorkoutActivityType?

    // MARK: - Callbacks
    private var endCallback: (() -> Void)?

    // MARK: - ActivtiData
    @Published var activityData: [HKQuantityTypeIdentifier: Double] = [:]

    // MARK: - Methods
    func requestAuthorization() {
        let typesToShare: Set = [
            HKQuantityType.workoutType()
        ]

        let typesToRead: Set = [
            HKQuantityType.quantityType(forIdentifier: .heartRate)!,
            HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned)!,
            HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning)!,
            HKQuantityType.quantityType(forIdentifier: .distanceCycling)!,
            HKQuantityType.quantityType(forIdentifier: .runningSpeed)!,
            HKObjectType.activitySummaryType()
        ]

        healthStore.requestAuthorization(toShare: typesToShare, read: typesToRead) { (_, error) in
            if let error = error {
                print("🚨 An error occured with HK authorization : \(error.localizedDescription)")
            }
        }
    }

    func startWorkout() {
        guard let activityType = selectedWorkoutActivity,
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

    func reset() {
        ended = false
        builder = nil
        workout = nil
        session = nil
        endCallback = nil
        activityData = [:]
        selectedWorkoutActivity = nil
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
                        self.endCallback?()
                        self.ended = true
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
        for type in collectedTypes {
            guard let quantityType = type as? HKQuantityType,
                  let statistics = workoutBuilder.statistics(for: quantityType) else { return }

            updateStatistics(statistics)
        }
    }

    func updateStatistics(_ statistics: HKStatistics) {
        DispatchQueue.main.async {
            switch statistics.quantityType {
            case HKQuantityType.quantityType(forIdentifier: .heartRate):
                self.activityData[HKQuantityTypeIdentifier.heartRate] =
                statistics.mostRecentHearthRate()
            case HKQuantityType.quantityType(forIdentifier: .activeEnergyBurned):
                self.activityData[HKQuantityTypeIdentifier.activeEnergyBurned] =
                statistics.sumActiveEnergyBurned()
            case HKQuantityType.quantityType(forIdentifier: .distanceCycling):
                self.activityData[HKQuantityTypeIdentifier.distanceCycling] =
                statistics.sumDistance()
            case HKQuantityType.quantityType(forIdentifier: .distanceWalkingRunning):
                self.activityData[HKQuantityTypeIdentifier.distanceWalkingRunning] =
                statistics.sumDistance()
            case HKQuantityType.quantityType(forIdentifier: .runningSpeed):
                self.activityData[HKQuantityTypeIdentifier.runningSpeed] =
                statistics.averageRunningSpeed()
            default:
                return
            }
        }
    }
}
