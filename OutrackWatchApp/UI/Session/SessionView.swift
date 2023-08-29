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

    private var selectedWorkout: HKWorkoutActivityType?

    init(selectedWorkout: HKWorkoutActivityType? = nil) {
        self.selectedWorkout = selectedWorkout
    }

    enum Tab {
        case controls, metrics, nowPlaying
    }

    var body: some View {
        TabView(selection: $selection) {
            ControlsView().tag(Tab.controls)
            MetricsView().tag(Tab.metrics)
            NowPlayingView().tag(Tab.nowPlaying)
        }
        .navigationTitle(selectedWorkout?.name ?? "")
        .onAppear {
            workoutManager.selectedWorkout = selectedWorkout
        }
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
