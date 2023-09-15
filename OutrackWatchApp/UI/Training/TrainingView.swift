//
//  TrainingView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import SwiftUI

struct TrainingView: View {

    @ObservedObject var viewModel: TrainingViewModel = TrainingViewModel()
    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var path: NavigationPath
    @State var displayProgressView: Bool = false
    @State var displayError: Bool = false
    @State var trainings: [Training] = []

    var body: some View {
        VStack {
            if displayError {
                HStack {
                    Spacer()
                    Text(R.string.localizable.trainingErrorText)
                    Spacer()
                }
            } else {
                if displayProgressView {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: Color(R.color.orange)))
                } else {
                    List(trainings) { training in
                        Button(action: {
                            workoutManager.selectedWorkoutActivity = training.workoutActivityType
                            path.append(training)
                        }, label: {
                            Text("\(training.workoutActivityType?.name ?? "")")
                                .foregroundColor(buttonColor(intensity: training.intensity))
                                .fontWeight(.semibold)
                        })
                        .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                    }
                    .navigationTitle(R.string.localizable.training.callAsFunction())
                }
            }
        }.onAppear {
            Task {
                displayProgressView = true
                trainings = await viewModel.getTrainings()
                if viewModel.getTrainingsService.task.state == .succeeded {
                    displayProgressView = false
                } else if viewModel.getTrainingsService.task.state == .failed {
                    displayError = true
                }
            }
        }
    }

    func buttonColor(intensity: Int?) -> Color {
        guard let intensity = intensity else { return Color(.gray) }
        if intensity < 40 {
            return Color(.green)
        } else if intensity < 80 {
            return Color(.orange)
        } else {
            return Color(.red)
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView(path: .constant(.init()))
    }
}
