//
//  LoginService.swift
//  OutrackWatchApp
//
//  Created by Valentin Mont on 05/09/2023.
//

import Foundation

class LoginService: HTTPPostService {
    var url: String = NetworkConstants.baseUrl + NetworkConstants.Auth.login

    var queryParameters: [String: String] = [:]
    var headers: [String: String] = [:]
    var task: HTTPPostTask = HTTPPostTask()

    func proccess<E>(dto: E) async where E: Encodable {
        await task.post(url: url, dto: dto, decodeType: LoginResponse.self)
    }
}

struct LoginResponse: Decodable {
    var message: LoginData
}

struct LoginData: Decodable {
    var token: String
}
