//
//  NetworkJSONService.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

enum NetworkJSONServiceError: ErrorType {
  case NetworkingError(error: NSError)
  case NoData
}

public struct NetworkJSONService<Resource: NetworkJSONResource> {
  
  private let session: Session
  
  public init() {
    self.init(session: NSURLSession.sharedSession())
  }
  
  init(session: Session) {
    self.session = session
  }
  
  private func resultFrom(resource resource: Resource, data: NSData?, URLResponse: NSURLResponse?, error: NSError?) -> Result<Resource.ModelType> {
    if let error = error {
      return .Failure(NetworkJSONServiceError.NetworkingError(error: error))
    }
    
    guard let data = data else {
      return .Failure(NetworkJSONServiceError.NoData)
    }
    
    return resource.resultFrom(data: data)
  }
  
}

// MARK: - ResourceService
extension NetworkJSONService: ResourceService {
  
  public func fetch(resource resource: Resource, completion: (Result<Resource.ModelType>) -> Void) {
    let urlRequest = resource.urlRequest()
    
    session.performRequest(urlRequest) { (data, _, error) in
      completion(self.resultFrom(resource: resource, data: data, URLResponse: nil, error: error))
    }
  }
  
}
