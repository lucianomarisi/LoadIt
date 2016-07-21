# LoadIt

[![Build Status](https://travis-ci.org/lucianomarisi/LoadIt.svg?branch=master)](https://travis-ci.org/lucianomarisi/LoadIt)
[![](https://img.shields.io/cocoapods/v/LoadIt.svg)](https://cocoapods.org/pods/LoadIt)
[![](https://img.shields.io/cocoapods/p/LoadIt.svg?style=flat)](https://cocoapods.org/pods/LoadIt)
[![codecov.io](http://codecov.io/github/lucianomarisi/LoadIt/coverage.svg?branch=master)](http://codecov.io/github/lucianomarisi/LoadIt?branch=master)
[![Documentation](https://img.shields.io/cocoapods/metrics/doc-percent/LoadIt.svg?style=flat)](http://cocoadocs.org/docsets/LoadIt/)

The idea behind this library is for the user to define the resources in their application by conforming to protocols that define where and how to get them. These resource can then be retrieved using a generic service type with or without an operation provided by the library.

**Note that this library is still under development and so at the moment the only supported resource type is JSON.**

**The original idea for this pattern is explained on [Protocol oriented loading of resources from a network service in Swift](http://www.marisibrothers.com/2016/07/protocol-oriented-loading-of-resources.html)**

## Simple example

Let's say you need to retrieve this JSON from an server, `http://localhost:8000/<continent>.json`:

```json
{
  "cities": [{
    "name": "Paris"
  }, {
    "name": "London"
  }]
}
```

The Swift model for a city could look something like this:

```swift
struct City {
  let name: String
}
```

Some basic parsing logic:

```swift
extension City {
  init?(jsonDictionary: [String : AnyObject]) {
    guard let parsedName = jsonDictionary["name"] as? String else {
      return nil
    }
    name = parsedName
  }
}
```

### Defining a `Resource`

A `CitiesResource` can be created to define where the cities will come from and how the base endpoint should be parsed:

```swift
private let baseURL = NSURL(string: "http://localhost:8000/europe.json")!

struct CitiesResource: NetworkJSONResourceType {
  typealias Model = [City]
  
  let url: NSURL
  
  init(continent: String) {
    url = baseURL.URLByAppendingPathComponent("\(continent).json")
  }
  
  //MARK: JSONResource
  func modelFrom(jsonDictionary jsonDictionary: [String: AnyObject]) -> [City]? {
    guard let
      citiesJSONArray = jsonDictionary["cities"] as? [[String: AnyObject]]
      else {
        return []
    }
    return citiesJSONArray.flatMap(City.init)
  }
  
}
```

### Retrieving the resource

Use the provided `NetworkJSONResourceService` to retrieve your `CitiesResource` from a web service:

```swift
let europeResource = CitiesResource(continent: "europe")
let networkJSONService = NetworkJSONResourceService<CitiesResource>()
networkJSONService.fetch(resource: europeResource) { [weak self] result in
  // do something with the result
}
```

**OR**

Define a typealias for conveniency if you using `NSOperation`s:

```swift
private typealias CitiesNetworkResourceOperation = ResourceOperation<NetworkJSONResourceService<CitiesResource>>
```

Create the operation using a `CitiesResource`

```swift
let europeResource = CitiesResource(continent: "europe")
let citiesNetworkResourceOperation = CitiesNetworkResourceOperation(resource: europeResource) { [weak self] operation, result in
  // do something with the result
}
```

Add the operation to some queue
```swift
let operationQueue = NSOperationQueue()
operationQueue.addOperation(citiesNetworkResourceOperation)
```

## Creating your own services and operations

At the moment the only service provided is the `NetworkJSONResourceService`. This will change in future updates where it may be relevant to ship this library with more default services. In the meantime the user can create they own service by conforming to `ResourceServiceType`. Similarly, even though the `ResourceOperation` may cater for most needs the developer can choose to have their own resource operation that conforms to `ResourceOperationType`.
