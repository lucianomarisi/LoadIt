//
//  DiskOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol DiskOperation: ResourceOperation {
  associatedtype ResourceType: DiskResource
  var diskService: DiskService<ResourceType> { get }
}

extension DiskOperation {
  
  public func execute() {
    diskService.fetchResource(resource) { [weak self] (result) in
      //      if cancelled { return }
      NSThread.executeOnMain { [weak self] in
        //      if cancelled { return }
        guard let strongSelf = self else { return }
        strongSelf.informDelegateOfResult(result)
        //        finish()
      }
    }
  }
  
}
