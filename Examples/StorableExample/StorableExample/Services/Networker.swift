import Foundation

struct Networker {
    
    func loadData() async throws -> String {
        try await Task.sleep(for: .seconds(1))
        return "Good!"
    }
}
