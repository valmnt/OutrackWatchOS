//
//  LoginViewModel.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

class LoginViewModel: ObservableObject {

    @Published var displayError: Bool = false
    @Published var isSignedIn: Bool = false

    private let service: LoginService = LoginService()

    @MainActor
    func signIn(email: String, password: String) async {
        await service.proccess(dto: LoginDTO(email: email, password: password))
        if let token = (service.task.response as? LoginResponse)?.message.token {
            UserDefaults.standard.set(token, forKey: "token")
            isSignedIn = true
        } else {
            displayError = true
        }
    }
}

private struct LoginDTO: Encodable {
    let email: String
    let password: String
}
