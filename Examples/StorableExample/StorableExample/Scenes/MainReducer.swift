import Storable

extension MainViewController {
    final class MainReducer: Reducer {
        
        struct State {
            var textForLabel: String
            var buttonEnabled: Bool
        }
        
        enum Action {
            case buttonTap
            case loadData(TaskResult<String>)
        }
        
        struct Environment {
            let networker: Networker
        }
        
        let environment: Environment
        
        init(environment: Environment) {
            self.environment = environment
        }
        
        func reduce(into state: inout State, action: Action) -> Effect<Action> {
            switch action {
            case .buttonTap:
                state.buttonEnabled = false
                return .run(
                    priority: .userInitiated) { send in
                        await send.callAsFunction(.loadData(TaskResult {
                            try await self.environment.networker.loadData()
                        }))
                    }
            case .loadData(.success(let result)):
                state.buttonEnabled = true
                state.textForLabel = result
                return .none
            case .loadData(.failure(let error)):
                state.buttonEnabled = true
                print(error)
                return .none
            }
        }
    }
}

extension MainViewController.MainReducer.State {
    static let sample: Self = .init(
        textForLabel: "Press the button",
        buttonEnabled: true
    )
}
