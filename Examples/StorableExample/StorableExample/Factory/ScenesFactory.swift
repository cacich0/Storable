import UIKit
import Storable

struct Factory {
    
    enum Scene {
        case main
    }
    
    private init() {}
    
    static func build(scene: Scene) -> UIViewController {
        let store: StoreOf<MainViewController.MainReducer> = .init(
            state: MainViewController.MainReducer.State.sample) {
                let networker = Networker()
                return MainViewController.MainReducer(
                    environment: .init(networker: networker)
                )
            }
        
        return MainViewController(store: store)
    }
}
