//
//  ViewController.swift
//  LoadItExample
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit
import LoadIt

class ViewController: UIViewController {

  private let operationQueue = NSOperationQueue()

  override func viewDidLoad() {
    super.viewDidLoad()    
    let placesNetworkJSONOperation = PlacesNetworkJSONOperation(continent: "europe", delegate: self)
    operationQueue.addOperation(placesNetworkJSONOperation)
//    placesNetworkJSONOperation.cancel()
//    operationQueue.cancelAllOperations()
    
    let placesDiskJSONOperation = PlacesDiskJSONOperation(continent: "asia", delegate: self)
    operationQueue.addOperation(placesDiskJSONOperation)
//    placesDiskJSONOperation.cancel()

//    operationQueue.cancelAllOperations()

    
    let placesResource = PlacesResource(continent: "america")
    
    let diskJSONService = DiskJSONService<PlacesResource>()
    diskJSONService.fetchResource(placesResource) {[weak self] result in
      self?.log(result: result)
    }
    
    let networkJSONService = NetworkJSONService<PlacesResource>()
    networkJSONService.fetchResource(placesResource) { [weak self] result in
      self?.log(result: result)
    }
    
  }
    
  func log(result result: Result<[Place]>) {
    if case .Success(let places) = result {
      print(places)
    } else {
      print(result)
    }
  }
  
}

extension ViewController: PlacesNetworkJSONOperationDelegate {
  func placesOperationDidFinish(operation: PlacesNetworkJSONOperation, result: Result<[Place]>) {
    if operation.cancelled { return }
    log(result: result)
  }
}

extension ViewController: PlacesDiskJSONOperationDelegate {
  
  func placesOperationDidFinish(operation: PlacesDiskJSONOperation, result: Result<[Place]>) {
    if operation.cancelled { return }
    log(result: result)
  }
  
}
