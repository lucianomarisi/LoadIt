//
//  MockObject.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

struct MockObject {
  let name: String
}

extension MockObject {
  init?(jsonDictionary: [String : AnyObject]) {
    guard let parsedName = jsonDictionary["name"] as? String else {
      return nil
    }
    name = parsedName
  }
}

extension MockObject: Equatable {}

func ==(lhs: MockObject, rhs: MockObject) -> Bool {
  return lhs.name == rhs.name
}
