//
//  NetworkHelper.swift
//  Easybuy
//
//  Created by Yoav on 11/05/2020.
//  Copyright © 2020 Yoav. All rights reserved.
//

import Foundation

struct NetworkHelper {
    func createGetRecommendationsUrl(with userId: String?, amount: Int?) -> URL? {
        var urlComponents = URLComponents(string: "https://yoav05.pythonanywhere.com/recommendations")
        var queryParams = [URLQueryItem]()
        if let userId = userId {
            queryParams.append(URLQueryItem(name: "userId", value: userId))
        }
        if let amount = amount {
            queryParams.append(URLQueryItem(name: "amount", value: String(amount)))
        }

        urlComponents?.queryItems = queryParams
        
        return urlComponents?.url

    }

    func createSearcUrl(with categories: [String]) -> URLRequest? {
        guard let url = URL(string: "https://yoav05.pythonanywhere.com/search") else { return nil }
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        let parameters = ["categories": categories]
        request.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        return request
    }
}
