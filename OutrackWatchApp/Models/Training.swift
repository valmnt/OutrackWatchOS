//
//  Training.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import Foundation
import HealthKit

struct Training: Decodable, Identifiable, Hashable {
    let id: Int
    let sport: String
    let trainingSteps: [TrainingSteps]
    let targets: [Target]

    struct TrainingSteps: Decodable {
        let step: String
        let duration: Int
    }

    struct Target: Decodable {
        let type: String
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: Training, rhs: Training) -> Bool {
        return lhs.id == rhs.id
    }
}

extension Training {
    var workoutActivityType: HKWorkoutActivityType? {
        HKWorkoutActivityType.from(identifier: self.sport)
    }
}

extension Training.TrainingSteps {

    enum Steps {
        case warmup
        case stretching
        case rest
        case exercise
    }

    var stepIdentifier: Steps? {
        switch self.step {
        case "WARMUP": return .warmup
        case "STRETCHING": return .stretching
        case "REST": return .rest
        case "EXERCISE": return .exercise
        default: return nil
        }
    }

    var localizable: String? {
        switch self.step {
        case "WARMUP": return R.string.localizable.warmup.callAsFunction()
        case "STRETCHING": return R.string.localizable.stretching.callAsFunction()
        case "REST": return R.string.localizable.rest.callAsFunction()
        case "EXERCISE": return R.string.localizable.exercise.callAsFunction()
        default: return nil
        }
    }
}
