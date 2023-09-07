//
//  AccountView.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 07/09/2023.
//

import SwiftUI

struct AccountView: View {

    @Binding var path: NavigationPath

    var body: some View {
        Button(action: {
            UserDefaults.standard.removeObject(forKey: "token")
            path = .init()
        }, label: {
            Text(R.string.localizable.signout)
        })
        .tint(.red)
        .navigationBarTitle(R.string.localizable.account.callAsFunction())
    }
}

struct AccountView_Previews: PreviewProvider {
    static var previews: some View {
        AccountView(path: .constant(.init()))
    }
}
