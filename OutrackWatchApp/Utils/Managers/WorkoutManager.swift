//
//  WorkoutManager.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import Foundation
import HealthKit

class WorkoutManager: NSObject, ObservableObject {

    static private(set) var shared = WorkoutManager()

    var selectedWorkout: HKWorkoutActivityType?
}
