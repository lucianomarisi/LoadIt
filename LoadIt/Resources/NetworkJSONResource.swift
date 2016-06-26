//
//  NetworkJSONResource.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol NetworkJSONResource: JSONResource {
  var url: NSURL { get }
  var HTTPMethod: String { get }
  var allHTTPHeaderFields: [String: String]? { get }
  var JSONBody: AnyObject? { get }
}

// MARK: - NetworkJSONResource defaults
extension NetworkJSONResource {
  public var HTTPMethod: String { return "GET" }
  public var allHTTPHeaderFields: [String: String]? { return nil }
  public var JSONBody: AnyObject? { return nil }
}

// MARK: - Request building
extension NetworkJSONResource {
  func urlRequest() -> NSMutableURLRequest {
    let request = NSMutableURLRequest(URL: url)
    request.allHTTPHeaderFields = allHTTPHeaderFields
    request.HTTPMethod = HTTPMethod
    
    if let body = JSONBody {
      request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
    }
    
    return request
  }
}
