//
//  MainView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 07/09/2023.
//

import SwiftUI

struct MainView: View {

    @EnvironmentObject var workoutManager: WorkoutManager
    @Binding var path: NavigationPath
    @State private var selection: Tab = .sportList

    enum Tab {
        case account, sportList, training
    }

    var body: some View {
        TabView(selection: $selection) {
            AccountView(path: $path).tag(Tab.account)
            SportListView(path: $path).tag(Tab.sportList)
            TrainingView().tag(Tab.training)
        }
        .navigationBarBackButtonHidden()
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(path: .constant(.init()))
    }
}
