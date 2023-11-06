//
//  LoginViewController.swift
//  Data Persistence - Lecture 20
//
//  Created by Ani's Mac on 05.11.23.
//

import UIKit

class KeychainManager {
    
    enum KeychainError: Error {
        case duplicateEntry
        case unknown(OSStatus)
    }
    
    static func save(service: String, account: String, password: Data) throws {
        let query: [String: AnyObject] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service as AnyObject,
            kSecAttrAccount as String: account as AnyObject,
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
}

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
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
        saveCredentialsToKeychain()
        validateCredentials()
//        isFirstTimeLogin()
        recordFirstTimeLogin()
//        displayWelcomeAlert()
    }
    
    
    //MARK: - Credentials
    
    func saveCredentialsToKeychain() {
        do {
            try KeychainManager.save(service: "NotesApp", account: "Ani", password: "password".data(using: .utf8) ?? Data())
        }
        catch {
            print("Error saving password: \(error)")
        }
    }
    
    func validateCredentials() {
        
        
    }
    
    func isFirstTimeLogin() -> Bool {
        UserDefaults.standard.bool(forKey: "FirstTimeLogin")
    }
    
    func recordFirstTimeLogin() {
        UserDefaults.standard.set(true, forKey: "FirstTimeLogin")
    }
    
//    func displayWelcomeAlert() {
//        let alert = UIAlertController(title: "Welcome!", message: "Welcome to the Secure NoteApp", preferredStyle: .alert)
//    }
//    
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
    }
}








