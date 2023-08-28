//
//  SportsListView.swift
//  Outrack Watch App
//
//  Created by Valentin Mont on 07/06/2023.
//

import SwiftUI
import HealthKit

struct SportsListView: View {

    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .crossTraining]

    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(workoutType.name, value: workoutType)
                .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }
        .navigationDestination(for: HKWorkoutActivityType.self) { workoutType in
            SessionView(selectedWorkout: workoutType)
        }
        .listStyle(.carousel)
        .navigationBarTitle("Workouts")
    }
}

struct SportsList_Previews: PreviewProvider {
    static var previews: some View {
        SportsListView()
    }
}
