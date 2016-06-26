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
  
  func modelFrom(jsonDictionary jsonDictionary: [String: AnyObject]) -> [Place]? {
    guard let
      placesJSONArray: [[String: AnyObject]] = jsonDictionary["places"] as? [[String: AnyObject]]
      else {
        return []
    }
    return placesJSONArray.flatMap(Place.init)
  }
  
}