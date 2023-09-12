//
//  TrainingViewModel.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import Foundation

class TrainingViewModel: ObservableObject {

    @Published var trainings: [Training] = []

    let getTrainingsService: GETTrainingsService = GETTrainingsService()

    func getTrainings() async {
        await getTrainingsService.proccess(accessToken: UserDefaults.standard.token)
        if let response = (getTrainingsService.task.response as? GetTrainingsResponse)?.message {
            DispatchQueue.main.async {
                self.trainings = response
            }
        }
    }
}
