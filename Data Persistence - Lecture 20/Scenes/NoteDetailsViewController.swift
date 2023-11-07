//
//  NoteDetailsViewController.swift
//  Data Persistence - Lecture 20
//
//  Created by Ani's Mac on 05.11.23.
//

import UIKit

// MARK: - protocol
protocol EditNoteDelegate: AnyObject {
    func didEdit(noteTitle: String, noteDescription: String)
}

final class NoteDetailsViewController: UIViewController, UITextViewDelegate {
    
    // MARK: - Properties
    
    weak var delegate: EditNoteDelegate?
    
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
    
    private let titleLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        textView.textColor = UIColor(red: 106/255, green: 62/255, blue: 161/255, alpha: 1.0)
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let descriptionLabel: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        textView.textColor = UIColor(red: 106/255, green: 62/255, blue: 161/255, alpha: 0.6)
        textView.textAlignment = .center
        textView.isScrollEnabled = false
        textView.isEditable = true
        textView.backgroundColor = .clear
        return textView
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.layer.cornerRadius = 8
        button.backgroundColor = UIColor(red: 60/255, green: 13/255, blue: 122/255, alpha: 0.8)
        button.setTitle("Save Changes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    // MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupBackground()
        setupSubviews()
        setupConstraints()
        setUpTextViews()
        setUpSaveButtonAction()
    }
    
    // MARK: - Configure
    func configure(with model: NoteDetails) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
    }
    
    //MARK: - Actions
    private func setUpTextViews() {
        titleLabel.delegate = self
        descriptionLabel.delegate = self
        saveButton.isEnabled = false
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView == titleLabel || textView == descriptionLabel {
            saveButton.isEnabled = !(titleLabel.text.isEmpty) && !(descriptionLabel.text.isEmpty)
        }
    }
    //წინა გვერდზე მაინც არ ინახავს რედაქტირებულ ნოუთს და ვერ ვხვდები რატო
    
    private func setUpSaveButtonAction() {
        saveButton.addAction(
            UIAction(
                handler: { [weak self] _ in
                    guard let self else { return }
                    delegate?.didEdit(
                        noteTitle: titleLabel.text ?? "",
                        noteDescription: descriptionLabel.text ?? ""
                    )
                    navigationController?.popViewController(animated: true)
                }
            ),
            for: .touchUpInside
        )
    }
    
    // MARK: - Private Methods
    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    private func setupSubviews() {
        view.addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
        mainStackView.addArrangedSubview(saveButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            mainStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            
            saveButton.heightAnchor.constraint(equalToConstant: 56)
        ])
    }
}
