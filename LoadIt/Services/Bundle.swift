//
//  Bundle.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

protocol Bundle {
  func URLForResource(name: String?, withExtension ext: String?) -> NSURL?
}

extension NSBundle: Bundle {}
