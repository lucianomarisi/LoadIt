//
//  PlacesNetworkJSONOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

protocol PlacesNetworkJSONOperationDelegate: class {
  func placesOperationDidFinish(operation: PlacesNetworkJSONOperation, result: Result<[Place]>)
}

final class PlacesNetworkJSONOperation: BaseOperation, NetworkJSONOperation {
  
  let networkJSONService: NetworkJSONService<PlacesResource>
  let resource: PlacesResource
  private weak var delegate: PlacesNetworkJSONOperationDelegate?
    
  init(continent: String, networkJSONService: NetworkJSONService<PlacesResource> = NetworkJSONService<PlacesResource>(), delegate: PlacesNetworkJSONOperationDelegate) {
    self.resource = PlacesResource(continent: continent)
    self.networkJSONService = networkJSONService
    self.delegate = delegate
    super.init()
  }
  
  override func execute() {
    fetchResource()
  }

  func finishedWithResult(result: Result<[Place]>) {
    self.delegate?.placesOperationDidFinish(self, result: result)
  }
  
  deinit {
    print("PlacesNetworkJSONOperation deinit")
  }
  
}