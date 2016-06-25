//
//  PlacesNetworkOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

protocol PlacesNetworkOperationDelegate: class {
  func placesOperationDidFinish(operation: PlacesNetworkOperation, result: Result<[Place]>)
}

final class PlacesNetworkOperation: NetworkOperation {
  
  let networkService = NetworkService<PlacesResource>()
  let resource: PlacesResource
  private weak var delegate: PlacesNetworkOperationDelegate?
  
  init(continent: String, delegate: PlacesNetworkOperationDelegate) {
    self.resource = PlacesResource(continent: continent)
    self.delegate = delegate
  }
  
  func informDelegateOfResult(result: Result<[Place]>) {
    //      if cancelled { return }
    self.delegate?.placesOperationDidFinish(self, result: result)
  }
  
}