//
//  UserDefaults.swift
//  SV Queuer
//
//  Created by Kevin Lopez on 2/2/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation

struct UserDefaultValues {

    static var apiKey: String {
        return UserDefaults.standard.string(forKey: "apiKey") ?? ""
    }

}
