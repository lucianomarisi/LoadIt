//
//  Bundle.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

protocol BundleType {
  func URLForResource(_ name: String?, withExtension ext: String?) -> URL?
}

extension Bundle: BundleType {}
