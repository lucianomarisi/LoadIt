//
//  ResourceOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 26/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/// Define a type that is cancellable
public protocol Cancellable: class {
  /// Returns whether or not the type has been cancelled
  var cancelled: Bool { get }
}

public protocol Finishable: class {
  /**
   Method to be called when the type finished all it's work
   
   - parameter errors: Any error from the work done
   */
  func finish(errors: [NSError])
}

public protocol ResourceOperationType: Cancellable, Finishable {
  
  associatedtype Resource: ResourceType
  
  /**
   Fetches a resource using the provided service
   
   - parameter resource: The resource to fetch
   - parameter service:  The service to be used for fetching the resource
   */
  func fetch<Service: ResourceServiceType where Service.Resource == Resource>(resource resource: Resource, usingService service: Service)
  
  /**
   Called when the operation has finished, called on Main thread
   
   - parameter result: The result of the operation
   */
  func didFinishFetchingResource(result result: Result<Resource.Model>)
}

public extension ResourceOperationType {
  
  public func fetch<Service: ResourceServiceType where Service.Resource == Resource>(resource resource: Resource, usingService service: Service) {
    if cancelled { return }
    service.fetch(resource: resource) { [weak self] (result) in
      NSThread.li_executeOnMain { [weak self] in
        guard let strongSelf = self else { return }
        if strongSelf.cancelled { return }
        strongSelf.finish([])
        strongSelf.didFinishFetchingResource(result: result)
      }
    }
  }
  
}
