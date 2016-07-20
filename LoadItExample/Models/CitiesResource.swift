//
//  CitiesResource.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

private let baseURL = URL(string: "http://localhost:8000/")!

struct CitiesResource: NetworkJSONResourceType, DiskJSONResourceType {
  typealias Model = [City]
  
  let url: URL
  let filename: String
  
  init(continent: String) {
    url = try! baseURL.appendingPathComponent("\(continent).json")
    filename = continent
  }
  
  //MARK: JSONResource
  func modelFrom(jsonDictionary: [String: AnyObject]) -> [City]? {
    guard let
      citiesJSONArray: [[String: AnyObject]] = jsonDictionary["cities"] as? [[String: AnyObject]]
      else {
        return []
    }
    return citiesJSONArray.flatMap(City.init)
  }
  
}
