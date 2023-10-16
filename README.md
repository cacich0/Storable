# Storable
## _Clean Architecture_

The project is still in progress :)

![Draft](https://github.com/cacich0/Storable/blob/main/Storable.png)

## Installation

Swift Package Manager

> Xcode: File -> Add Package Dependencies
> 
> Insert: [https://github.com/cacich0/Storable](https://github.com/cacich0/Storable "https://github.com/cacich0/Storable")

## Usage

#### Reducer

Create a reducer

```swift
import Storable

class FeatureReducer: Reducer {

    struct State {
        let someText: String
    }

    enum Action {
        case someAction
    }

    func reduce(into state: inout State, action: Action) -> Effect<Action> {
        switch action {
        case .someAction:
            state.someText = "New text"
            return .none
        }
    }
}
```

#### ViewController

Create a view controller

```swift
import Storable

class ViewController: UIViewController, Storable {

    let store: StoreOf<FeatureReducer>
  
    let label = UILabel()
  
    init(store: StoreOf<MainReducer>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        bind()
    }
  
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    override func viewDidLoad() {
        super.viewDidLoad()
        // setup views
        // ...
        store.send(.someAction) // send some action to store
    }
  
    private func bind() {
        store.bind(
            to: \.someText,
            for: label
        )
    }
}
```
