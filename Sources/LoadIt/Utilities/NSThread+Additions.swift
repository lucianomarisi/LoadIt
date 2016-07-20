//
//  NSThread+Additions.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

extension Thread {

  static func li_executeOnMain(_ mainThreadClosure: () -> Void) {
    if self.current == self.main {
      mainThreadClosure()
    } else {
      
      let queue = DispatchQueue.main
      queue.sync(execute: {
        mainThreadClosure()
      })
      
    }
  }
  
}
