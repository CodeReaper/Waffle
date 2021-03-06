
import XCTest
@testable import Waffle

class WaffleTests: XCTestCase {

    func testSimpleUsage() {
        let cache = NSCache<AnyObject, AnyObject>()
        let waffle = Waffle.Builder()
            .add(String())
            .add(cache)
            .build()

        let resolvedCache = try! waffle.get(NSCache<AnyObject, AnyObject>.self)
        XCTAssertEqual(cache, resolvedCache)
    }

    func testResolvingNotFound() {
        do {
            let _ = try Waffle.Builder().build().get(String.self)
            XCTFail("failed to throw error")
        } catch let error {
            XCTAssertEqual(WaffleError.notFound, error as! WaffleError)
        }
    }

    func testResolvingGenericsFails() {
        let cache = NSCache<AnyObject, AnyObject>()
        let waffle = Waffle.Builder()
            .add(NSCache<NSString, AnyObject>())
            .add(String())
            .add(cache)
            .build()

        do {
            let _ = try waffle.get(NSCache<AnyObject, AnyObject>.self)
            XCTFail("failed to throw error")
        } catch let error {
            XCTAssertEqual(WaffleError.multipleFound, error as! WaffleError)
        }
    }

    func testResolvingGenericsWorkaround() {
        class ACache : NSCache<AnyObject, AnyObject> { }
        class BCache : NSCache<AnyObject, AnyObject> { }
        class CCache : NSCache<AnyObject, AnyObject> { }

        let cache = BCache()
        let waffle = Waffle.Builder()
            .add(ACache())
            .add(cache)
            .add(CCache())
            .build()

        let resolvedCache = try! waffle.get(BCache.self)
        XCTAssertEqual(cache, resolvedCache)
    }

    func testResolvingInheritance() {
        class ACache : NSCache<AnyObject, AnyObject> { }
        class AACache : ACache { }
        class AAACache : AACache { }

        let cache = AAACache()
        let waffle = Waffle.Builder()
            .add(cache)
            .build()

        let aCache = try! waffle.get(ACache.self)
        XCTAssertEqual(cache, aCache)

        let aaCache = try! waffle.get(AACache.self)
        XCTAssertEqual(cache, aaCache)

        let aaaCache = try! waffle.get(AAACache.self)
        XCTAssertEqual(cache, aaaCache)
    }

    func testPerformanceMinimum() {
        let cache = NSCache<AnyObject, AnyObject>()
        let waffle = Waffle.Builder().add(cache).build()

        measure {
            let resolvedCache = try! waffle.get(NSCache<AnyObject, AnyObject>.self)
            XCTAssertEqual(cache, resolvedCache)
        }
    }

    func testPerformanceForAThousand() {
        let cache = NSCache<AnyObject, AnyObject>()
        let builder = Waffle.Builder()
        Array(0..<1000).forEach { _ in
            builder.add(String())
        }
        let waffle = builder.add(cache).build()

        measure {
            let resolvedCache = try! waffle.get(NSCache<AnyObject, AnyObject>.self)
            XCTAssertEqual(cache, resolvedCache)
        }
    }

    func testOfREADMEExample() {
        struct UserDataSource {
            let name:String
        }
        struct RestDataSource {
            let userDataSource:UserDataSource

            func sayHi() -> String {
                return "Hi, \(userDataSource.name)"
            }
        }

        let name = "Mr. Example"
        let userDataSource = UserDataSource(name:name)
        let restDataSource = RestDataSource(userDataSource: userDataSource)

        let waffle = Waffle.Builder()
            .add(userDataSource)
            .add(restDataSource)
            .build()

        let resolvedDataSource = try! waffle.get(RestDataSource.self)
        let hiMessage = resolvedDataSource.sayHi()
        XCTAssertEqual("Hi, \(name)", hiMessage)
    }

    func testRebuildUsage() {
        let cache = NSCache<AnyObject, AnyObject>()
        let waffle = Waffle.Builder()
            .add(String())
            .build()

        let rebuiltWaffle = waffle.rebuild().add(cache).build()

        let resolvedCache = try! rebuiltWaffle.get(NSCache<AnyObject, AnyObject>.self)
        XCTAssertEqual(cache, resolvedCache)
    }

    func testReplaceUsage() {
        let stringA = "A"
        let stringB = "B"
        let waffle = Waffle.Builder()
            .add(stringA)
            .build()

        let rebuiltWaffle = waffle.rebuild().replace(stringB).build()

        let resolvedString = try! rebuiltWaffle.get(String.self)
        XCTAssertEqual(stringB, resolvedString)
    }

    func testReplaceMiss() {
        let string = "A"
        let waffle = Waffle.Builder()
            .replace(string)
            .build()

        let resolvedString = try! waffle.get(String.self)
        XCTAssertEqual(string, resolvedString)
    }
}
