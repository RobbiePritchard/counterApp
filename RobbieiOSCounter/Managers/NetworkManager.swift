//
//  NetworkManager.swift
//  RobbieiOSCounter
//
//  Created by Robbie Pritchard on 5/6/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import Foundation
import CoreData


// For JSON Parsing
struct CounterHolder: Codable {
    let counters: [Counter]?
}
struct Counter: Codable {
    let name: String
    let count: Int
}

//Results
enum NetworkResult{
    case success([Counter])
    case failure(String)
}

struct NetworkManager{
    
    private let urlString = "https://ios-sample-project.herokuapp.com/counters"
    private let apiKey = "95c5355a9b86a3f38351becdff54e22c58008b25b824f556736015ee3d887b0a"
    
    
    private func processRequest(data: Data?, error: Error?) -> NetworkResult{
        if error != nil {
            print(error!.localizedDescription)
            return NetworkResult.failure((error?.localizedDescription)!)
            
        }
        
        guard let data = data else { return NetworkResult.failure("Data is nil") }
        do {
            let counterData = try JSONDecoder().decode(CounterHolder.self, from: data)
            
            guard let newCounters = counterData.counters else {return NetworkResult.failure("Returned No Counters") }
            return NetworkResult.success(newCounters)
            
            
        } catch let error {
            return NetworkResult.failure(error.localizedDescription)
        }
    }
    
    func getSampleData(completion: @escaping(NetworkResult)-> Void){
        
        let url = URL(string: urlString)!
        
        var request = URLRequest(url:url)
        request.addValue("\(apiKey)", forHTTPHeaderField: "Authorization")
        
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            let result = self.processRequest(data: data, error: error)
            OperationQueue.main.addOperation {
                completion(result)
            }
        }
        task.resume()
    }

}
