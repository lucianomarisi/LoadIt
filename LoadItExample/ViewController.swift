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

  override func viewDidLoad() {
    super.viewDidLoad()    
    let placesNetworkOperation = PlacesNetworkOperation(continent: "europe", delegate: self)
    placesNetworkOperation.execute()

    let placesDiskOperation = PlacesDiskOperation(continent: "asia", delegate: self)
    placesDiskOperation.execute()
    
    let placesResource = PlacesResource(continent: "america")
    
    let diskService = DiskService<PlacesResource>()
    diskService.fetchResource(placesResource) {[weak self] result in
      self?.log(result: result)
    }
    
    let networkService = NetworkService<PlacesResource>()
    networkService.fetchResource(placesResource) { [weak self] result in
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

extension ViewController: PlacesNetworkOperationDelegate {
  func placesOperationDidFinish(operation: PlacesNetworkOperation, result: Result<[Place]>) {
    //      if cancelled { return }
    log(result: result)
  }
}

extension ViewController: PlacesDiskOperationDelegate {
  
  func placesOperationDidFinish(operation: PlacesDiskOperation, result: Result<[Place]>) {
    //      if cancelled { return }
    log(result: result)
  }
  
}
