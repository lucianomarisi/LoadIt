//
//  PlacesDiskJSONOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation
import LoadIt

protocol PlacesDiskJSONOperationDelegate: class {
  func placesOperationDidFinish(operation: PlacesDiskJSONOperation, result: Result<[Place]>)
}

final class PlacesDiskJSONOperation: BaseOperation, DiskJSONOperation {
  
  let diskJSONService: DiskJSONService<PlacesResource>
  let resource: PlacesResource
  private weak var delegate: PlacesDiskJSONOperationDelegate?
  
  init(continent: String, diskJSONService: DiskJSONService<PlacesResource> = DiskJSONService<PlacesResource>(), delegate: PlacesDiskJSONOperationDelegate) {
    self.resource = PlacesResource(continent: continent)
    self.diskJSONService = diskJSONService
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