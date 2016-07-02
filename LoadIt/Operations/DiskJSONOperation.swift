//
//  DiskJSONOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol DiskJSONOperation: ResourceOperation {
  associatedtype ResourceType: DiskJSONResource
  var diskJSONService: DiskJSONService<ResourceType> { get }
}

public extension DiskJSONOperation {
  
  public func fetchResource() {
    if cancelled { return }
    diskJSONService.fetch(resource: resource) { [weak self] (result) in
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
