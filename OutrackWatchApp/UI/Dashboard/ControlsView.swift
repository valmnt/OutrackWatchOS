//
//  ControlsView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 29/08/2023.
//

import SwiftUI

struct ControlsView: View {

    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss

    var progressionViewCallback: (() -> Void)?

    var body: some View {
        HStack {
            if workoutManager.started {
                ZStack {
                    HStack {
                        VStack {
                            Button {
                                workoutManager.end(waitingCallback: {
                                    progressionViewCallback?()
                                }, endCallback: {
                                    dismiss()
                                })
                            } label: {
                                Image(systemName: "xmark")
                            }
                            .tint(.red)
                            .font(.title2)
                            Text("End")
                        }
                        VStack {
                            Button {
                                workoutManager.togglePause()
                            } label: {
                                Image(systemName: workoutManager.running ? "pause" : "play")
                            }
                            .tint(.yellow)
                            .font(.title2)
                            Text(workoutManager.running ? "Pause" : "Resume")
                        }
                    }
                }
            } else {
                VStack {
                    Button {
                        workoutManager.startWorkout()
                    } label: {
                        Image(systemName: "play")
                    }
                    .font(.title2)
                    .frame(width: 120)
                    .tint(Color(Color.primary))
                    Text("Start")
                }
            }
        }
    }
}

struct ControlsView_Previews: PreviewProvider {
    static var previews: some View {
        ControlsView()
    }
}
