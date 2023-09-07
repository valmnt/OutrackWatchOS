//
//  NetworkConstants.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

struct NetworkConstants {
    static var baseUrl: String {
        url + version
    }

    private static let url = "https://outtrack.kubehost.fr/api"
    private static let version = "/v1"

    struct Auth {
        private static let prefix = "/auth"
        static let login = prefix + "/signin"
    }
}
