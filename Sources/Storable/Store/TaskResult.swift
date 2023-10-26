import Foundation

@frozen
public enum TaskResult<Success: Sendable>: Sendable {
    case success(Success)
    case failure(Error)

    public init(catching body: @Sendable () async throws -> Success) async {
        do {
            self = .success(try await body())
        } catch {
            self = .failure(error)
        }
    }
}

extension TaskResult: Equatable where Success: Equatable {
  public static func == (lhs: Self, rhs: Self) -> Bool {
    switch (lhs, rhs) {
    case let (.success(lhs), .success(rhs)):
      return lhs == rhs
    case let (.failure(lhs), .failure(rhs)):
      return _isEqual(lhs, rhs)
        ?? {
          return false
        }()
    default:
      return false
    }
  }
}

func _isEqual(_ lhs: Any, _ rhs: Any) -> Bool? {
  (lhs as? any Equatable)?.isEqual(other: rhs)
}

extension Equatable {
  fileprivate func isEqual(other: Any) -> Bool {
    self == other as? Self
  }
}
