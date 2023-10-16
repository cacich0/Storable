import UIKit
import Combine
import Foundation

public typealias StoreOf<R: Reducer> = Store<R.State, R.Action>

public class Store<State, Action>: ObservableObject {
    
    @usableFromInline
    @Published var state: State
    
    @usableFromInline
    let reducer: any Reducer<State, Action>
    
    private var cancellables: [AnyCancellable] = []
    
    public init<R>(
        state: @autoclosure () -> R.State,
        reducer: () -> R
    ) where R: Reducer, R.State == State, R.Action == Action  {
        self.state = state()
        self.reducer = reducer()
    }
    
    public init<R>(
        state: R.State,
        reducer: R
    ) where R: Reducer, R.State == State, R.Action == Action {
        self.state = state
        self.reducer = reducer
    }
    
    @inlinable
    public func send(_ action: Action) {
        let effect = reducer.reduce(into: &state, action: action)
        switch effect.operation {
        case .none: break
        case let .task(priority, operation):
            Task(priority: priority) { @MainActor in
                await operation(
                    Send { effectAction in
                        self.send(effectAction)
                    }
                )
            }
        }
    }
    
    public func bind<T>(
        to keyPath: KeyPath<State, T>,
        closure: @escaping (T) -> Void
    ) {
        $state
            .map { $0[keyPath: keyPath] }
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: closure)
            .store(in: &cancellables)
    }
    
}

// MARK: UI Bindings

extension Store {
    
    public func bind(
        to keyPath: KeyPath<State, String>,
        for label: UILabel
    ) {
        $state
            .map { $0[keyPath: keyPath] }
            .receive(on: DispatchQueue.main)
            .sink { label.text = $0 }
            .store(in: &cancellables)
    }
    
    public func bind(
        to keyPath: KeyPath<State, String>,
        for textField: UITextField
    ) {
        $state
            .map { $0[keyPath: keyPath] }
            .receive(on: DispatchQueue.main)
            .sink { textField.text = $0 }
            .store(in: &cancellables)
    }
    
    public func bind(
        to keyPath: KeyPath<State, Bool>,
        for textField: UITextField
    ) {
        $state
            .map { $0[keyPath: keyPath] }
            .receive(on: DispatchQueue.main)
            .sink { textField.isEnabled = $0 }
            .store(in: &cancellables)
    }
    
    public func bind(
        to keyPath: KeyPath<State, String>,
        for button: UIButton
    ) {
        $state
            .map { $0[keyPath: keyPath] }
            .receive(on: DispatchQueue.main)
            .sink { button.setTitle($0, for: .normal)}
            .store(in: &cancellables)
    }
    
    public func bind(
        to keyPath: KeyPath<State, Bool>, 
        for button: UIButton
    ) {
        $state
            .map { $0[keyPath: keyPath] }
            .receive(on: DispatchQueue.main)
            .sink { button.isEnabled = $0 }
            .store(in: &cancellables)
    }
    
    public func bind<T, B>(
        to keyPath: KeyPath<State, B>,
        for bindable: T,
        value: ReferenceWritableKeyPath<T, B?>
    ) {
        $state
            .map { $0[keyPath: keyPath] }
            .receive(on: DispatchQueue.main)
            .sink { bindable[keyPath: value] = $0 }
            .store(in: &cancellables)
    }
    
    public func bind<T, B>(
        to keyPath: KeyPath<State, B>,
        for bindable: T,
        value: ReferenceWritableKeyPath<T, B>
    ) {
        $state
            .map { $0[keyPath: keyPath] }
            .receive(on: DispatchQueue.main)
            .sink { bindable[keyPath: value] = $0 }
            .store(in: &cancellables)
    }
}
