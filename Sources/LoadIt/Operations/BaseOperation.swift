//
//  BaseOperation.swift
//  LoadIt
//
//  Created by Luciano Marisi on 25/06/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import Foundation

public class BaseOperation: Operation {
  
  public override var isAsynchronous: Bool {
    get{
      return true
    }
  }
  
  private var _executing: Bool = false
  public override var isExecuting:Bool {
    get { return _executing }
    set {
      willChangeValue(forKey: "isExecuting")
      _executing = newValue
      didChangeValue(forKey: "isExecuting")
      if _cancelled == true {
        self.isFinished = true
      }
    }
  }
  private var _finished: Bool = false
  public override var isFinished: Bool {
    get { return _finished }
    set {
      willChangeValue(forKey: "isFinished")
      _finished = newValue
      didChangeValue(forKey: "isFinished")
    }
  }
  
  private var _cancelled: Bool = false
  public override var isCancelled: Bool {
    get { return _cancelled }
    set {
      willChangeValue(forKey: "isCancelled")
      _cancelled = newValue
      didChangeValue(forKey: "isCancelled")
    }
  }
  
  public final override func start() {
    super.start()
    self.isExecuting = true
  }
  
  public final override func main() {
    if isCancelled {
      isExecuting = false
      isFinished = true
      return
    }
    execute()
  }
  
  public func execute() {
    assertionFailure("execute must overriden")
    finish()
  }

  public final func finish(_ errors: [NSError] = []) {
    self.isFinished = true
    self.isExecuting = false
  }
  
  public final override func cancel() {
    super.cancel()
    isCancelled = true
    if isExecuting {
      isExecuting = false
      isFinished = true
    }
  }
}
