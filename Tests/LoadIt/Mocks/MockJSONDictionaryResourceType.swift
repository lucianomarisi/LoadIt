//
//  MockJSONDictionaryResourceType.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
@testable import LoadIt

struct MockJSONDictionaryResourceType: JSONResourceType {
  typealias Model = MockObject
  
  func modelFrom(jsonDictionary: [String : AnyObject]) -> MockObject? {
    return MockObject(jsonDictionary: jsonDictionary)
  }
  
}
