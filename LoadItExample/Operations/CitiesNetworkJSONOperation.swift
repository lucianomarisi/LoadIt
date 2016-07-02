//
//  CitiesNetworkJSONOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

protocol CitiesNetworkJSONOperationDelegate: class {
  func citiesOperationDidFinish(operation: CitiesNetworkJSONOperation, result: Result<[City]>)
}

final class CitiesNetworkJSONOperation: BaseOperation, ResourceOperation {
  
  typealias ResourceType = CitiesResource
  typealias CitiesService = NetworkJSONService<CitiesResource>
  
  private let resource: CitiesResource
  private let service: CitiesService
  private weak var delegate: CitiesNetworkJSONOperationDelegate?
  
  init(resource: CitiesResource, service: CitiesService = CitiesService(), delegate: CitiesNetworkJSONOperationDelegate) {
    self.resource = resource
    self.service = service
    self.delegate = delegate
    super.init()
  }
  
  override func execute() {
    fetch(resource: resource, usingService: service)
  }

  func didFinishFetchingResource(result result: Result<[City]>) {
    self.delegate?.citiesOperationDidFinish(self, result: result)
  }
  
}
