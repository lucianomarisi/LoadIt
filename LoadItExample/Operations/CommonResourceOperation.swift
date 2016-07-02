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
  
  typealias ResourceType = ResourceServiceType.ResourceType
  
  private let resource: ResourceType
  private let service: ResourceServiceType
  
  var didFinishFetchingResourceCallback: ((CommonResourceOperation<ResourceServiceType>, Result<ResourceType.ModelType>) -> Void)?
  
  init(resource: ResourceServiceType.ResourceType, service: ResourceServiceType = ResourceServiceType()) {
    self.resource = resource
    self.service = service
    super.init()
  }
  
  override func execute() {
    fetch(resource: resource, usingService: service)
  }
  
  func didFinishFetchingResource(result result: Result<ResourceType.ModelType>) {
    didFinishFetchingResourceCallback?(self, result)
  }
  
}
