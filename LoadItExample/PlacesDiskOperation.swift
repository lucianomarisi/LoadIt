//
//  PlacesDiskOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

protocol PlacesDiskOperationDelegate: class {
  func placesOperationDidFinish(operation: PlacesDiskOperation, result: Result<[Place]>)
}

final class PlacesDiskOperation: DiskOperation {
  
  let diskService = DiskService<PlacesResource>()
  let resource: PlacesResource
  private weak var delegate: PlacesDiskOperationDelegate?
  
  init(continent: String, delegate: PlacesDiskOperationDelegate) {
    self.resource = PlacesResource(continent: continent)
    self.delegate = delegate
  }
  
  func informDelegateOfResult(result: Result<[Place]>) {
    //      if cancelled { return }
    self.delegate?.placesOperationDidFinish(self, result: result)
  }
  
}
