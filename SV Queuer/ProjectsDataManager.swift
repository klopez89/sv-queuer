//
//  ProjectsDataManager.swift
//  SV Queuer
//
//  Created by Kevin Lopez on 2/2/18.
//  Copyright © 2018 Silicon Villas. All rights reserved.
//

import Foundation

struct ProjectsDataManager {

    typealias projectType = Array<Dictionary<String, AnyObject?>>
    typealias requestCompletion<T> = (_ results: Result<T>) -> ()
    typealias successCompletion = (_ success: Bool) -> ()

    static func requestProjects(completion: @escaping ( (_ projects: projectType?, _ error: String) -> () )) {

        let request = APIRequests.projects
        sendResultRequest(request, with: projectType.self) { (result) in
            switch result {
            case .success(let projects):
                completion(projects, "")
            case .error(let error):
                completion(nil, error)
            }
        }
    }

    static func createNewProject(_ title: String, completion: @escaping successCompletion) {
        let params = [ "project" : ["name" : title, "color" : -13508189]]
        let paramData = try? JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        var request = APIRequests.projects
        request.httpBody = paramData
        request.httpMethod = "POST"
        sendSuccessRequest(request) { (success) in
            completion(success)
        }
    }

    private static func sendSuccessRequest(_ request: URLRequest, completion: @escaping successCompletion) {
        URLSession(configuration: .default).dataTask(with: request, completionHandler: { (data, response, optError) in

            DispatchQueue.main.async {
                completion(optError == nil)
            }
        }).resume()
    }

    private static func sendResultRequest<T>(_ request: URLRequest, with resultType: T.Type, completion: @escaping requestCompletion<T> ) {
        URLSession(configuration: .default).dataTask(with: request, completionHandler: { (data, response, optError) in

            DispatchQueue.main.async {
                if let error = optError {
                    completion(Result<T>.error(error.localizedDescription))
                } else if let jsonData = data {
                    do {
                        let object = try JSONSerialization.jsonObject(with: jsonData, options: .allowFragments) as! T
                        completion(Result.success(object))
                    } catch {
                        completion(Result<T>.error("Error parsing json!"))
                    }
                } else {
                    completion(Result<T>.error("Something went wrong downloading data"))
                }
            }
        }).resume()
    }
}
