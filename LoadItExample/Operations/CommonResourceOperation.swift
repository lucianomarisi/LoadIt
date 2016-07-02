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

final class CommonResourceOperation<ResourceServiceType: ResourceService>: BaseOperation, ResourceOperation {
  
  typealias Resource = ResourceServiceType.Resource
  
  private let resource: Resource
  private let service: ResourceServiceType
  
  var didFinishFetchingResourceCallback: ((CommonResourceOperation<ResourceServiceType>, Result<Resource.ModelType>) -> Void)?
  
  init(resource: ResourceServiceType.Resource, service: ResourceServiceType = ResourceServiceType()) {
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
