//
//  ActivityResultView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 29/08/2023.
//

import SwiftUI
import HealthKit

struct ActivityResultView: View {

    @ObservedObject var viewModel: ResultViewModel = ResultViewModel()
    @Environment(\.dismiss) var dismiss
    var resetCallback: (() -> Void)?

    init(workout: HKWorkout? = nil, resetCallback: (() -> Void)? = nil) {
        viewModel.workout = workout
        self.resetCallback = resetCallback
    }

    var body: some View {
        ScrollView {
            VStack {
                Text("Result")
                    .foregroundColor(Color(Color.primary))
                    .fontWeight(.semibold)
                    .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())

                Divider()

                VStack {
                    Text(viewModel.duration?.formatElapsedTime() ?? "00:00:00")
                    .frame(maxWidth: .infinity, alignment: .leading)

                    if viewModel.workout?.workoutActivityType.locationType == .outdoor {
                        Text(Measurement(value: viewModel.statistics[
                            viewModel.workout?.workoutActivityType == .running
                            ? .distanceWalkingRunning
                            : .distanceCycling
                        ] ?? 0,
                                         unit: UnitLength.meters).formatted(.measurement(width: .abbreviated,
                                                                                         usage: .asProvided)))
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if viewModel.workout?.workoutActivityType == .running {
                            Text((viewModel.statistics[.runningSpeed] ?? 0)
                            .formatted(.number.precision(.fractionLength(0))) + " km/h")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    Text((viewModel.statistics[.heartRate] ?? 0)
                    .formatted(.number.precision(.fractionLength(0))) + " bpm")
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(Measurement(value: viewModel.statistics[.activeEnergyBurned] ?? 0,
                                     unit: UnitEnergy.kilocalories)
                        .formatted(.measurement(width: .abbreviated, usage: .workout,
                                    numberFormatStyle: .number.precision(.fractionLength(0)))))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(.title2, design: .rounded).monospacedDigit().lowercaseSmallCaps())
                .frame(maxWidth: .infinity, alignment: .leading)
                .scenePadding()

                Button("Done") {
                    resetCallback?()
                    dismiss()
                }
            }
        }
    }
}

extension HKQuantityTypeIdentifier: Identifiable {
    public var id: String {
        return rawValue
    }
}

struct WorkoutResultView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityResultView()
    }
}
