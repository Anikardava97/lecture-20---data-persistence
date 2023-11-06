//
//  NoteDetailsViewController.swift
//  Data Persistence - Lecture 20
//
//  Created by Ani's Mac on 05.11.23.
//

import UIKit

final class NoteDetailsViewController: UIViewController {
    
    // MARK: - Properties
    
    private lazy var mainStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel])
        stackView.axis = .vertical
        stackView.spacing = 20
        stackView.backgroundColor = UIColor(red: 239/255, green: 233/255, blue: 247/255, alpha: 1.0)
        stackView.layer.cornerRadius = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = UIEdgeInsets(top: 32, left: 16, bottom: 32, right: 16)
        return stackView
    }()
    
    private let titleLabel: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textField.textColor = UIColor(red: 106/255, green: 62/255, blue: 161/255, alpha: 1.0)
        textField.textAlignment = .center
        return textField
    }()
    
    private let descriptionLabel: UITextField = {
        let textField = UITextField()
        textField.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textField.textColor = UIColor(red: 106/255, green: 62/255, blue: 161/255, alpha: 0.6)
        textField.textAlignment = .center
        return textField
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupSubviews()
        setupConstraints()
        setupUI()
    }
    
    // MARK: - Configure
    func configure(with model: NoteDetails) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
    
    // MARK: - Private Methods
    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    private var isEditable: Bool = false
    
    private lazy var saveButton: UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveChanges))
        return button
    }()
    
    @objc func toggleEditing() {
        isEditable.toggle()
        titleLabel.isUserInteractionEnabled = isEditable
        descriptionLabel.isUserInteractionEnabled = isEditable
        setupUI()
    }
    
    @objc func saveChanges() {
        let newTitle = titleLabel.text ?? ""
        let newDescription = descriptionLabel.text ?? ""
        toggleEditing()
    }
    
    private func setupUI() {
        if isEditable {
            navigationItem.rightBarButtonItem = saveButton
        } else {
            navigationItem.rightBarButtonItem = editButtonItem
        }
    }
}
