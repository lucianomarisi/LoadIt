//
//  Result.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public enum Result<T> {
  case success(T)
  case failure(ErrorProtocol)
}

extension Result {
  
  /// Returns the success result if it exists, otherwise nil
  func successResult() -> T? {
    switch self {
    case .success(let successResult):
      return successResult
    case .failure:
      return nil
    }
  }
  
  /// Returns the error if it exists, otherwise nil
  func error() -> ErrorProtocol? {
    switch self {
    case .success:
      return nil
    case .failure(let error):
      return error
    }
  }
}
