//
//  DiskJSONResource.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public protocol DiskJSONResourceType: JSONResourceType {
  var filename: String { get }
}
