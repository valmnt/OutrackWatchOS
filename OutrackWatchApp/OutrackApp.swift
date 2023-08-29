//
//  OutrackApp.swift
//  Outrack Watch App
//
//  Created by Valentin Mont on 01/06/2023.
//

import SwiftUI

@main
struct OutrackApp: App {

    @StateObject private var workoutManager = WorkoutManager()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                SportListView()
                .environmentObject(workoutManager)
            }
        }
    }
}
