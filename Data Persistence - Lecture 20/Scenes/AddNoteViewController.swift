//
//  AddNoteViewController.swift
//  Data Persistence - Lecture 20
//
//  Created by Ani's Mac on 05.11.23.
//

import UIKit

// MARK: - protocol
protocol AddNewNoteDelegate: AnyObject {
    func addNewNote(with note: NoteDetails)
}

final class AddNoteViewController: UIViewController {
    
    // MARK: - Properties
    
    weak var delegate: AddNewNoteDelegate?
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 32
        stackView.backgroundColor = UIColor(red: 247/255, green: 246/255, blue: 212/255, alpha: 1.0)
        stackView.layer.cornerRadius = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        return stackView
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Add New Note"
        return textField
    }()
    
    private let descriptionTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "..."
        return textField
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 60/255, green: 13/255, blue: 122/255, alpha: 0.8)
        button.setTitle("Save Information", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupButtonAction()
    }
    
    // MARK: - Private Methods
    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleTextField)
        mainStackView.addArrangedSubview(descriptionTextField)
        mainStackView.addArrangedSubview(saveButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
    
    private func setupButtonAction() {
        saveButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    delegate?.addNewNote(with: .init(
                        title: titleTextField.text ?? String(),
                        description: descriptionTextField.text ?? String()
                    ))
                    navigationController?.popViewController(animated: true)
                }
            ),
            for: .touchUpInside
        )
    }
}
