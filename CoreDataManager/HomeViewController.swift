//
//  HomeViewController.swift
//  CoreDataManager
//
//  Created by Ruchira Macbook on 2021-10-23.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {

    let tableView = UITableView()
    var arrayOfPeople = [PersonEntity]()
    var dbHandler: DBHandlerProtocol?
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            tableView.widthAnchor.constraint(equalTo: view.widthAnchor),
            tableView.heightAnchor.constraint(equalTo: view.heightAnchor)
        ])
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonPressed))
        self.navigationItem.rightBarButtonItem = addButton
        syncWithDB()
        
    }
    
    public init(withContext: NSManagedObjectContext) {
        super.init(nibName: nil, bundle: nil)
        self.dbHandler = Factory.createDBHandler(withContext: withContext)
    }
    
    required init?(coder: NSCoder) {
        fatalError("You should not use this init method.")
    }
    
    func reloadTableView() {
        
        tableView.reloadData()
        
        if arrayOfPeople.isEmpty {
            let placeholderLabel = UILabel()
            placeholderLabel.translatesAutoresizingMaskIntoConstraints = false
            tableView.separatorColor = .white
            tableView.backgroundView = placeholderLabel
            
            NSLayoutConstraint.activate([
                placeholderLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                placeholderLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                placeholderLabel.heightAnchor.constraint(equalToConstant: 20.0)
            ])
            placeholderLabel.text = "There aren't any people to display."
            placeholderLabel.numberOfLines = 0
            
        }
        else {
            tableView.backgroundView = nil
            tableView.separatorColor = .gray
        }
    }
    
    @objc func addButtonPressed() {
        
        let alert = UIAlertController.init(title: "Add person", message: "Please enter details about the person to add.", preferredStyle: .alert)
        alert.addTextField { textFieldName in
            textFieldName.placeholder = "Please enter name."
            textFieldName.autocapitalizationType = .sentences
        }
        alert.addTextField { textFieldAge in
            textFieldAge.placeholder = "Please enter age."
            textFieldAge.keyboardType = .numberPad
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "Add", style: .default, handler: { alertAction in
            
            let name = alert.textFields?.first?.text
            let age = alert.textFields?[1].text
            
            if self.validateTextInputs(name: name!, age: age!) {
                guard let text = name, let age = age else {return}
                self.dbHandler?.addPerson(name: text, age: Int(age)!)
                self.syncWithDB()
            }
            else {
                alert.dismiss(animated: true) {
                    let alert = UIAlertController(title: "Oops...", message: "Please enter a non empty Name and a valid Age.", preferredStyle: .actionSheet)
                    alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { action in
                        self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }))
        
        present(alert, animated: true, completion: nil)
    }

    func validateTextInputs(name: String, age: String) -> Bool {
        let nameNonEmpty = !name.isEmpty
        let age = Int(age)
        guard let _ = age else {
            return false
        }
        return nameNonEmpty
    }
    
    func syncWithDB() {
        let persons = dbHandler?.getAllPersons()
        arrayOfPeople = persons!
        reloadTableView()
    }

}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let person = arrayOfPeople[indexPath.row]
        cell.textLabel?.text = "\(person.name!) - \(String(person.age))"
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPeople.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let alert = UIAlertController(title: nil, message: "Please select an action to perform", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { actionDelete in
            
            let index = indexPath.row
            let person = self.arrayOfPeople[index]
            self.dbHandler?.deletePerson(person: person)
            self.syncWithDB()
            self.reloadTableView()
            
        }))
        alert.addAction(UIAlertAction(title: "Edit", style: .default, handler: { actionEdit in
            
            self.dismiss(animated: true) {
                
                let index = indexPath.row
                let person = self.arrayOfPeople[index]
                
                let alert = UIAlertController(title: "Update", message: "Please update the user information.", preferredStyle: .alert)
                alert.addTextField { textFieldName in
                    textFieldName.placeholder = "Please enter name."
                    textFieldName.autocapitalizationType = .sentences
                    textFieldName.text = person.name
                }
                alert.addTextField { textFieldAge in
                    textFieldAge.placeholder = "Please enter age."
                    textFieldAge.keyboardType = .numberPad
                    textFieldAge.text = String(person.age)
                }
                
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
                alert.addAction(UIAlertAction(title: "Update", style: .default, handler: { actionSave in
                    let newName = alert.textFields![0].text
                    let newAge = alert.textFields![1].text
                    
                    person.name = newName
                    person.age = Int16(newAge!)!
                    
                    self.dbHandler?.updatePerson(updatedPerson: person)
                    self.syncWithDB()
                    self.reloadTableView()
                }))
                
                self.present(alert, animated: true, completion: nil)
            }
            
        }))
        
        present(alert, animated: true, completion: nil)
        
    }
    
    
}

