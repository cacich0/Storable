import Foundation


public protocol Reducer<State, Action> {
    
    associatedtype State
    associatedtype Action
    
    func reduce(into state: inout State, action: Action) -> Effect<Action>
}
