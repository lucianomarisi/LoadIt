//
//  URLSessionType.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

protocol URLSessionType {
  func perform(request: URLRequest, completion: (Data?, URLResponse?, NSError?) -> Void)
}

extension URLSession: URLSessionType {
  public func perform(request: URLRequest, completion: (Data?, URLResponse?, NSError?) -> Void) {
    dataTask(with: request, completionHandler: completion).resume()
  }
}
