//
//  ResourceOperationTypeTests.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import LoadIt

class TestResourceOperation: ResourceOperationType {
  
  typealias Resource = MockResource
  
  var cancelled: Bool = false
  var capturedFinishedErrors: [NSError]?
  var capturedResult: Result<String>?
  var captureDidFinishFetchingResourceThread: Thread?
  
  func finish(_ errors: [NSError]) {
    capturedFinishedErrors = errors
  }
  
  func didFinishFetchingResource(result: Result<String>) {
    captureDidFinishFetchingResourceThread = Thread.current
    capturedResult = result
  }
  
}

class ResourceOperationTypeTests: XCTestCase {
  
  var mockService: MockResourceService!
  var testResourceOperation: TestResourceOperation!
  
  override func setUp() {
    super.setUp()
    mockService = MockResourceService()
    testResourceOperation = TestResourceOperation()
  }
  
  override func tearDown() {
    mockService = nil
    testResourceOperation = nil
    super.tearDown()
  }
  
  func test_fetch_callsFinishAndDidFinish_withCorrectResultOnSuccess() {
    testResourceOperation.fetch(resource: MockResource(), usingService: mockService)
    let expectedResult = Result.success("some result")
    mockService.capturedCompletion!(expectedResult)
    XCTAssertNotNil(testResourceOperation.capturedFinishedErrors)
    XCTAssertEqual(testResourceOperation.capturedFinishedErrors!.count, 0)
    guard let successResult = testResourceOperation.capturedResult?.successResult() else {
      XCTFail("Result was not succesful")
      return
    }
    XCTAssertEqual(successResult, "some result")
    XCTAssert(testResourceOperation.captureDidFinishFetchingResourceThread!.isMainThread)
  }
  
  func test_fetch_doesNotCallFetchOnService_whenOperationIsCancelled_beforeServiceFetches() {
    testResourceOperation.cancelled = true
    testResourceOperation.fetch(resource: MockResource(), usingService: mockService)
    XCTAssertNil(mockService.capturedCompletion)
  }
  
  func test_fetch_doesNotCallFinishAndDidFinish_whenOperationIsCancelled_afterServiceFetches() {
    testResourceOperation.fetch(resource: MockResource(), usingService: mockService)
    testResourceOperation.cancelled = true
    let expectedResult = Result.success("some result")
    mockService.capturedCompletion!(expectedResult)
    XCTAssertNil(testResourceOperation.capturedFinishedErrors)
    XCTAssertNil(testResourceOperation.capturedResult)
  }
  
}
