//
//  ActivityResultViewModel.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 30/08/2023.
//

import Foundation
import HealthKit

class ResultViewModel: ObservableObject {

    @Published var duration: TimeInterval?
    @Published var statistics: [HKQuantityTypeIdentifier: Double] = [:]

    var sortedKeys: [HKQuantityTypeIdentifier] {
        statistics.keys.sorted(by: { $0.rawValue < $1.rawValue })
    }

    var workout: HKWorkout? {
        didSet {
            getActivityResult()
        }
    }

    func getActivityResult() {
        duration = workout?.duration
        statistics[.heartRate] = workout?.allStatistics[.init(.heartRate)]?.averageHearthRate()
        statistics[.activeEnergyBurned] = workout?.allStatistics[.init(.activeEnergyBurned)]?.sumActiveEnergyBurned()

        switch workout?.workoutActivityType {
        case .running:
            statistics[.runningSpeed] = workout?.allStatistics[.init(.runningSpeed)]?.averageRunningSpeed()
            statistics[.distanceWalkingRunning] = workout?.allStatistics[.init(.distanceWalkingRunning)]?.sumDistance()
        case .cycling:
            statistics[.distanceCycling] = workout?.allStatistics[.init(.distanceCycling)]?.sumDistance()
        default: return
        }
    }
}
