
import Foundation

enum WaffleError: Error {
    case notFound, multipleFound
}

open class Waffle {
    open class Builder {
        private var items:[Any] = []

        public init() { }

        @discardableResult
        public func add(_ item:Any) -> Builder {
            items.append(item)
            return self
        }

        public func build() -> Waffle {
            return Waffle(items: items)
        }
    }

    private let items:[Any]
    private init(items:[Any]) {
        self.items = items
    }

    public func get<T>(_ type: T.Type) throws -> T {
        let resolved = items.filter { $0 is T }
        guard resolved.count > 0 else {
            throw WaffleError.notFound
        }
        guard resolved.count == 1 else {
            throw WaffleError.multipleFound
        }
        return resolved.first! as! T
    }
}
