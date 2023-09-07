//
//  LoginView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import SwiftUI
import WatchKit

struct LoginView: View {

    @EnvironmentObject var workoutManager: WorkoutManager
    @ObservedObject var viewModel: LoginViewModel = LoginViewModel()
    @Binding var path: NavigationPath

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var displayInitWarning: Bool = false

    var body: some View {
        VStack {
            TextField(R.string.localizable.email.callAsFunction(), text: $email)
                .textContentType(.username)
                .multilineTextAlignment(.center)
            SecureField(R.string.localizable.password.callAsFunction(), text: $password)
                .textContentType(.password)
                .multilineTextAlignment(.center)
            Button(R.string.localizable.signin.callAsFunction()) {
                Task {
                    await viewModel.signIn(email: email, password: password)
                    if viewModel.isSignedIn {
                        path.append(Routes.mainView)
                    }
                }
            }
        }.alert(isPresented: .constant(viewModel.displayError || displayInitWarning)) {
            let title = displayInitWarning ? R.string.localizable.initWarningTitle
            : R.string.localizable.error
            let message = displayInitWarning ? R.string.localizable.initWarningText
            : R.string.localizable.loginErrorText

            return Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("OK")) {
                    if displayInitWarning {
                        displayInitWarning = false
                    } else {
                        viewModel.displayError = false
                    }
                }
            )
        }
        .onAppear {
            if UserDefaults.standard.value(forKey: "token") != nil {
                path.append(Routes.mainView)
            } else if UserDefaults.standard.value(forKey: "init") == nil {
                UserDefaults.standard.set(true, forKey: "init")
                displayInitWarning = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(path: .constant(.init()))
    }
}
