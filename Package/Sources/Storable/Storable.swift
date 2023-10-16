import Foundation

public protocol Storable {
    associatedtype Store
    var store: Store { get }
}
