//
//  XCTestCase+Additions.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest

extension XCTestCase {
  
  /**
   Helper for running async unit tests, creates an expectation and waits for that expectation with
   a defined timeout.
   
   - parameter timeout:        Time to wait for the expectation to fufill default value of one second
   - parameter failureMessage: Failure message to be shown when the test fails
   - parameter runTest:        A block used to wrap the test to be run asynchronously. The block has an
   input paramater of the expectation this function will wait for. Your test
   must fufill this expectation or the test will fail.
   */
  func performAsyncTest(timeout: NSTimeInterval = 1.0, failureMessage: String? = nil, file: StaticString = #file, lineNumber: UInt = #line, @noescape test runTest: (XCTestExpectation) -> Void) {
    let expectation = expectationWithDescription("Async test expectation")
    runTest(expectation)
    waitForExpectationsWithTimeout(timeout) { error in
      if let error = error {
        if let failureMessage = failureMessage {
          XCTFail(failureMessage, file: file, line: lineNumber)
        } else {
          XCTFail(error.localizedDescription, file: file, line: lineNumber)
        }
      }
    }
  }
}
