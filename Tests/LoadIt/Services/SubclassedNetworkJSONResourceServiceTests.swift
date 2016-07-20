//
//  SubclassedNetworkJSONResourceServiceTests.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import LoadIt

private let commonKey = "common"

final class SubclassedNetworkJSONResourceService<Resource: NetworkJSONResourceType>: NetworkJSONResourceService<Resource> {
  
  // Needed because of https://bugs.swift.org/browse/SR-416
  required init() {
    super.init()
  }
  
  override init(session: URLSessionType) {
    super.init(session: session)
  }
  
  override func additionalHeaderFields() -> [String: String] {
    return [commonKey: "subclass"]
  }
}

private let testURL = URL(string: "http://test.com")!
private let url = URL(string: "www.test.com")!

class SubclassedNetworkJSONResourceServiceTests: XCTestCase {
  
  var testService: SubclassedNetworkJSONResourceService<MockNetworkJSONResource>!
  var mockSession: MockURLSession!
  var mockResource: MockNetworkJSONResource!
  
  let testRequest = URLRequest(url: testURL)
  
  override func setUp() {
    super.setUp()
    mockSession = MockURLSession()
    testService = SubclassedNetworkJSONResourceService<MockNetworkJSONResource>(session: mockSession)
  }
  
  func test_subclassHTTPHeaderFields_areOverridenByResourceHTTPHeaderFields() {
    let resourceHTTPHeaderFields = [commonKey: "resource"]
    mockResource = MockNetworkJSONResource(url: testURL, HTTPHeaderFields: resourceHTTPHeaderFields)
    testService.fetch(resource: mockResource) { _ in }
    XCTAssertEqual(mockSession.capturedRequest!.allHTTPHeaderFields!, resourceHTTPHeaderFields)
  }
  
  func test_finalRequestInclude_subclassHTTPHeaderFields_and_resourceHTTPHeaderFields() {
    let resourceHTTPHeaderFields = ["resource_key" : "resource"]
    mockResource = MockNetworkJSONResource(url: testURL, HTTPHeaderFields: resourceHTTPHeaderFields)
    testService.fetch(resource: mockResource) { _ in }
    let expectedHeaderFields = [commonKey: "subclass", "resource_key" : "resource"]
    XCTAssertEqual(mockSession.capturedRequest!.allHTTPHeaderFields!, expectedHeaderFields)
  }
  
}
