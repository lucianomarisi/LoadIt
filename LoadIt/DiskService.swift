//
//  DiskService.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

enum DiskServiceError: ErrorType {
  case NoData
  case FileNotFound
}

public struct DiskService<ResourceType: DiskResource> {
  
  private let bundle: Bundle
  
  public init() {
    self.init(bundle: NSBundle.mainBundle())
  }
  
  init(bundle: Bundle) {
    self.bundle = bundle
  }
  
  public func fetchResource(resource: ResourceType, completion: (Result<ResourceType.ModelType>) -> Void) {
    completion(resultFrom(resource: resource))
  }
  
  private func resultFrom(resource resource: ResourceType) -> Result<ResourceType.ModelType>{
    guard let url = bundle.URLForResource(resource.filename, withExtension: "json") else {
      return.Failure(DiskServiceError.FileNotFound)
    }
    
    guard let data = NSData(contentsOfURL: url) else {
      return.Failure(DiskServiceError.NoData)
    }
    
    return resource.resultFrom(data: data)
  }
}
