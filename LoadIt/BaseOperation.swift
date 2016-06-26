//
//  BaseOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public class BaseOperation: NSOperation {
  
  public override var asynchronous: Bool {
    get{
      return true
    }
  }
  
  private var _executing: Bool = false
  public override var executing:Bool {
    get { return _executing }
    set {
      willChangeValueForKey("isExecuting")
      _executing = newValue
      didChangeValueForKey("isExecuting")
      if _newCancelled == true {
        self.finished = true
      }
    }
  }
  private var _finished: Bool = false
  public override var finished: Bool {
    get { return _finished }
    set {
      willChangeValueForKey("isFinished")
      _finished = newValue
      didChangeValueForKey("isFinished")
    }
  }
  
  var _newCancelled: Bool = false
  var newCancelled: Bool {
    get { return _newCancelled }
    set {
      willChangeValueForKey("isCancelled")
      _newCancelled = newValue
      didChangeValueForKey("isCancelled")
    }
  }
  
  public override func start() {
    super.start()
    self.executing = true
  }
  
  public override func main() {
    if newCancelled {
      executing = false
      finished = true
      return
    }
  }
  
  func finish() {
    self.finished = true
    self.executing = false
  }
  
  public override func cancel() {
    super.cancel()
    newCancelled = true
    if executing {
      executing = false
      finished = true
    }
  }
}
