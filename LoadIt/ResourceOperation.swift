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
  func finish()
}

public protocol ResourceOperation: Cancellable, Finishable {
  associatedtype ResourceType: JSONResource
  var resource: ResourceType { get }
  func finishedWithResult(result: Result<ResourceType.ModelType>)
}
