# Waffle

[![Travis CI](https://travis-ci.org/CodeReaper/Waffle.svg?branch=master)](https://travis-ci.org/CodeReaper/Waffle)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![CocoaPods Version](https://img.shields.io/cocoapods/v/Waffle.svg?style=flat)](http://cocoapods.org/pods/Waffle)
[![License](https://img.shields.io/cocoapods/l/Waffle.svg?style=flat)](http://cocoapods.org/pods/Waffle)
[![Platforms](https://img.shields.io/cocoapods/p/Waffle.svg)](http://cocoapods.org/pods/Waffle)

Waffle is deadsimple dependency container. Waffle does not try to do too much, it will meet between 80 to 100 percent of your needs and allows you to extend Waffle so you can match all of your needs.

## Basic Usage

Suppose you have the following two datasources.
```swift
struct UserDataSource {
    let name:String
}
struct RestDataSource {
    let userDataSource:UserDataSource

    func sayHi() {
        print("Hi, \(userDataSource.name)")
    }
}
```

First, create a builder that you add all your dependencies to and let it build your `Waffle` which holds them all.

```swift
let userDataSource = UserDataSource(name:"Mr. Example")
let restDataSource = RestDataSource(userDataSource: userDataSource)

let waffle = Waffle.Builder()
    .add(userDataSource)
    .add(restDataSource)
    .build()
```

You pass the `waffle` on to what ever class has dependencies, where you can retrieve its dependencies like the following few lines.

```swift
let restDataSource = try! waffle.get(RestDataSource.self)
restDataSource.sayHi() // prints "Hi, Mr. Example"
```

This means you can have a constructor like in the following example.

```swift
class RestDependentViewController : UIViewController {
	private unowned let restDataSource: RestDataSource
	init(waffle:Waffle) {
		restDataSource = try! waffle.get(RestDataSource.self)
	}
	// ...
}
```

Simple is beautiful, right?
