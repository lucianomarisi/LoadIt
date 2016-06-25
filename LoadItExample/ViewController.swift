//
//  ViewController.swift
//  LoadItExample
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import UIKit
import LoadIt

let baseURL = NSURL(string: "http://localhost:8000/")!

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
    
    let placesNetworkOperation = PlacesNetworkOperation(continent: "europe", delegate: self)
    //let placesOperation = PlacesOperation(continent: "america", delegate: self)
    placesNetworkOperation.execute()

    let placesDiskOperation = PlacesDiskOperation(continent: "asia", delegate: self)
    //let placesOperation = PlacesOperation(continent: "america", delegate: self)
    placesDiskOperation.execute()
    
    let placesResource = PlacesResource(continent: "america")
    
    let diskService = DiskService<PlacesResource>()
    diskService.fetchResource(placesResource) { result in
      if case .Success(let places) = result {
        print(places)
      }
      print(result)
    }
    
    let networkService = NetworkService<PlacesResource>()
    networkService.fetchResource(placesResource) { result in
      if case .Success(let places) = result {
        print(places)
      }
      print(result)
    }
    
  }
  
}

extension ViewController: PlacesNetworkOperationDelegate {
  func placesOperationDidFinish(operation: PlacesNetworkOperation, result: Result<[Place]>) {
    //      if cancelled { return }
    if case .Success(let places) = result {
      print(places)
    }
    print(result)
  }
}

extension ViewController: PlacesDiskOperationDelegate {
  
  func placesOperationDidFinish(operation: PlacesDiskOperation, result: Result<[Place]>) {
    //      if cancelled { return }
    if case .Success(let places) = result {
      print(places)
    }
    print(result)
  }
  
}

protocol NetworkResource: JSONResource {
  var url: NSURL { get }
  var HTTPMethod: String { get }
  var allHTTPHeaderFields: [String: String]? { get }
  var JSONBody: AnyObject? { get }
}

// MARK: - Request building
extension NetworkResource {
  
  var HTTPMethod: String { return "GET" }
  var allHTTPHeaderFields: [String: String]? { return nil }
  var JSONBody: AnyObject? { return nil }
  
  func urlRequest() -> NSMutableURLRequest {
    let request = NSMutableURLRequest(URL: url)
    request.allHTTPHeaderFields = allHTTPHeaderFields
    request.HTTPMethod = HTTPMethod
    
    if let body = JSONBody {
      request.HTTPBody = try? NSJSONSerialization.dataWithJSONObject(body, options: NSJSONWritingOptions.PrettyPrinted)
    }
    
    return request
  }
}

protocol DiskResource: JSONResource {
  var filename: String { get }
}

struct PlacesResource: NetworkResource, DiskResource {
  let url: NSURL
  let filename: String
  
  init(continent: String) {
    url = baseURL.URLByAppendingPathComponent("\(continent).json")
    filename = continent
  }
  
  func modelFrom(jsonDictionary jsonDictionary: JSONDictionary) -> [Place]? {
    guard let
      placesJSONArray: [JSONDictionary] = jsonDictionary.jsonKey("places")
      else {
        return []
    }
    return placesJSONArray.flatMap(Place.init)
  }
  
}

enum ServiceError: ErrorType {
  case NetworkingError(error: NSError)
  case NoData
  case FileNotFound
}

protocol JSONResourceService {
  associatedtype ResourceType: JSONResource
  func fetchResource(resource: ResourceType, completion: (Result<ResourceType.ModelType>) -> Void)
}

struct NetworkService<ResourceType: NetworkResource>: JSONResourceService {
  
  private let session: Session
  
  init(session: Session = NSURLSession.sharedSession()) {
    self.session = session
  }
  
  func fetchResource(resource: ResourceType, completion: (Result<ResourceType.ModelType>) -> Void) {
    let urlRequest = resource.urlRequest()
    
    session.performRequest(urlRequest) { (data, _, error) in
      completion(self.resultFrom(resource: resource, data: data, URLResponse: nil, error: error))
    }
    
  }
  
  private func resultFrom(resource resource: ResourceType, data: NSData?, URLResponse: NSURLResponse?, error: NSError?) -> Result<ResourceType.ModelType> {
    if let error = error {
      return .Failure(ServiceError.NetworkingError(error: error))
    }
    
    guard let data = data else {
      return .Failure(ServiceError.NoData)
    }
    
    return resource.resultFrom(data: data)
  }
  
}

protocol ResourceOperation: class {
  associatedtype ResourceType: JSONResource
  var resource: ResourceType { get }
  func informDelegateOfResult(result: Result<ResourceType.ModelType>)
}

protocol NetworkOperation: ResourceOperation {
  associatedtype ResourceType: NetworkResource
  var networkService: NetworkService<ResourceType> { get }
}

extension NetworkOperation {
  
  func execute() {
    networkService.fetchResource(resource) { [weak self] (result) in
      //      if cancelled { return }
      NSThread.executeOnMain { [weak self] in
        //      if cancelled { return }
        guard let strongSelf = self else { return }
        strongSelf.informDelegateOfResult(result)
        //        finish()
      }
    }
  }
  
}

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

struct DiskService<ResourceType: DiskResource>: JSONResourceService {
  
  private let bundle: NSBundle
  
  init(bundle: NSBundle = NSBundle.mainBundle()) {
    self.bundle = bundle
  }
  
  func fetchResource(resource: ResourceType, completion: (Result<ResourceType.ModelType>) -> Void) {
    completion(resultFrom(resource: resource))
  }
  
  private func resultFrom(resource resource: ResourceType) -> Result<ResourceType.ModelType>{
    guard let url = bundle.URLForResource(resource.filename, withExtension: "json") else {
      return.Failure(ServiceError.FileNotFound)
    }
    
    guard let data = NSData(contentsOfURL: url) else {
      return.Failure(ServiceError.NoData)
    }
    
    return resource.resultFrom(data: data)
  }
}

protocol DiskOperation: ResourceOperation {
  associatedtype ResourceType: DiskResource
  var diskService: DiskService<ResourceType> { get }
}

extension DiskOperation {
  
  func execute() {
    diskService.fetchResource(resource) { [weak self] (result) in
      //      if cancelled { return }
      NSThread.executeOnMain { [weak self] in
        //      if cancelled { return }
        guard let strongSelf = self else { return }
        strongSelf.informDelegateOfResult(result)
        //        finish()
      }
    }
  }
  
}

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


public protocol Session: class {
  func performRequest(request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void)
}

extension NSURLSession: Session {
  
  public func performRequest(request: NSURLRequest, completion: (NSData?, NSURLResponse?, NSError?) -> Void) {
    dataTaskWithRequest(request, completionHandler: completion).resume()
  }
  
}

