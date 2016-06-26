//
//  ResourceOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 26/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol Cancellable: class {
  var cancelled: Bool { get }
}

public protocol Finishable: class {
  func finish(errors: [NSError])
}

public protocol ResourceOperation: Cancellable, Finishable {
  associatedtype ResourceType: Resource
  var resource: ResourceType { get }
  func finished(result result: Result<ResourceType.ModelType>)
}
