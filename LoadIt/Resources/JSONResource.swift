//
//  JSONResource.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol Resource {
  associatedtype ModelType
}

public protocol JSONResource: Resource {
  associatedtype ModelType
  func modelFrom(jsonDictionary jsonDictionary: [String : AnyObject]) -> ModelType?
  func modelFrom(jsonArray jsonArray: [AnyObject]) -> ModelType?
}

// MARK: - Parsing defaults
extension JSONResource {
  public func modelFrom(jsonDictionary jsonDictionary: [String : AnyObject]) -> ModelType? { return nil }
  public func modelFrom(jsonArray jsonArray: [AnyObject]) -> ModelType? { return nil }
}

enum ParsingError: ErrorType {
  case InvalidJSONData
  case CannotParseJSONDictionary
  case CannotParseJSONArray
  case UnsupportedType
}

// MARK: - Convenince parsing functions
extension JSONResource {
  
  func resultFrom(jsonDictionary jsonDictionary: [String: AnyObject]) -> Result<ModelType> {
    if let parsedResults = modelFrom(jsonDictionary: jsonDictionary) {
      return .Success(parsedResults)
    } else {
      return .Failure(ParsingError.CannotParseJSONDictionary)
    }
  }
  
  func resultFrom(jsonArray jsonArray: [AnyObject]) -> Result<ModelType> {
    if let parsedResults = modelFrom(jsonArray: jsonArray) {
      return .Success(parsedResults)
    } else {
      return .Failure(ParsingError.CannotParseJSONArray)
    }
  }
  
  func resultFrom(data data: NSData) -> Result<ModelType> {
    guard let jsonObject = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) else {
      return .Failure(ParsingError.InvalidJSONData)
    }
    
    if let jsonDictionary = jsonObject as? [String: AnyObject] {
      return resultFrom(jsonDictionary: jsonDictionary)
    }
    
    if let jsonArray = jsonObject as? [AnyObject] {
      return resultFrom(jsonArray: jsonArray)
    }
    
    return .Failure(ParsingError.UnsupportedType)
  }
  
}
