//
//  ParseJSONService.swift
//  YahooWeatherAPI
//
//  Created by user on 10/8/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import Reachability

enum ApiError: Error {
    case noData, noConnection, parseJSONError
}

enum Result<Success, Failure> where Failure: Error {
    case success(Success), failure(Failure)
}

final class ParseJSONService {
    private var weatherArray: [Day] = []
    
    static let shared = ParseJSONService()
    
    func parse(location: String, complition: @escaping(Result<[Day], ApiError>) -> Void) {
        guard let reachability = Reachability() else { return }
        if reachability.connection != .none {
            YahooWeatherAPI.shared.weather(location: location, failure: { (error) in
                complition(.failure(.noData))
            }, success: { (response) in
                do {
                    let weatherResponse = try JSONDecoder().decode(WeatherResponce.self, from: response.data)
                    let weatherDetails = weatherResponse.forecasts
                    complition(.success(weatherDetails))
                } catch {
                    complition(.failure(.parseJSONError))
                }
            }, responseFormat: .json, unit: .metric)
        } else {
            complition(.failure(.noConnection))
        }
    }
}
