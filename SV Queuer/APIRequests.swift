//
//  SVRequest.swift
//  SV Queuer
//
//  Created by Kevin Lopez on 2/2/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation

struct APIRequests {

    static var projects: URLRequest {
        var request = URLRequest(url: APIRoutes.projects)
        request.customizeHeaders()
        return request
    }
}

extension URLRequest {
    mutating func customizeHeaders() {
        addValue("application/json", forHTTPHeaderField: "Content-type")
        addValue(UserDefaultValues.apiKey, forHTTPHeaderField: "X-Qer-Authorization")
        addValue("application/json", forHTTPHeaderField: "Accept")
    }
}
