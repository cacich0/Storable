import UIKit
import Storable

final class MainViewController: UIViewController, Storable {
    
    let store: StoreOf<MainReducer>
    
    private var casted: MainView {
        view as! MainView
    }
    
    init(store: StoreOf<MainReducer>) {
        self.store = store
        super.init(nibName: nil, bundle: nil)
        
        setup()
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = MainView()
    }
    
    private func setup() {
        casted.someButton.addTarget(self, action: #selector(buttonTap), for: .touchUpInside)
    }
    
    private func bind() {
        store.bind(
            to: \.textForLabel,
            for: casted.someLabel
        )
        store.bind(
            to: \.buttonEnabled,
            for: casted.someButton,
            value: \.isEnabled
        )
    }
    
    @objc
    private func buttonTap() {
        store.send(.buttonTap)
    }
    
}
