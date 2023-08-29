//
//  SportListView.swift
//  Outrack Watch App
//
//  Created by Valentin Mont on 07/06/2023.
//

import SwiftUI
import HealthKit

struct SportListView: View {

    @EnvironmentObject var workoutManager: WorkoutManager

    var workoutTypes: [HKWorkoutActivityType] = [.cycling, .running, .crossTraining]

    var body: some View {
        List(workoutTypes) { workoutType in
            NavigationLink(workoutType.name, value: workoutType)
            .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
        }
        .navigationDestination(for: HKWorkoutActivityType.self) { workoutType in
            SessionView(selectedWorkout: workoutType)
            .environmentObject(workoutManager)
        }
        .listStyle(.carousel)
        .navigationBarTitle("Workouts")
        .onAppear {
            workoutManager.requestAuthorization()
        }
    }
}

struct SportList_Previews: PreviewProvider {
    static var previews: some View {
        SportListView()
    }
}
