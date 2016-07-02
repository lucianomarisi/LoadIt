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
  func citiesOperationDidFinish(operation: CitiesDiskJSONOperation, result: Result<[City]>)
}

final class CitiesDiskJSONOperation: BaseOperation, ResourceOperation {
  
  typealias ResourceType = CitiesResource
  
  private let resource: CitiesResource
  private weak var delegate: CitiesDiskJSONOperationDelegate?
  private let diskJSONService: DiskJSONService<CitiesResource>
  
  init(resource: CitiesResource, service: DiskJSONService<CitiesResource> = DiskJSONService<CitiesResource>(), delegate: CitiesDiskJSONOperationDelegate) {
    self.resource = resource
    self.diskJSONService = service
    self.delegate = delegate
    super.init()
  }
  
  override func execute() {
    fetch(resource: resource, usingService: diskJSONService)
  }
  
  func didFinishFetchingResource(result result: Result<[City]>) {
    self.delegate?.citiesOperationDidFinish(self, result: result)
  }
  
}
