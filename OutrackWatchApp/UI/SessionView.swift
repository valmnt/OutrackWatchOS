//
//  SessionView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import SwiftUI
import HealthKit

struct SessionView: View {

    init(selectedWorkout: HKWorkoutActivityType? = nil) {
        WorkoutManager.shared.selectedWorkout = selectedWorkout
    }

    var body: some View {
        Text(WorkoutManager.shared.selectedWorkout?.name ?? "Error")
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
