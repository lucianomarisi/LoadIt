//
//  ResourceOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 02/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

final class ResourceOperation<ResourceService: ResourceServiceType>: BaseOperation, ResourceOperationType {
  
  typealias Resource = ResourceService.Resource
  typealias DidFinishFetchingResourceCallback = (ResourceOperation<ResourceService>, Result<Resource.Model>) -> Void

  private let resource: Resource
  private let service: ResourceService  
  private let didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback
  
  init(resource: ResourceService.Resource, service: ResourceService = ResourceService(), didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback) {
    self.resource = resource
    self.service = service
    self.didFinishFetchingResourceCallback = didFinishFetchingResourceCallback
    super.init()
  }
  
  override func execute() {
    fetch(resource: resource, usingService: service)
  }
  
  func didFinishFetchingResource(result result: Result<Resource.Model>) {
    didFinishFetchingResourceCallback(self, result)
  }
  
}
