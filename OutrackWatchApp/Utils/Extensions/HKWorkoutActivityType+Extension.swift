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
            return "Run"
        case .cycling:
            return "Bike"
        case .crossTraining:
            return "Fitness"
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
