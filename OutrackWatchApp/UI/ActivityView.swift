//
//  ActivityView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import SwiftUI
import HealthKit

struct ActivityView: View {

    @EnvironmentObject var workoutManager: WorkoutManager

    @State private var selection: Tab = .controls
    @State private var displayProgressionView: Bool = false

    private var selectedWorkoutActivity: HKWorkoutActivityType?

    init(selectedWorkoutActivity: HKWorkoutActivityType? = nil) {
        self.selectedWorkoutActivity = selectedWorkoutActivity
    }

    enum Tab {
        case controls, metrics
    }

    var body: some View {
        if !displayProgressionView {
            VStack {
                TabView(selection: $selection) {
                    ControlsView {
                        displayProgressionView = true
                    }.tag(Tab.controls)
                    MetricsView().tag(Tab.metrics)
                }
                .navigationTitle(selectedWorkoutActivity?.name ?? "")
                .navigationBarBackButtonHidden(workoutManager.started)
                .onAppear {
                    workoutManager.selectedWorkoutActivity = selectedWorkoutActivity
                }
            }
        } else {
            ProgressView()
            .progressViewStyle(CircularProgressViewStyle(tint: Color(Color.primary)))
            .navigationBarBackButtonHidden()
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
