//
//  ResourceOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 02/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

class ResourceOperation<ResourceService: ResourceServiceType>: BaseOperation, ResourceOperationType {
  
  typealias Resource = ResourceService.Resource
  typealias DidFinishFetchingResourceCallback = (ResourceOperation<ResourceService>, Result<Resource.Model>) -> Void

  private let resource: Resource
  private let service: ResourceService  
  private let didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback?
  
  init(resource: ResourceService.Resource, service: ResourceService = ResourceService(), didFinishFetchingResourceCallback: DidFinishFetchingResourceCallback? = nil) {
    self.resource = resource
    self.service = service
    self.didFinishFetchingResourceCallback = didFinishFetchingResourceCallback
    super.init()
  }
  
  override func execute() {
    fetch(resource: resource, usingService: service)
  }
  
  func didFinishFetchingResource(result result: Result<Resource.Model>) {
    didFinishFetchingResourceCallback?(self, result)
  }
  
}

protocol CitiesResourceOperationDelegate: class {
  func citiesOperationDidFinish(operation: CitiesResourceOperation, result: Result<[City]>)
}

final class CitiesResourceOperation: ResourceOperation<DiskJSONService<CitiesResource>> {
  
  private weak var delegate: CitiesResourceOperationDelegate?
  
  init(resource: CitiesResource, delegate: CitiesResourceOperationDelegate) {
    self.delegate = delegate
    super.init(resource: resource)
  }
  
  override func didFinishFetchingResource(result result: Result<[City]>) {
    self.delegate?.citiesOperationDidFinish(self, result: result)
  }
  
}