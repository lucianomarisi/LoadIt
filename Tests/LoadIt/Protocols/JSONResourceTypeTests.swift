//
//  JSONResourceTypeTests.swift
//  LoadIt
//
//  Created by Luciano Marisi on 20/07/2016.
//  Copyright © 2016 Luciano Marisi. All rights reserved.
//

import XCTest
@testable import LoadIt

class JSONResourceTypeTests: XCTestCase {
  
  func test_InvalidJSONData() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let result = mockJSONObjectResourceType.resultFrom(data: Data())
    guard let error = result.error() else {
      XCTFail("No error found")
      return
    }
    if case JSONParsingError.invalidJSONData = error { return }
    XCTFail()
  }
  
  func test_validJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let jsonDictionary = ["name": "mock"]
    let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
    let result = mockJSONObjectResourceType.resultFrom(data: data)
    guard let calculatedMockObject = result.successResult() else {
      XCTFail("No error found")
      return
    }
    let expectedMockObject = MockObject(name: "mock")
    XCTAssertEqual(calculatedMockObject, expectedMockObject)
  }
  
  func test_invalidJSONDictionary() {
    let mockJSONObjectResourceType = MockJSONDictionaryResourceType()
    let jsonDictionary = ["invalid_key": "mock"]
    let data = try! JSONSerialization.data(withJSONObject: jsonDictionary, options: JSONSerialization.WritingOptions.prettyPrinted)
    let result = mockJSONObjectResourceType.resultFrom(data: data)
    guard let error = result.error() else {
      XCTFail("No error found")
      return
    }
    if case JSONParsingError.cannotParseJSONDictionary = error { return }
    XCTFail("Did not match correct error: \(error)")
  }
  
  func test_validJSONArray() {
    let mockJSONObjectResourceType = MockJSONArrayResourceType()
    let jsonArray = [
      ["name": "mock 1"],
      ["name": "mock 2"]
    ]
    let data = try! JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
    let result = mockJSONObjectResourceType.resultFrom(data: data)
    guard let calculatedMockObjectsArray = result.successResult() else {
      XCTFail("No error found")
      return
    }
    let expectedMockObjectsArray = [MockObject(name: "mock 1"), MockObject(name: "mock 2")]
    XCTAssertEqual(calculatedMockObjectsArray, expectedMockObjectsArray)
  }
  
  func test_invalidJSONArray() {
    let mockJSONObjectResourceType = MockJSONArrayResourceType()
    let jsonArray = [["invalid-key"]]
    let data = try! JSONSerialization.data(withJSONObject: jsonArray, options: JSONSerialization.WritingOptions.prettyPrinted)
    let result = mockJSONObjectResourceType.resultFrom(data: data)
    guard let error = result.error() else {
      XCTFail("No error found")
      return
    }
    if case JSONParsingError.cannotParseJSONArray = error { return }
    XCTFail()
  }
  
  func test_defaultParsing() {
    let mockDefaultJSONResourceType = MockDefaultJSONResourceType()
    let modelFromJSONDictionary = mockDefaultJSONResourceType.modelFrom(jsonDictionary: ["Key": "value"])
    XCTAssertNil(modelFromJSONDictionary)
    let modelFromJSONArray = mockDefaultJSONResourceType.modelFrom(jsonArray: ["value"])
    XCTAssertNil(modelFromJSONArray)
  }
  
}
