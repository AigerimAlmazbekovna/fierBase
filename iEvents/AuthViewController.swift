

import UIKit
import SnapKit
import FirebaseAuth

class AuthViewController: UIViewController {
    
    var dismissCompletion: (() -> Void)?
    
    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.textColor = .black
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.textColor = .black

        view.layer.masksToBounds = true
        view.isSecureTextEntry = true
        return view
    }()
    private lazy var signInButton: UIButton = {
        let view = UIButton()
        view.setTitle("Войти", for: .normal)
        view.tintColor = .white
        view.backgroundColor = .blue
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTapSignInButton), for: .touchUpInside)
        return view
    }()
    private lazy var signUpButton: UIButton = {
        let view = UIButton()
        view.setTitle("Зарегистрироваться", for: .normal)
        view.tintColor = .white
        view.backgroundColor = .blue
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.addTarget(self, action: #selector(didTapSignUpButton), for: .touchUpInside)
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
    }
    
    
    private func setupUI() {
        view.addSubviews(emailTextField, passwordTextField, signInButton, signUpButton)
        
        emailTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        passwordTextField.snp.makeConstraints { make in
            make.top.equalTo(emailTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        signInButton.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(signInButton.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        
    }
    
    
    @objc private func didTapSignInButton() {
        
        guard let email = emailTextField.text, email != "", let password = passwordTextField.text, password != "" else {
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            
            if authResult?.user != nil {
                self?.dismissCompletion?()
                self?.dismiss(animated: true)
            } else {
                print("not user")
                return
            }
        }
        
        
    }
    
    @objc private func didTapSignUpButton() {
        let vc = RegistrViewController()
        present(vc, animated: true)
    }


}


extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach { view in
            addSubview(view)
        }
    }
}
