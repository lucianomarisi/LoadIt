//
//  ResourceService.swift
//  LoadIt
//
//  Created by Luciano Marisi on 02/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol ResourceService {
  associatedtype ResourceType: Resource
  func fetch(resource resource: ResourceType, completion: (Result<ResourceType.ModelType>) -> Void)
}