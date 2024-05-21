//
//  WeatherRetreiver.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import Foundation
import UIKit

func getData(url: String, completion: @escaping ([String: Any]?) -> Void) {
    if let url = URL(string: url) {
        let job = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data else {
                print("Error: API gave no data")
                completion(nil)
                return
            }
            
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    completion(json)
                }
            } catch let jsonError {
                print("JSON Error: \(jsonError)")
                completion(nil)
            }
        }
        job.resume()
    }
}

