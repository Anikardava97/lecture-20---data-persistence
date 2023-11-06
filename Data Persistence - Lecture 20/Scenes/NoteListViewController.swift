//
//  NoteListViewController.swift
//  Data Persistence - Lecture 20
//
//  Created by Ani's Mac on 05.11.23.
//

import UIKit

final class NoteListViewController: UIViewController {
    
    //MARK: - Properties
    
    private var notes = NoteDetails.myNotes
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    private let notesTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Notes"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 24/255, green: 14/255, blue: 37/255, alpha: 1.0)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - ViewLifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackground()
        setUpSubviews()
        setUpConstraints()
        setupNavigationBar()
        setupTableView()
    }
    
    //MARK: - Private Methods
    private func setupBackground() {
        view.backgroundColor = .white
    }
    
    private func setupNavigationBar() {
        let barButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(setupAddButtonAction)
        )
        navigationItem.setRightBarButton(barButtonItem, animated: true)
    }
    
    private func setUpSubviews() {
        view.addSubview(notesTitleLabel)
        view.addSubview(tableView)
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 56),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            notesTitleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 12),
            notesTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16)
            
        ])
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NotesTableViewCell.self, forCellReuseIdentifier: "notesCell")
    }
    
    @objc private func setupAddButtonAction() {
        let addNewNoteToAddNoteViewController = AddNoteViewController()
        addNewNoteToAddNoteViewController.delegate = self
        navigationController?.pushViewController(addNewNoteToAddNoteViewController, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            notes.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - TableVIew DataSource
extension NoteListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        notes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let note = notes[indexPath.row]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "notesCell") as? NotesTableViewCell {
            cell.configure(with: note, indexPath: indexPath)
            return cell
        }
        return UITableViewCell()
    }
}

// MARK: - TableVIew Delegate
extension NoteListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let noteDetailsViewController = NoteDetailsViewController()
        noteDetailsViewController.configure(with: notes[indexPath.row])
        navigationController?.pushViewController(noteDetailsViewController, animated: true)
    }
}

// MARK: - AddNewNoteDelegate
extension NoteListViewController: AddNewNoteDelegate {
    func addNewNote(with note: NoteDetails) {
        notes.append(note)
        tableView.reloadData()
    }
}

