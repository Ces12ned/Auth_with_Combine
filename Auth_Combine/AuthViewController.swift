//
//  AuthViewController.swift
//  Auth_Combine
//
//  Created by Edgar Cisneros on 18/05/23.
//

import UIKit
import Combine

class AuthViewController: UIViewController {
    
    //MARK: - Variables & Constants
    
    //UI
    
    private var dataStack = UIStackView()
    private let userTextField = UITextField()
    private let passwordTextField = UITextField()
    private let passwordCheckTextField = UITextField()
    private let logInButton = UIButton()
    
    
    //Logic
    
    //Step 1. Define our Publishers
    
    @Published var userName: String = ""
    @Published var password = ""
    @Published var passwordCheck = ""
    
    //MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor(red: 31/255, green: 26/255, blue: 46/255, alpha: 1)
        
        authUISetUp()
        authLogic()
    }
    
    
    //Step 2. Define our validation streams
    
    var validatedUserName: AnyPublisher<String?,Never> {
        return $userName
            .debounce(for: 0.5, scheduler: RunLoop.main)
            .removeDuplicates()
            .flatMap { userName in
                return Future { promise in
                    self.usernameAvailable(userName) { available in
                        promise(.success(available ? userName : nil))
                    }
                }
            }
            .eraseToAnyPublisher()
    }
    
    func usernameAvailable(_ username: String, completion: (Bool) -> Void) {
        completion(true) // Our fake asynchronous backend service
    }
    
    var validatedPassword: AnyPublisher<String?, Never>{
        return Publishers.CombineLatest($password, $passwordCheck)
            .map{ password, passwordCheck in
                guard password == passwordCheck, password.count > 0 else { return nil}
                return password
            }
            .map {
                ($0 ?? "") == "password" ? nil : $0
            }
            .eraseToAnyPublisher()
    }
    
    var validateCredentials: AnyPublisher<(String,String)?, Never> {
        
        return Publishers.CombineLatest(validatedUserName, validatedPassword)
            .receive(on: RunLoop.main)
            .map { userName, password in
                guard let uName = userName, let pwd = password else {return nil}
                self.logInButton.backgroundColor = UIColor(red: 99/255, green: 215/255, blue: 197/255, alpha: 1)
                return (uName, pwd)
            }
        .eraseToAnyPublisher()
    }
    
    
    //Step 3. Define suscriber
    
    var createSuscriber: AnyCancellable?
    
    
    //MARK: - Methods
    
    
    private func authLogic(){
        
        logInButton.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        createSuscriber = validateCredentials
            .map{$0 != nil}
            .receive(on: RunLoop.main)
            .assign(to: \.isEnabled, on: logInButton)
    }
    
    
    
    @objc private func logInButtonTapped(_ sender: UIButton){
        
        navigationController?.pushViewController(HomeViewController(), animated: true)
        
    
    }
    
    
    
    // UI SetUp
    
    private func authUISetUp(){
        view.addSubview(dataStack)
        dataStack.axis = .vertical
        dataStack.distribution = .fill
        dataStack.spacing = 8
        addObjectsToTheDataStack()
        setDataStackViewConstraints()
    }
    
    
    private func addObjectsToTheDataStack(){
        
        userTextField.delegate = self
        passwordTextField.delegate = self
        passwordCheckTextField.delegate = self
        
        userTextField.attributedPlaceholder = NSAttributedString(string: "User", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        passwordTextField.attributedPlaceholder = NSAttributedString(string: "Password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        passwordCheckTextField.attributedPlaceholder = NSAttributedString(string: "Repeat password", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.6)])
        
        userTextField.setupLeftSideImage(imageViewNamed: "person")
        passwordTextField.setupLeftSideImage(imageViewNamed: "lock")
        passwordCheckTextField.setupLeftSideImage(imageViewNamed: "lock.shield")
        
        passwordTextField.isSecureTextEntry = true
        passwordCheckTextField.isSecureTextEntry = true
        
        userTextField.borderStyle = .roundedRect
        passwordTextField.borderStyle = .roundedRect
        passwordCheckTextField.borderStyle = .roundedRect
        
        userTextField.clipsToBounds = true
        passwordTextField.clipsToBounds = true
        passwordCheckTextField.clipsToBounds = true
        
        userTextField.layer.cornerRadius = 18
        passwordTextField.layer.cornerRadius = 18
        passwordCheckTextField.layer.cornerRadius = 18
        
        userTextField.backgroundColor = UIColor(red: 187/255, green: 145/255, blue: 248/255, alpha: 1)
        passwordTextField.backgroundColor = UIColor(red: 187/255, green: 145/255, blue: 248/255, alpha: 1)
        passwordCheckTextField.backgroundColor = UIColor(red: 187/255, green: 145/255, blue: 248/255, alpha: 1)
       
        
        userTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordCheckTextField.translatesAutoresizingMaskIntoConstraints = false
        
        userTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordCheckTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        logInButton.setTitle("Log In", for: .normal)
        logInButton.titleLabel?.font = .systemFont(ofSize: 24)
        logInButton.backgroundColor = .clear
        logInButton.setTitleColor(.white, for: .normal)
        
    
        logInButton.layer.cornerRadius = 32
        
        logInButton.translatesAutoresizingMaskIntoConstraints = false
        logInButton.heightAnchor.constraint(equalToConstant: 66).isActive = true
        logInButton.widthAnchor.constraint(equalToConstant: view.frame.width/2).isActive = true
        
        
        logInButton.backgroundColor = .lightGray
        
        
        dataStack.addArrangedSubview(userTextField)
        dataStack.addArrangedSubview(passwordTextField)
        dataStack.addArrangedSubview(passwordCheckTextField)
        dataStack.setCustomSpacing(32, after: passwordCheckTextField)
        dataStack.addArrangedSubview(logInButton)
        
    }
    
    private func setDataStackViewConstraints(){
        
        dataStack.translatesAutoresizingMaskIntoConstraints = false
        dataStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: ((view.frame.size.height)/4)).isActive = true
        dataStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        dataStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        
    }

    

}


extension AuthViewController: UITextFieldDelegate {
       
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let textFieldText = textField.text ?? ""
        let text = (textFieldText as NSString).replacingCharacters(in: range, with: string)
        
        if textField == userTextField { userName = text }
        if textField == passwordTextField { password = text }
        if textField == passwordCheckTextField { passwordCheck = text }
        
        return true
    }
}
