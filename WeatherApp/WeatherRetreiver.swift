//
//  WeatherRetreiver.swift
//  WeatherApp
//
//  Created by Alex Dombroski on 5/20/24.
//

import Foundation
import UIKit

    // Function that takes a URL uses completetion to allow the modifying of other varibables to save data from the API JSON dictionary resutlt
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
                    completion(json) // This will require a lambda function to save the data
                }
            } catch let jsonError {
                print("JSON Error: \(jsonError)")
                completion(nil)
            }
        }
        job.resume()
    }
}

