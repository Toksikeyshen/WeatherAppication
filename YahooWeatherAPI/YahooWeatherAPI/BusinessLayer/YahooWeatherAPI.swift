//
//  YahooWeatherAPI.swift
//  YahooWeatherAPI
//
//  Created by user on 10/7/19.
//  Copyright © 2019 user. All rights reserved.
//

import Foundation
import OAuthSwift

enum YahooWeatherAPIResponseType:String {
    case json = "json"
    case xml = "xml"
}

enum YahooWeatherAPIUnitType:String {
    case imperial = "f"
    case metric = "c"
}

enum YahooWeatherAPICreditionals {
    static let appId = "EX1ZKd62"
    static let clientId = "dj0yJmk9ckJCYVFKMno5Q3RGJmQ9WVdrOVJWZ3hXa3RrTmpJbWNHbzlNQS0tJnM9Y29uc3VtZXJzZWNyZXQmc3Y9MCZ4PWVk"
    static let clientSecret = "f2310374600f76250add9d801056469375eabc42"
}

final class YahooWeatherAPI {
    
    private let url:String = "https://weather-ydn-yql.media.yahoo.com/forecastrss"
    private let oauth:OAuth1Swift?
    
    static let shared = YahooWeatherAPI()
    
    private init() {
        self.oauth = OAuth1Swift(consumerKey: YahooWeatherAPICreditionals.clientId, consumerSecret: YahooWeatherAPICreditionals.clientSecret)
    }
    
    private var headers:[String:String] {
        return [
            "X-Yahoo-App-Id": YahooWeatherAPICreditionals.appId
        ]
    }
    
    public func weather(location:String, failure: @escaping (_ error: OAuthSwiftError) -> Void, success: @escaping (_ response: OAuthSwiftResponse) -> Void, responseFormat:YahooWeatherAPIResponseType = .json, unit:YahooWeatherAPIUnitType = .metric) {
        self.makeRequest(parameters: ["location":location, "format":responseFormat.rawValue, "u":unit.rawValue], failure: failure, success: success)
    }
    
    private func makeRequest(parameters:[String:String], failure: @escaping (_ error: OAuthSwiftError) -> Void, success: @escaping (_ response: OAuthSwiftResponse) -> Void) {
        self.oauth?.client.request(self.url, method: .GET, parameters: parameters, headers: self.headers, body: nil, checkTokenExpiration: true, success: success, failure: failure)
    }
}
