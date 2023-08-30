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

    private var selectedWorkoutActivity: HKWorkoutActivityType?

    init(selectedWorkoutActivity: HKWorkoutActivityType? = nil) {
        self.selectedWorkoutActivity = selectedWorkoutActivity
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
                .navigationTitle(selectedWorkoutActivity?.name ?? "")
                .navigationBarBackButtonHidden(workoutManager.started)
                .onAppear {
                    workoutManager.selectedWorkoutActivity = selectedWorkoutActivity
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
