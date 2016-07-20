//
//  MockURLSession.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import LoadIt

final class MockURLSession: URLSessionType {
  var capturedRequest: NSURLRequest?
  var capturedCompletion: ((NSData?, NSURLResponse?, NSError?) -> Void)?
  
  func perform(request request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    capturedRequest = request
    capturedCompletion = completion
  }
  
}
