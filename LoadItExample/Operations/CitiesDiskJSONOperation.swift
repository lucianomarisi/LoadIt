//
//  CitiesDiskJSONOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

protocol CitiesDiskJSONOperationDelegate: class {
  func citiesOperationDidFinish(result result: Result<[City]>)
}

final class CitiesDiskJSONOperation<ResourceServiceType: ResourceService where ResourceServiceType.ResourceType == CitiesResource>: BaseOperation, ResourceOperation {
  
  typealias ResourceType = CitiesResource
  
  private let resource: CitiesResource
  private let service: ResourceServiceType
  private weak var delegate: CitiesDiskJSONOperationDelegate?

//  init(resource: CitiesResource, service: ResourceServiceType = DiskJSONService<CitiesResource>(), delegate: CitiesDiskJSONOperationDelegate) {
  init(resource: CitiesResource, service: ResourceServiceType, delegate: CitiesDiskJSONOperationDelegate) {
    self.resource = resource
    self.service = service
    self.delegate = delegate
    super.init()
  }
  
  override func execute() {
    fetch(resource: resource, usingService: service)
  }
  
  func didFinishFetchingResource(result result: Result<[City]>) {
    self.delegate?.citiesOperationDidFinish(result: result)
  }
  
}
