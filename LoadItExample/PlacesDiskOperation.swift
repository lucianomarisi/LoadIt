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

final class PlacesDiskOperation: BaseOperation, DiskOperation {
  
  let diskService: DiskService<PlacesResource>
  let resource: PlacesResource
  private weak var delegate: PlacesDiskOperationDelegate?
  
  init(continent: String, diskService: DiskService<PlacesResource> = DiskService<PlacesResource>(), delegate: PlacesDiskOperationDelegate) {
    self.resource = PlacesResource(continent: continent)
    self.diskService = diskService
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
    print("PlacesNetworkOperation deinit")
  }
  
}