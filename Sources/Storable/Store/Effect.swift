import Foundation

@frozen
public struct Effect<Action> {
    
    @usableFromInline
    enum Operation {
        case none
        case task(TaskPriority? = nil, @Sendable (_ send: Send<Action>) async -> Void)
        case timerStart(TimeInterval, for: Action)
        case timerStop(for: Action)
    }
    
    public enum Timer {
        case start(Tick)
        case stop
        
        public enum Tick {
            case milliseconds(Int)
            case seconds(Int)
            
            @usableFromInline
            var timeInterval: TimeInterval {
                switch self {
                case let .milliseconds(int): TimeInterval(int / 1000)
                case let .seconds(int): TimeInterval(int)
                }
            }
        }
    }
    
    @usableFromInline
    let operation: Operation
    
    @usableFromInline
    init(operation: Operation) {
        self.operation = operation
    }
}

extension Effect {
    
    @inlinable
    public static var none: Effect {
        Self(operation: .none)
    }
    
    public static func run(
      priority: TaskPriority? = nil,
      operation: @escaping @Sendable (_ send: Send<Action>) async throws -> Void,
      catch handler: (@Sendable (_ error: Error, _ send: Send<Action>) async -> Void)? = nil
    ) -> Self {
        Self(operation: .task(priority) { send in
            do {
                try await operation(send)
            } catch is CancellationError {
                return
            } catch {
                guard let handler else { return }
                await handler(error, send)
            }
        })
    }
    
    @inlinable
    static public func timer(
        _ timer: Timer,
        for action: Action
    ) -> Self {
        switch timer {
        case .start(let tick):
            return Self(operation: .timerStart(tick.timeInterval, for: action))
        case .stop:
            return Self(operation: .timerStop(for: action))
        }
    }
}

@MainActor @frozen
public struct Send<Action>: Sendable {
    
    let send: @MainActor @Sendable (Action) -> Void
    
    public init(send: @escaping @MainActor @Sendable (Action) -> Void) {
        self.send = send
    }

    public func callAsFunction(_ action: Action) {
        guard !Task.isCancelled else { return }
        self.send(action)
    }
}
