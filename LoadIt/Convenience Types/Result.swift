//
//  Result.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public enum Result<T> {
  case Success(T)
  case Failure(ErrorType)
}

extension Result {
  
  /// Returns the success result if it exists, otherwise nil
  func successResult() -> T? {
    switch self {
    case .Success(let successResult):
      return successResult
    case .Failure:
      return nil
    }
  }
  
  /// Returns the error if it exists, otherwise nil
  func error() -> ErrorType? {
    switch self {
    case .Success:
      return nil
    case .Failure(let error):
      return error
    }
  }
}
