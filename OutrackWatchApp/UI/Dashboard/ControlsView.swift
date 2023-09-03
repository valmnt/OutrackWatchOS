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
                            Text(R.string.localizable.end)
                        }
                        VStack {
                            Button {
                                workoutManager.togglePause()
                            } label: {
                                Image(systemName: workoutManager.running ? "pause" : "play")
                            }
                            .tint(.yellow)
                            .font(.title2)
                            Text(workoutManager.running ? R.string.localizable.pause : R.string.localizable.resume)
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
                    .tint(Color(R.color.orange))
                    Text(R.string.localizable.start)
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
