//
//  HttpUtility.swift
//  Assignment
//
//  Created by Abhishek Kumar Singh on 20/04/24.
//

import Foundation
struct HttpUtility {
    func getData<T:Decodable>(requestUrl: URL, resultType: T.Type,completionHandler:@escaping(_ result: T?)-> Void) {
       
        var urlRequest = URLRequest(url: requestUrl)
        urlRequest.httpMethod = "GET"
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: urlRequest) { (responseData, httpUrlResponse, error) in
            if (error == nil && responseData != nil && responseData?.count != 0) {
                let decoder = JSONDecoder()
                do {
                    let responseString = String(data: responseData!, encoding: String.Encoding.utf8)
                    debugPrint(responseString!)
                    let result = try decoder.decode(T.self, from: responseData!)
                    _=completionHandler(result)
                }
                
                catch let error{
                    _=completionHandler(nil)
                    debugPrint("error occured while decoding = \(error.localizedDescription)")
                }
            }
        }.resume()
    }
}
