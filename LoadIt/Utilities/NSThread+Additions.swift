//
//  NSThread+Additions.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

extension NSThread {

  static func executeOnMain(mainThreadClosure: () -> Void) {
    if self.currentThread() == self.mainThread() {
      mainThreadClosure()
    } else {
      
      let queue = dispatch_get_main_queue()
      dispatch_sync(queue, {
        mainThreadClosure()
      })
      
    }
  }
  
}
