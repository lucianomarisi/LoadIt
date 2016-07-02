//
//  CitiesResource.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

private let baseURL = NSURL(string: "http://localhost:8000/")!

struct CitiesResource: NetworkJSONResourceType, DiskJSONResourceType {
  typealias Model = [City]
  
  let url: NSURL
  let filename: String
  
  init(continent: String) {
    url = baseURL.URLByAppendingPathComponent("\(continent).json")
    filename = continent
  }
  
  //MARK: JSONResource
  func modelFrom(jsonDictionary jsonDictionary: [String: AnyObject]) -> [City]? {
    guard let
      citiesJSONArray: [[String: AnyObject]] = jsonDictionary["cities"] as? [[String: AnyObject]]
      else {
        return []
    }
    return citiesJSONArray.flatMap(City.init)
  }
  
}