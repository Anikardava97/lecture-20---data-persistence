//
//  NotesTableViewCell.swift
//  Data Persistence - Lecture 20
//
//  Created by Ani's Mac on 05.11.23.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.layoutMargins = .init(top: 24, left: 16, bottom: 24, right: 16)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = UIColor(red: 106/255, green: 62/255, blue: 161/255, alpha: 1.0)
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.textColor = UIColor(red: 106/255, green: 62/255, blue: 161/255, alpha: 0.6)
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        addSubviews()
        setupConstraints()
        prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - PrepareForReuse
    override func prepareForReuse() {
        super.prepareForReuse()
        
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    // MARK: - Configure
    func configure(with model: NoteDetails, indexPath: IndexPath) {
        titleLabel.text = model.title
        descriptionLabel.text = model.description
        
        let colours = [
            UIColor(red: 247/255, green: 246/255, blue: 212/255, alpha: 1.0),
            UIColor(red: 239/255, green: 233/255, blue: 247/255, alpha: 1.0),
            UIColor(red: 218/255, green: 246/255, blue: 228/255, alpha: 1.0),
            UIColor(red: 218/255, green: 236/255, blue: 246/255, alpha: 1.0)
        ]
        backgroundColor = colours[indexPath.row % colours.count]
    }
    // MARK: - Private Methods
    
    private func addSubviews() {
        addSubview(mainStackView)
        mainStackView.addArrangedSubview(titleLabel)
        mainStackView.addArrangedSubview(descriptionLabel)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainStackView.topAnchor.constraint(equalTo: self.topAnchor),
            mainStackView.leftAnchor.constraint(equalTo: self.leftAnchor),
            mainStackView.rightAnchor.constraint(equalTo: self.rightAnchor),
            mainStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
        ])
    }
}
