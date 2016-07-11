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

public struct NetworkJSONService<Resource: NetworkJSONResourceType> {
  
  private let session: URLSessionType
  
  init(session: URLSessionType) {
    self.session = session
  }
  
  private func resultFrom(resource resource: Resource, data: NSData?, URLResponse: NSURLResponse?, error: NSError?) -> Result<Resource.Model> {
    if let error = error {
      return .Failure(NetworkJSONServiceError.NetworkingError(error: error))
    }
    
    guard let data = data else {
      return .Failure(NetworkJSONServiceError.NoData)
    }
    
    return resource.resultFrom(data: data)
  }
  
}

// MARK: - ResourceServiceType
extension NetworkJSONService: ResourceServiceType {
  
  public init() {
    self.init(session: NSURLSession.sharedSession())
  }
  
  public func fetch(resource resource: Resource, completion: (Result<Resource.Model>) -> Void) {
    let urlRequest = resource.urlRequest()
    
    session.perform(request: urlRequest) { (data, _, error) in
      completion(self.resultFrom(resource: resource, data: data, URLResponse: nil, error: error))
    }
  }
  
}
