//
//  NetworkService.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

enum NetworkServiceError: ErrorType {
  case NetworkingError(error: NSError)
  case NoData
}

public struct NetworkService<ResourceType: NetworkResource> {
  
  private let session: Session
  
  public init() {
    self.init(session: NSURLSession.sharedSession())
  }
  
  init(session: Session) {
    self.session = session
  }
  
  public func fetchResource(resource: ResourceType, completion: (Result<ResourceType.ModelType>) -> Void) {
    let urlRequest = resource.urlRequest()
    
    session.performRequest(urlRequest) { (data, _, error) in
      completion(self.resultFrom(resource: resource, data: data, URLResponse: nil, error: error))
    }
    
  }
  
  func resultFrom(resource resource: ResourceType, data: NSData?, URLResponse: NSURLResponse?, error: NSError?) -> Result<ResourceType.ModelType> {
    if let error = error {
      return .Failure(NetworkServiceError.NetworkingError(error: error))
    }
    
    guard let data = data else {
      return .Failure(NetworkServiceError.NoData)
    }
    
    return resource.resultFrom(data: data)
  }
  
}
