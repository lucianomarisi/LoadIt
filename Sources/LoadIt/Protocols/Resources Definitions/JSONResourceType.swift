//
//  JSONResource.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

/**
 *  Protocol used to define a resource, contains an associated type that is the domain specific model type
 */
public protocol ResourceType {
  associatedtype Model
}

/**
 *  Defines a specific ResourceType used for JSON resources
 */
public protocol JSONResourceType: ResourceType {
  /**
   Parse a Model from a JSON dictionary
   
   - parameter jsonDictionary: The JSON dictionary used to decode the Model
   
   - returns: A parsed Model or nil
   */
  func modelFrom(jsonDictionary: [String : AnyObject]) -> Model?
  
  /**
   Parse a Model from a JSON array
   
   - parameter jsonArray: The JSON array used to decode the Model
   
   - returns: A parsed Model or nil
   */
  func modelFrom(jsonArray: [AnyObject]) -> Model?
}

// MARK: - Parsing defaults
extension JSONResourceType {
  /**
   Parse this resources Model from a JSON dictionary
   
   - parameter jsonDictionary: The JSON dictionary to parse
   
   - returns: An instantiated model if parsing was succesful, otherwise nil
   */
  public func modelFrom(jsonDictionary: [String : AnyObject]) -> Model? { return nil }
  
  /**
   Parse this resources Model from a JSON array
   
   - parameter jsonArray: The JSON array to parse
   
   - returns: An instantiated model if parsing was succesful, otherwise nil
   */
  public func modelFrom(jsonArray: [AnyObject]) -> Model? { return nil }
}

enum JSONParsingError: ErrorProtocol {
  case invalidJSONData
  case cannotParseJSONDictionary
  case cannotParseJSONArray
  case unsupportedType
}

// MARK: - Convenince parsing functions
extension JSONResourceType {
  
  func resultFrom(data: Data) -> Result<Model> {
    guard let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
      return .failure(JSONParsingError.invalidJSONData)
    }
    
    if let jsonDictionary = jsonObject as? [String: AnyObject] {
      return resultFrom(jsonDictionary: jsonDictionary)
    }
    
    if let jsonArray = jsonObject as? [AnyObject] {
      return resultFrom(jsonArray: jsonArray)
    }
    
    // This is likely an impossible case since `JSONObjectWithData` likely only returns [String: AnyObject] or [AnyObject] but still needed to appease the compiler
    return .failure(JSONParsingError.unsupportedType)
  }
  
  private func resultFrom(jsonDictionary: [String: AnyObject]) -> Result<Model> {
    if let parsedResults = modelFrom(jsonDictionary: jsonDictionary) {
      return .success(parsedResults)
    } else {
      return .failure(JSONParsingError.cannotParseJSONDictionary)
    }
  }
  
  private func resultFrom(jsonArray: [AnyObject]) -> Result<Model> {
    if let parsedResults = modelFrom(jsonArray: jsonArray) {
      return .success(parsedResults)
    } else {
      return .failure(JSONParsingError.cannotParseJSONArray)
    }
  }
  
}
