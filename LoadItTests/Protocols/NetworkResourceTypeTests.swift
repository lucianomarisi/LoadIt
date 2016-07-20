//
//  NetworkResourceTypeTests.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import LoadIt

private let url = NSURL(string: "www.test.com")!

class NetworkResourceTypeTests: XCTestCase {
  
  func test_NetworkJSONResource_hasCorrectDefaultValues() {
    let mockDefaultNetworkJSONResource = MockDefaultNetworkJSONResource(url: url)
    XCTAssertEqual(mockDefaultNetworkJSONResource.HTTPRequestMethod, HTTPMethod.GET)
    XCTAssertEqual(mockDefaultNetworkJSONResource.HTTPHeaderFields!, ["Content-Type": "application/json"])
    XCTAssertNil(mockDefaultNetworkJSONResource.JSONBody)
    XCTAssertNil(mockDefaultNetworkJSONResource.queryItems)
  }
  
  func test_NetworkJSONResource_urlRequest() {
    let expectedHTTPMethod = HTTPMethod.POST
    let expectedAllHTTPHeaderFields = ["key": "value"]
    let expectedJSONBody = ["jsonKey": "jsonValue"]
    let mockedURLQueryItems = [NSURLQueryItem(name: "query-name", value: "query-value")]
    let expectedURL = "\(url)?query-name=query-value"
    let mockDefaultNetworkJSONResource = MockNetworkJSONResource(url: url, HTTPRequestMethod: expectedHTTPMethod, HTTPHeaderFields: expectedAllHTTPHeaderFields, JSONBody: expectedJSONBody, queryItems: mockedURLQueryItems)
    
    let urlRequest = mockDefaultNetworkJSONResource.urlRequest()
    XCTAssertNotNil(urlRequest)
    XCTAssertEqual(urlRequest?.URL?.absoluteString, expectedURL)
    XCTAssertEqual(urlRequest?.HTTPMethod, expectedHTTPMethod.rawValue)
    XCTAssertEqual(urlRequest!.allHTTPHeaderFields!, expectedAllHTTPHeaderFields)
    let expectedJSONData = try! NSJSONSerialization.dataWithJSONObject(expectedJSONBody, options: NSJSONWritingOptions.PrettyPrinted)
    XCTAssertEqual(urlRequest!.HTTPBody!, expectedJSONData)
  }
  
}
