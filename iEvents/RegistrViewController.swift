

import UIKit
import SnapKit
import FirebaseAuth

class RegistrViewController: UIViewController {

    private lazy var emailTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.placeholder = "Email"
        view.layer.cornerRadius = 5
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.textColor = .black

        view.layer.masksToBounds = true
        view.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return view
    }()
    
    private lazy var passwordTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.textColor = .black

        view.layer.cornerRadius = 5
        view.placeholder = "Password"
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        view.isSecureTextEntry = true
        return view
    }()
    
    private lazy var confirmPasswordTextField: UITextField = {
        let view = UITextField()
        view.backgroundColor = .white
        view.textColor = .black
        view.layer.cornerRadius = 5
        view.placeholder = "Confirm Password"
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.layer.masksToBounds = true
        view.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        view.isSecureTextEntry = true
        return view
    }()
  
    private lazy var signUpButton: UIButton = {
        let view = UIButton()
        view.setTitle("Sign UP", for: .normal)
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
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        view.addSubviews(emailTextField, passwordTextField, confirmPasswordTextField, signUpButton)
        
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
        confirmPasswordTextField.snp.makeConstraints { make in
            make.top.equalTo(passwordTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
        signUpButton.snp.makeConstraints { make in
            make.top.equalTo(confirmPasswordTextField.snp.bottom).offset(15)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
    }
    
    @objc private func didTapSignUpButton() {
        guard let email = emailTextField.text, email != "",
              let pass = passwordTextField.text, pass != "",
              let confirmPass = confirmPasswordTextField.text, confirmPass != "",
              confirmPass == pass else {
                  return
              }
        
        Auth.auth().createUser(withEmail: email, password: pass) { [weak self] authResult, error in
            
//            error as? FIRAuthErrorCodeInvalidEmail
            
            if let error {
                let err = error as NSError
                switch err.code {
                case AuthErrorCode.emailAlreadyInUse.rawValue:
                    self?.emailTextField.backgroundColor = .red
                case AuthErrorCode.weakPassword.rawValue:
                    self?.confirmPasswordTextField.backgroundColor = .red
                default:
                    ()
                }
                print(error)
            }
            
            self?.navigationController?.popToRootViewController(animated: true)
        }
    }
    
 
}
