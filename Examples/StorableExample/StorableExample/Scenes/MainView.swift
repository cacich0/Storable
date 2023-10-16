import UIKit

extension MainViewController {
    final class MainView: UIView {
        let someLabel = UILabel()
        let someButton = UIButton(type: .system)
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            setup()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func setup() {
            
            backgroundColor = .white
            
            addSubview(someLabel)
            addSubview(someButton)
            
            someLabel.translatesAutoresizingMaskIntoConstraints = false
            someButton.translatesAutoresizingMaskIntoConstraints = false
            
            someButton.setTitle("Tap me", for: .normal)
            
            NSLayoutConstraint.activate([
                someLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
                someLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
                
                someButton.heightAnchor.constraint(equalToConstant: 40),
                someButton.widthAnchor.constraint(equalToConstant: 100),
                someButton.centerXAnchor.constraint(equalTo: centerXAnchor),
                someButton.topAnchor.constraint(equalTo: someLabel.bottomAnchor, constant: 20)
            ])
        }
    }
}
