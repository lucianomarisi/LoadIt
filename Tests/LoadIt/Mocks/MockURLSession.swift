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
  var capturedRequest: URLRequest?
  var capturedCompletion: ((Data?, URLResponse?, NSError?) -> Void)?
  
  func perform(request: URLRequest, completion: (Data?, URLResponse?, NSError?) -> Void) {
    capturedRequest = request
    capturedCompletion = completion
  }
  
}
