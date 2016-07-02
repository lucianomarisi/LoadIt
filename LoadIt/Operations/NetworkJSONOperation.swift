//
//  NetworkJSONOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol NetworkJSONOperation: ResourceOperation {
  associatedtype ResourceType: NetworkJSONResource
  var networkJSONService: NetworkJSONService<ResourceType> { get }
}

public extension NetworkJSONOperation {
  
  public func fetchResource() {
    if cancelled { return }
    networkJSONService.fetch(resource: resource) { [weak self] (result) in
      guard let strongSelf = self else { return }
      if strongSelf.cancelled { return }
      NSThread.executeOnMain { [weak self] in
        guard let strongSelf = self else { return }
        if strongSelf.cancelled { return }
        strongSelf.finish([])
        strongSelf.didFinish(result: result)
      }
    }
  }
  
}
