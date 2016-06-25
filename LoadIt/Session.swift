//
//  Session.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

protocol Session {
  func performRequest(request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void)
}

extension NSURLSession: Session {
  public func performRequest(request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    dataTaskWithRequest(request, completionHandler: completion).resume()
  }
}
