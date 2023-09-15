//
//  TrainingViewModel.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 12/09/2023.
//

import Foundation

class TrainingViewModel: ObservableObject {

    let getTrainingsService: GETTrainingsService = GETTrainingsService()

    func getTrainings() async -> [Training] {
        await getTrainingsService.proccess(accessToken: UserDefaults.standard.token)
        let response = (getTrainingsService.task.response as? GetTrainingsResponse)?.message ?? []
        return response
    }
}
