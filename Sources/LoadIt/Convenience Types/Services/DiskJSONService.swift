//
//  DiskJSONService.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

enum DiskJSONServiceError: ErrorProtocol {
  case fileNotFound
  case noData
}

public struct DiskJSONService<Resource: DiskJSONResourceType> {
  
  private let bundle: BundleType
  
  public init() {
    self.init(bundle: Bundle.main)
  }
  
  init(bundle: BundleType) {
    self.bundle = bundle
  }
  
  private func resultFrom(resource: Resource) -> Result<Resource.Model>{
    guard let url = bundle.URLForResource(resource.filename, withExtension: "json") else {
      return.failure(DiskJSONServiceError.fileNotFound)
    }
    
    guard let data = try? Data(contentsOf: url) else {
      return.failure(DiskJSONServiceError.noData)
    }
    
    return resource.resultFrom(data: data)
  }
}

// MARK: - ResourceServiceType
extension DiskJSONService: ResourceServiceType {
  
  public func fetch(resource: Resource, completion: (Result<Resource.Model>) -> Void) {
    completion(resultFrom(resource: resource))
  }
  
}
