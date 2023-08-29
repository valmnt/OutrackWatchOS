//
//  SessionView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 28/08/2023.
//

import SwiftUI
import HealthKit

struct SessionView: View {

    @State private var selection: Tab = .controls

    init(selectedWorkout: HKWorkoutActivityType? = nil) {
        WorkoutManager.shared.selectedWorkout = selectedWorkout
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
        .navigationTitle(WorkoutManager.shared.selectedWorkout?.name ?? "")
    }
}

struct SessionView_Previews: PreviewProvider {
    static var previews: some View {
        SessionView()
    }
}
