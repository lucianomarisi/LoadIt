//
//  CommonResourceOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 02/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

typealias CitiesCommonResourceOperation = CommonResourceOperation<DiskJSONService<CitiesResource>>

final class CommonResourceOperation<ResourceService: ResourceServiceType>: BaseOperation, ResourceOperation {
  
  typealias Resource = ResourceService.Resource
  
  private let resource: Resource
  private let service: ResourceService
  
  var didFinishFetchingResourceCallback: ((CommonResourceOperation<ResourceService>, Result<Resource.ModelType>) -> Void)?
  
  init(resource: ResourceService.Resource, service: ResourceService = ResourceService()) {
    self.resource = resource
    self.service = service
    super.init()
  }
  
  override func execute() {
    fetch(resource: resource, usingService: service)
  }
  
  func didFinishFetchingResource(result result: Result<Resource.ModelType>) {
    didFinishFetchingResourceCallback?(self, result)
  }
  
}
