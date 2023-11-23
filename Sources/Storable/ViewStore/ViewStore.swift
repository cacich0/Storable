import SwiftUI
import Combine

public struct ViewStore<Content, R, S, A>: View
where Content: View, R: Store<S, A>, A: Equatable {
    
    var content: (R.State) -> Content
    var cancellables: [AnyCancellable] = []
    @ObservedObject var store: Store<S, A>
    
    public var body: some View {
        content(store.state)
    }
    
    public init(
        for store: Store<S, A>,
        @ViewBuilder content: @escaping (R.State) -> Content
    ) {
        self.store = store
        self.content = content
    }
}
