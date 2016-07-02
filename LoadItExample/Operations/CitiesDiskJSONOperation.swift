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

final class CitiesResourceOperation<ResourceServiceType: ResourceService where ResourceServiceType.ResourceType == CitiesResource>: BaseOperation, ResourceOperation {
  
  typealias ResourceType = CitiesResource
  
  private let resource: CitiesResource
  private let service: ResourceServiceType
  private weak var delegate: CitiesResourceOperationDelegate?

  var didFinishFetchingResourceCallback: ((CitiesResourceOperation<ResourceServiceType>, Result<[City]>) -> Void)?
  
  init(resource: CitiesResource, service: ResourceServiceType = ResourceServiceType(), delegate: CitiesResourceOperationDelegate) {
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

