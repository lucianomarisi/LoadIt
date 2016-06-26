//
//  DiskJSONService.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

enum DiskJSONServiceError: ErrorType {
  case FileNotFound
  case NoData
}

public struct DiskJSONService<ResourceType: DiskJSONResource> {
  
  private let bundle: Bundle
  
  public init() {
    self.init(bundle: NSBundle.mainBundle())
  }
  
  init(bundle: Bundle) {
    self.bundle = bundle
  }
  
  public func fetch(resource resource: ResourceType, completion: (Result<ResourceType.ModelType>) -> Void) {
    completion(resultFrom(resource: resource))
  }
  
  private func resultFrom(resource resource: ResourceType) -> Result<ResourceType.ModelType>{
    guard let url = bundle.URLForResource(resource.filename, withExtension: "json") else {
      return.Failure(DiskJSONServiceError.FileNotFound)
    }
    
    guard let data = NSData(contentsOfURL: url) else {
      return.Failure(DiskJSONServiceError.NoData)
    }
    
    return resource.resultFrom(data: data)
  }
}
