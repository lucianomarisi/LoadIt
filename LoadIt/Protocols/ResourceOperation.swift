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

public protocol ResourceOperation: Cancellable, Finishable {

  associatedtype ResourceType: Resource

  /**
   Fetches a resource using the provided service
   
   - parameter resource: The resource to fetch
   - parameter service:  The service to be used for fetching the resource
   */
  func fetch<T: ResourceService where T.ResourceType == ResourceType>(resource resource:ResourceType, usingService service: T)

  /**
   Called when the operation has finished
   
   - parameter result: The result of the operation
   */
  func didFinishFetchingResource(result result: Result<ResourceType.ModelType>)
}

public extension ResourceOperation {
  
  public func fetch<T: ResourceService where T.ResourceType == ResourceType>(resource resource:ResourceType, usingService service: T) {
    if cancelled { return }
    service.fetch(resource: resource) { [weak self] (result) in
      guard let strongSelf = self else { return }
      if strongSelf.cancelled { return }
      NSThread.executeOnMain { [weak self] in
        guard let strongSelf = self else { return }
        if strongSelf.cancelled { return }
        strongSelf.finish([])
        strongSelf.didFinishFetchingResource(result: result)
      }
    }
  }
  
}