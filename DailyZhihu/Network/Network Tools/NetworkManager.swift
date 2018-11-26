//
//  NetworkService.swift
//  DailyZhihu
//
//  Created by kakyo on 2018/11/26.
//  Copyright © 2018 Big Nerd Ranch. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    
    var baseURL = "http://news-at.zhihu.com/api/"
    
    static var shared = NetworkManager()
    
    func request(_ requestURL: String, success: @escaping (_ response: NSDictionary) -> Void, failure: @escaping (_ error: Error) -> Void) {
        Alamofire.request(requestURL, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            if response.error == nil {
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    success(JSON)
                }
            } else {
                print("Request failed.")
                failure(response.error!)
            }
        }
    }
}
