//
//  CitiesResourceOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

typealias CitiesDiskResourceOperation = CitiesResourceOperation<DiskJSONService<CitiesResource>>

protocol CitiesResourceOperationDelegate: class {
  func citiesOperationDidFinish(result result: Result<[City]>)
}

final class CitiesResourceOperation<ResourceService: ResourceServiceType where ResourceService.Resource == CitiesResource>: BaseOperation, ResourceOperationType {
  
  typealias Resource = CitiesResource
  
  private let resource: CitiesResource
  private let service: ResourceService
  private weak var delegate: CitiesResourceOperationDelegate?
  
  init(resource: CitiesResource, service: ResourceService = ResourceService(), delegate: CitiesResourceOperationDelegate) {
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

