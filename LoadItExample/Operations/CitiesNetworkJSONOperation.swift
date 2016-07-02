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
  
  let resource: CitiesResource
  
  private weak var delegate: CitiesNetworkJSONOperationDelegate?
  private let networkJSONService: NetworkJSONService<CitiesResource>
  
  init(continent: String, networkJSONService: NetworkJSONService<CitiesResource> = NetworkJSONService<CitiesResource>(), delegate: CitiesNetworkJSONOperationDelegate) {
    self.resource = CitiesResource(continent: continent)
    self.networkJSONService = networkJSONService
    self.delegate = delegate
    super.init()
  }
  
  override func execute() {
    fetchResource(service: networkJSONService)
  }

  func didFinish(result result: Result<[City]>) {
    self.delegate?.citiesOperationDidFinish(self, result: result)
  }
  
}