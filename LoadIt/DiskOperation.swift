//
//  DiskOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

//public protocol DiskOperationProtocol: class {
//  associatedtype ResourceType: JSONResource
//  func finishedWithResult(result: Result<ResourceType.ModelType>)
//}

public class DiskOperation<DiskResourceType: DiskResource>: BaseOperation {//, DiskOperationProtocol {

  public typealias ResourceType = DiskResourceType

  private let diskService = DiskService<ResourceType>()
  private let resource: ResourceType

  public init(resource: ResourceType) {
    self.resource = resource
  }
  
  public func finishedWithResult(result: Result<ResourceType.ModelType>) {}
  
  public func execute() {
    diskService.fetchResource(resource) { [weak self] (result) in
      guard let strongSelf = self else { return }
      if strongSelf.cancelled { return }
      NSThread.executeOnMain { [weak self] in
        guard let strongSelf = self else { return }
        if strongSelf.cancelled { return }
        strongSelf.finishedWithResult(result)
        strongSelf.finish()
      }
    }
  }
  
}

