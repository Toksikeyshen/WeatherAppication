//
//  Weather.swift
//  YahooWeatherAPI
//
//  Created by user on 10/7/19.
//  Copyright © 2019 user. All rights reserved.
//
    
import Foundation
    
struct WeatherResponce: Decodable {
    let forecasts: [Day]
}
    
struct Day: Decodable {
    let day: String
    let text: String
    let high: Int
    let low: Int
}
