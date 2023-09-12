//
//  TrainingView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import SwiftUI

struct TrainingView: View {

    @ObservedObject var viewModel: TrainingViewModel = TrainingViewModel()
    @State var displayProgressView: Bool = false {
        didSet {
            if displayProgressView {
                displayError = false
            }
        }
    }
    @State var displayError: Bool = false {
        didSet {
            if displayError {
                displayProgressView = false
            }
        }
    }

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
                    List(viewModel.trainings) { training in
                        Button(training.workoutActivityType?.name ?? "") {
                            print(training)
                        }
                        .padding(EdgeInsets(top: 15, leading: 5, bottom: 15, trailing: 5))
                    }
                    .navigationTitle(R.string.localizable.training.callAsFunction())
                }
            }
        }.onAppear {
            Task {
                displayProgressView = true
                await viewModel.getTrainings()
                if viewModel.getTrainingsService.task.state == .succeeded {
                    displayProgressView = false
                } else if viewModel.getTrainingsService.task.state == .failed {
                    displayError = true
                }
            }
        }
    }
}

struct TrainingView_Previews: PreviewProvider {
    static var previews: some View {
        TrainingView()
    }
}
