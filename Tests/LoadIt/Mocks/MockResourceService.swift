//
//  MockResourceService.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import LoadIt

class MockResourceService: ResourceServiceType {
  
  typealias Resource = MockResource
  
  var capturedResource: Resource?
  var capturedCompletion: ((Result<Resource.Model>) -> Void)?
  
  required init() {}
  
  func fetch(resource: Resource, completion: (Result<Resource.Model>) -> Void) {
    capturedResource = resource
    capturedCompletion = completion
  }
  
}
