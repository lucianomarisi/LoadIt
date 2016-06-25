//
//  Place.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

struct Place {
  let name: String
}

extension Place {
  init?(jsonDictionary: JSONDictionary) {
    do {
      name = try jsonDictionary.jsonKey("name")
    } catch {
      return nil
    }
  }
}