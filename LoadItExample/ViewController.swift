//
//  ViewController.swift
//  LoadItExample
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit
import LoadIt

struct MockJSONService: ResourceServiceType {
  
  func fetch(resource resource: CitiesResource, completion: (Result<[City]>) -> Void) {
    let cities = [City(name: "Mock city")]
    completion(Result.Success(cities))
  }
  
}


class ViewController: UIViewController {

  private let operationQueue = NSOperationQueue()

  override func viewDidLoad() {
    super.viewDidLoad()
    let americaResource = CitiesResource(continent: "america")

    let citiesNetworkJSONOperation = CitiesNetworkJSONOperation(resource: americaResource, delegate: self)
    operationQueue.addOperation(citiesNetworkJSONOperation)
//    citiesNetworkJSONOperation.cancel()
//    operationQueue.cancelAllOperations()
    
    let asiaResource = CitiesResource(continent: "asia")
    let citiesDiskJSONOperation = CitiesDiskResourceOperation(resource: asiaResource, delegate: self)
    operationQueue.addOperation(citiesDiskJSONOperation)

    let citiesCommonResourceOperation = CitiesCommonResourceOperation(resource: asiaResource)
    citiesCommonResourceOperation.didFinishFetchingResourceCallback = { [weak self] operation, result in
      if operation.cancelled { return }
      self?.log(result: result)
    }
    operationQueue.addOperation(citiesCommonResourceOperation)

    let mockService = MockJSONService()
    let mockCitiesResourceOperation = CitiesResourceOperation<MockJSONService>(resource: asiaResource, service: mockService, delegate: self)
    operationQueue.addOperation(mockCitiesResourceOperation)

//    citiesDiskJSONOperation.cancel()
//    operationQueue.cancelAllOperations()

    
    let europeResource = CitiesResource(continent: "europe")

    let diskJSONService = DiskJSONService<CitiesResource>()
    diskJSONService.fetch(resource: europeResource) {[weak self] result in
      self?.log(result: result)
    }
    
    let networkJSONService = NetworkJSONService<CitiesResource>()
    networkJSONService.fetch(resource: europeResource) { [weak self] result in
      self?.log(result: result)
    }
    
  }
    
  func log(result result: Result<[City]>) {
    if case .Success(let cities) = result {
      print(cities)
    } else {
      print(result)
    }
  }
  
}

extension ViewController: CitiesNetworkJSONOperationDelegate {
  func citiesOperationDidFinish(operation: CitiesNetworkJSONOperation, result: Result<[City]>) {
    if operation.cancelled { return }
    log(result: result)
  }
}

extension ViewController: CitiesResourceOperationDelegate {
  
  func citiesOperationDidFinish(result result: Result<[City]>) {
    log(result: result)
  }
//  func citiesOperationDidFinish(result: Result<[City]>) {
////    if operation.cancelled { return }
//    log(result: result)
//  }
  
}
