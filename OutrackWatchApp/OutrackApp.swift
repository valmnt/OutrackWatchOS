//
//  OutrackApp.swift
//  Outrack Watch App
//
//  Created by Valentin Mont on 01/06/2023.
//

import SwiftUI

@main
struct OutrackApp: App {
        
    var body: some Scene {
        WindowGroup {
            SportsListView()
                .background(Color(Color.primary))
        }
    }
}
