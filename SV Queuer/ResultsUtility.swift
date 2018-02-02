//
//  ResultsUtility.swift
//  SV Queuer
//
//  Created by Kevin Lopez on 2/2/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

enum Result<T> {
    case success(T)
    case error(String)
}
