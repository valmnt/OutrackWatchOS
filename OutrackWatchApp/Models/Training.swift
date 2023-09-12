//
//  Training.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import Foundation
import HealthKit

struct Training: Decodable, Identifiable {
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
}

extension Training {
    var workoutActivityType: HKWorkoutActivityType? {
        HKWorkoutActivityType.from(identifier: self.sport)
    }
}
