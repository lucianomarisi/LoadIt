//
//  PlacesResource.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

private let baseURL = NSURL(string: "http://localhost:8000/")!

struct PlacesResource: NetworkResource, DiskResource {
  let url: NSURL
  let filename: String
  
  init(continent: String) {
    url = baseURL.URLByAppendingPathComponent("\(continent).json")
    filename = continent
  }
  
  func modelFrom(jsonDictionary jsonDictionary: JSONDictionary) -> [Place]? {
    guard let
      placesJSONArray: [JSONDictionary] = jsonDictionary.jsonKey("places")
      else {
        return []
    }
    return placesJSONArray.flatMap(Place.init)
  }
  
}