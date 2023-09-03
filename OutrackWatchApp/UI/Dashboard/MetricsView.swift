//
//  MetricsView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 29/08/2023.
//

import SwiftUI
import HealthKit

struct MetricsView: View {

    @EnvironmentObject var workoutManager: WorkoutManager

    var body: some View {
        ScrollView {
            TimelineView(MetricsTimelineSchedule(from: workoutManager.builder?.startDate ?? Date(),
                                                 isPaused: !workoutManager.running)) { _ in
                VStack {
                    Text(workoutManager.builder?.elapsedTime.formatElapsedTime() ?? "00:00:00")
                    .fontWeight(.semibold)
                    .foregroundColor(Color(R.color.orange))

                    Divider()

                    if workoutManager.selectedWorkoutActivity?.locationType == .outdoor {
                        Text(Measurement(value: workoutManager.activityData[
                            workoutManager.selectedWorkoutActivity == .running
                            ? .distanceWalkingRunning
                            : .distanceCycling
                        ] ?? 0,
                                         unit: UnitLength.meters).formatted(.measurement(width: .abbreviated,
                                                                                         usage: .asProvided)))
                        .frame(maxWidth: .infinity, alignment: .leading)

                        if workoutManager.selectedWorkoutActivity == .running {
                            Text((workoutManager.activityData[.runningSpeed] ?? 0)
                            .formatted(.number.precision(.fractionLength(0))) + " km/h")
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }

                    Text((workoutManager.activityData[.heartRate] ?? 0)
                    .formatted(.number.precision(.fractionLength(0))) + " bpm")
                    .frame(maxWidth: .infinity, alignment: .leading)

                    Text(Measurement(value: workoutManager.activityData[.activeEnergyBurned] ?? 0,
                                     unit: UnitEnergy.kilocalories)
                        .formatted(.measurement(width: .abbreviated, usage: .workout,
                                    numberFormatStyle: .number.precision(.fractionLength(0)))))
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.system(size: 25).monospacedDigit().lowercaseSmallCaps())
                .frame(maxWidth: .infinity, alignment: .leading)
                .scenePadding()
            }
        }
    }
}

private struct MetricsTimelineSchedule: TimelineSchedule {
    var startDate: Date
    var isPaused: Bool

    init(from startDate: Date, isPaused: Bool) {
        self.startDate = startDate
        self.isPaused = isPaused
    }

    func entries(from startDate: Date, mode: TimelineScheduleMode) -> AnyIterator<Date> {
        var baseSchedule = PeriodicTimelineSchedule(from: self.startDate,
                                                    by: (mode == .lowFrequency ? 1.0 : 1.0 / 30.0))
            .entries(from: startDate, mode: mode)

        return AnyIterator<Date> {
            guard !isPaused else { return nil }
            return baseSchedule.next()
        }
    }
}

struct MetricsView_Previews: PreviewProvider {
    static var previews: some View {
        MetricsView()
    }
}
