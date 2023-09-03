//
//  HKWorkoutActivityType+Extension.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import Foundation
import HealthKit

extension HKWorkoutActivityType: Identifiable {
    public var id: UInt {
        rawValue
    }

    var name: String {
        switch self {
        case .running:
            return R.string.localizable.run.callAsFunction()
        case .cycling:
            return R.string.localizable.bike.callAsFunction()
        case .crossTraining:
            return R.string.localizable.fitness.callAsFunction()
        default:
            return ""
        }
    }

    var locationType: HKWorkoutSessionLocationType? {
        switch self {
        case .running:
            return .outdoor
        case .cycling:
            return .outdoor
        case .crossTraining:
            return .indoor
        default:
            return nil
        }
    }
}
