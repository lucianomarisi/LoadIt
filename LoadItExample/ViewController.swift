//
//  ViewController.swift
//  LoadItExample
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit
import LoadIt

struct MockResource: ResourceType {
  typealias Model = String
}

struct MockService: ResourceServiceType {
  typealias Resource = MockResource
  
  func fetch(resource resource: Resource, completion: (Result<Resource.Model>) -> Void) {
    completion(Result.Success("Mock result"))
  }
  
}

private typealias CitiesNetworkResourceOperation = ResourceOperation<NetworkJSONResourceService<CitiesResource>>
private typealias CitiesDiskResourceOperation = ResourceOperation<DiskJSONService<CitiesResource>>
private typealias MockResourceOperation = ResourceOperation<MockService>

class ViewController: UIViewController {

  private let operationQueue = NSOperationQueue()

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let americaResource = CitiesResource(continent: "america")
    let citiesNetworkResourceOperation = CitiesNetworkResourceOperation(resource: americaResource) { [weak self] operation, result in
      if operation.cancelled { return }
      self?.log(result: result)
    }
    operationQueue.addOperation(citiesNetworkResourceOperation)
//    citiesNetworkJSONOperation.cancel()
//    operationQueue.cancelAllOperations()
    
    let asiaResource = CitiesResource(continent: "asia")
    let citiesResourceOperation = CitiesDiskResourceOperation(resource: asiaResource) { [weak self] operation, result in
      if operation.cancelled { return }
      self?.log(result: result)
    }
    operationQueue.addOperation(citiesResourceOperation)

    let mockResource = MockResource()
    let mockService = MockService()
    let mockCitiesResourceOperation = MockResourceOperation(resource: mockResource, service: mockService){ [weak self] operation, result in
      if operation.cancelled { return }
      self?.log(result: result)
    }
//    mockCitiesResourceOperation.execute()
//    mockCitiesResourceOperation.cancel()
    operationQueue.addOperation(mockCitiesResourceOperation)

    
    let europeResource = CitiesResource(continent: "europe")

    let diskJSONService = DiskJSONService<CitiesResource>()
    diskJSONService.fetch(resource: europeResource) {[weak self] result in
      self?.log(result: result)
    }
    
    let networkJSONService = NetworkJSONResourceService<CitiesResource>()
    networkJSONService.fetch(resource: europeResource) { [weak self] result in
      self?.log(result: result)
    }
    
  }
    
  func log<T>(result result: Result<T>) {
    if case .Success(let cities) = result {
      print(cities)
    } else {
      print(result)
    }
  }
  
}
