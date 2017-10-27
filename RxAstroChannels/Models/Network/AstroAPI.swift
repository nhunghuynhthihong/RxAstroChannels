//
//  AstroAPI.swift
//  RxAstroChannels
//
//  Created by Candice H on 10/24/17.
//  Copyright © 2017 Candice H. All rights reserved.
//

import Foundation
import RxSwift

// MARK: - API errors
enum EOError: Error {
    case invalidURL(String)
    case invalidParameter(String, Any)
    case invalidJSON(String)
}

class AstroAPI {
    
    // MARK: - API Addresses
    enum URLAddress: String {
        case channels = "getChannels"
        case events = "getEvents"
        case channelsList = "getChannelList"
        
        private var baseURL: String { return "http://ams-api.astro.com.my/ams/v3/" }
        var url: URL {
            return URL(string: baseURL.appending(rawValue))!
        }
    }
    
    // MARK: - generic request
    static func request(endpoint: URLAddress, query: [String: Any] = [:]) -> Observable<[String: Any]> {
        do {
            
            guard var components = URLComponents(url: endpoint.url, resolvingAgainstBaseURL: true) else {
                throw EOError.invalidURL(endpoint.stringValue)
            }
            if query.count > 0 {
                components.queryItems = try query.flatMap({ (key, value) in
                    guard let v = value as? CustomStringConvertible else {
                        throw EOError.invalidParameter(key, value)
                    }
                    return URLQueryItem(name: key, value: v.description)
                })
            }
            guard  let finalURL = components.url else {
                throw EOError.invalidURL(endpoint.stringValue)
            }
            
            var request = URLRequest(url: finalURL)
            request.httpMethod = "GET"
            return URLSession.shared.rx.response(request: request).map({  (_, data) -> [String: Any] in
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []), let result = jsonObject as? [String: Any] else {
                    throw EOError.invalidJSON(finalURL.absoluteString)
                }
                return result
            })
        } catch {
            return Observable.empty()
        }
    }
    
    static var channels: Observable<[Channel]> = {
        // Requestdatafromthecategoriesendpoint.
        return request(endpoint: URLAddress.channelsList).map { data in
            // Extract the channels array from the respons.
            let channels = data["channels"] as? [[String: Any]] ?? []
            // Map it to an array of Channel objects.
            return channels.flatMap(Channel.init)
        }
    }()
    
    static func getEvents(withChannelIDs ids: [Int]) -> Observable<[Event]> {
        let now = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let periodStart = ("\(dateFormatter.string(from: now.yesterday))" + " 00:00")
        let periodEnd = ("\(dateFormatter.string(from: now.tomorrow))" + " 23:59")
        let params = ["channelId": ids, "periodStart": periodStart, "periodEnd": periodEnd] as [String : Any]
        
        print("channelIds \(ids) periodStart \(periodStart) periodEnd \(periodEnd)")
        return request(endpoint: URLAddress.events, query: params).map { data in
            let channels = data["getevent"] as? [[String: Any]] ?? []
            return channels.flatMap(Event.init)
            }
    }
}
