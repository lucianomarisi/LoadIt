//
//  NetworkJSONResourceService.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/**
 Enum representing an error from a network service
 
 - CouldNotCreateURLRequest: The URL request could be formed
 - StatusCodeError:          A status code error between 400 and 600 (not including 600) was returned
 - NetworkingError:          Any other networking error
 - NoData:                   No data was returned
 */
public enum NetworkServiceError: ErrorType {
  case CouldNotCreateURLRequest
  case StatusCodeError(statusCode: Int)
  case NetworkingError(error: NSError)
  case NoData
}

public class NetworkJSONResourceService<Resource: NetworkJSONResourceType>: ResourceServiceType {
  
  /**
   Method designed to be implemented on subclasses, these fields will be overriden by any HTTP header field
   key that is defined in the resource (in case of conflicts)
   
   - returns: Return any additional header fields that need to be added to the url request
   */
  public func additionalHeaderFields() -> [String: String] {
    return [:]
  }
  
  let session: URLSessionType
  
  public required init() {
    self.session = NSURLSession.sharedSession()
  }
  
  init(session: URLSessionType) {
    self.session = session
  }
  
  public final func fetch(resource resource: Resource, completion: (Result<Resource.Model>) -> Void) {
    guard let urlRequest = resource.urlRequest() as? NSMutableURLRequest else {
      completion(.Failure(NetworkServiceError.CouldNotCreateURLRequest))
      return
    }
    
    urlRequest.allHTTPHeaderFields = allHTTPHeaderFields(resourceHTTPHeaderFields: urlRequest.allHTTPHeaderFields)
    
    session.perform(request: urlRequest) { (data, URLResponse, error) in
      completion(self.resultFrom(resource: resource, data: data, URLResponse: URLResponse, error: error))
    }
  }
  
  private func allHTTPHeaderFields(resourceHTTPHeaderFields resourceHTTPHeaderFields: [String: String]?) -> [String: String]? {
    var generalHTTPHeaderFields = additionalHeaderFields()
    if let resourceHTTPHeaderFields = resourceHTTPHeaderFields {
      for (key, value) in resourceHTTPHeaderFields {
        generalHTTPHeaderFields[key] = value
      }
    }
    return generalHTTPHeaderFields
  }
  
  private func resultFrom(resource resource: Resource, data: NSData?, URLResponse: NSURLResponse?, error: NSError?) -> Result<Resource.Model> {
    
    if let HTTPURLResponse = URLResponse as? NSHTTPURLResponse {
      switch HTTPURLResponse.statusCode {
      case 400..<600:
        return .Failure(NetworkServiceError.StatusCodeError(statusCode: HTTPURLResponse.statusCode))
      default: break
      }
    }
    
    if let error = error {
      return .Failure(NetworkServiceError.NetworkingError(error: error))
    }
    
    guard let data = data else {
      return .Failure(NetworkServiceError.NoData)
    }
    
    return resource.resultFrom(data: data)
  }
  
}
