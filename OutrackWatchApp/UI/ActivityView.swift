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
                .navigationTitle(workoutManager.selectedWorkoutActivity?.name ?? "")
                .navigationBarBackButtonHidden(workoutManager.started)
            }
        } else {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle(tint: Color(R.color.orange)))
                .navigationBarBackButtonHidden()
        }
    }
}

struct ActivityView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityView()
    }
}
