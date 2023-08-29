//
//  SessionView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import SwiftUI
import HealthKit

struct SessionView: View {

    @EnvironmentObject var workoutManager: WorkoutManager

    @State private var selection: Tab = .controls
    @State private var displayProgressionView: Bool = false

    private var selectedWorkout: HKWorkoutActivityType?

    init(selectedWorkout: HKWorkoutActivityType? = nil) {
        self.selectedWorkout = selectedWorkout
    }

    enum Tab {
        case controls, metrics, stepsView
    }

    var body: some View {
        if !displayProgressionView {
            VStack {
                TabView(selection: $selection) {
                    ControlsView {
                        displayProgressionView = true
                    }.tag(Tab.controls)
                    MetricsView().tag(Tab.metrics)
                    StepsView().tag(Tab.stepsView)
                }
                .navigationTitle(selectedWorkout?.name ?? "")
                .navigationBarBackButtonHidden(workoutManager.started)
                .onAppear {
                    workoutManager.selectedWorkout = selectedWorkout
                }
            }
        } else {
            ProgressView()
            .navigationBarBackButtonHidden()
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
