//
//  WorkoutResultView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 29/08/2023.
//

import SwiftUI

struct WorkoutResultView: View {

    @EnvironmentObject var workoutManager: WorkoutManager
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            Text("WorkoutResultView")
            Button("done") {
                workoutManager.reset()
                dismiss()
            }
        }
    }
}

struct WorkoutResultView_Previews: PreviewProvider {
    static var previews: some View {
        WorkoutResultView()
    }
}
