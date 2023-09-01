//
//  WorkoutResultViewModel.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 30/08/2023.
//

import Foundation
import HealthKit

class WorkoutResultViewModel: ObservableObject {
    var workout: HKWorkout? {
        didSet {
            getResult()
        }
    }

    func getResult() {
    }
}
