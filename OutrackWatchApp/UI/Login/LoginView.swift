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
                    path.append(Routes.mainView)
                }
            }
        }.alert(isPresented: .constant(viewModel.displayAlert)) {
            Alert(
                title: Text(R.string.localizable.error),
                message: Text(R.string.localizable.loginErrorText),
                dismissButton: .default(Text("OK")) {
                    viewModel.displayAlert = false
                }
            )
        }
        .onAppear {
            if UserDefaults.standard.value(forKey: "token") != nil {
                path.append(Routes.mainView)
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(path: .constant(.init()))
    }
}
