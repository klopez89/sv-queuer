//
//  APIConstants.swift
//  SV Queuer
//
//  Created by Kevin Lopez on 2/2/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import  Foundation

struct APIRoutes {

    static let rootURL = "https://queuer-production.herokuapp.com/api/v1/"

    static var projects: URL {
        return URL(string: rootURL.appending("projects"))!
    }
}
