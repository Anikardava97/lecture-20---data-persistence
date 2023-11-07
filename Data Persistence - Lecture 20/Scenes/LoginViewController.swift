//
//  LoginViewController.swift
//  Data Persistence - Lecture 20
//
//  Created by Ani's Mac on 05.11.23.
//

import UIKit

class KeychainManager {
    
    static let shared = KeychainManager()
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    //SAVE function
    func save(
        username: String,
        password: Data
    ) throws {
        
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username as AnyObject,
            kSecValueData as String: password as AnyObject
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        
        guard status != errSecDuplicateItem else {
            throw KeychainError.duplicateEntry
        }
        
        guard status == errSecSuccess else {
            throw KeychainError.unknown(status)
        }
        print("Password saved successfully")
    }
    
    //GET function
    func getPasswordForUsername(username: String) -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: username,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess, let data = dataTypeRef as? Data {
            if let password = String(data: data, encoding: .utf8) {
                return password
            }
        }
        return nil
    }
}

class LoginViewController: UIViewController {
    
    //MARK: - Propertiestr
    private let keychainManager = KeychainManager()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 32
        return stackView
    }()
    
    private let appTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "NotesApp"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 24/255, green: 14/255, blue: 37/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        return stackView
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.text = "Username"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 24/255, green: 14/255, blue: 37/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let usernameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Your Username"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.textColor = UIColor(red: 200/255, green: 197/255, blue: 203/255, alpha: 1.0)
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(red: 200/255, green: 197/255, blue: 203/255, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        return textField
    }()
    
    private let passwordStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.spacing = 12
        return stackView
    }()
    
    private let passwordLabel: UILabel = {
        let label = UILabel()
        label.text = "Password"
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor(red: 24/255, green: 14/255, blue: 37/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "********"
        textField.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        textField.textColor = UIColor(red: 200/255, green: 197/255, blue: 203/255, alpha: 1.0)
        textField.backgroundColor = .white
        textField.borderStyle = .roundedRect
        textField.layer.borderColor = UIColor(red: 200/255, green: 197/255, blue: 203/255, alpha: 1.0).cgColor
        textField.layer.borderWidth = 1.0
        textField.layer.cornerRadius = 8
        textField.clipsToBounds = true
        return textField
    }()
    
    private let signInButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = UIColor(red: 60/255, green: 13/255, blue: 122/255, alpha: 1.0)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBackground()
        setUpSubviews()
        setUpConstraints()
        setUpSignInButton()
    }
    
    //MARK: - Credentials
    private func isFirstTimeSignUp() {
        if isFirstTimeLogin() {
            print("Its first time")
            recordFirstTimeLogin()
            saveUserAndPasswordToKeychain()
        } else {
            checkUserAndPasswordToKeychain()
        }
    }
    
    private func isFirstTimeLogin() -> Bool {
        !UserDefaults.standard.bool(forKey: "FirstTimeLogin")
    }
    
    private func recordFirstTimeLogin() {
        UserDefaults.standard.set(true, forKey: "FirstTimeLogin")
    }
    
    private func displayWelcomeAlert() {
        let alert = UIAlertController(title: "Welcome!", message: "Welcome to the Secure NoteApp", preferredStyle: .alert)
    }
    
    private func saveUserAndPasswordToKeychain() {
        guard let username = usernameTextField.text,
              let passwordString = passwordTextField.text,
              let password = passwordString.data(using: .utf8) else {
            return }
        do {
            try keychainManager.save(username: username, password: password)
        } catch {
            print("Error saving credentials: \(error)")
        }
    }
    
    private func checkUserAndPasswordToKeychain() {
        if let username = usernameTextField.text,
           let password = passwordTextField.text {
            if let savedCredentials = KeychainManager.shared.getPasswordForUsername(username: username),
               savedCredentials == password {
                print("Welcome Back")
            } else {
                print("Please, Enter Correct Password")
            }
        }
    }
    
    //MARK: - Actions
    private func setUpSignInButton() {
        signInButton.isEnabled = false
        usernameTextField.addTarget(self, action: #selector(usernameAndPasswordTextFieldsDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(usernameAndPasswordTextFieldsDidChange), for: .editingChanged)
        
        signInButton.addAction(UIAction(handler: { [weak self] action in
            self?.navigateToNoteListVC()
        }),for: .touchUpInside)
    }
    
    @objc private func usernameAndPasswordTextFieldsDidChange(_ textField:UITextField) {
        signInButton.isEnabled = !(usernameTextField.text?.isEmpty == true) && !(passwordTextField.text?.isEmpty == true)
    }
    
    //MARK: - Private Methods
    
    private func setUpBackground() {
        view.backgroundColor = .white
    }
    
    private func setUpSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(appTitleLabel)
        
        mainStackView.addArrangedSubview(usernameStackView)
        usernameStackView.addArrangedSubview(usernameLabel)
        usernameStackView.addArrangedSubview(usernameTextField)
        
        mainStackView.addArrangedSubview(passwordStackView)
        usernameStackView.addArrangedSubview(passwordLabel)
        usernameStackView.addArrangedSubview(passwordTextField)
        
        mainStackView.addArrangedSubview(signInButton)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 160),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            usernameTextField.heightAnchor.constraint(equalToConstant: 48),
            passwordTextField.heightAnchor.constraint(equalToConstant: 48),
            signInButton.heightAnchor.constraint(equalToConstant: 56)
            
        ])
    }
    
    //MARK: - Navigation
    private func navigateToNoteListVC() {
        let noteListPage = NoteListViewController()
        navigationController?.pushViewController(noteListPage, animated: true)
        isFirstTimeSignUp()
    }
}








