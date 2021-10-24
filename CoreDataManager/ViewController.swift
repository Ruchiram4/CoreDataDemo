//
//  ViewController.swift
//  CoreDataManager
//
//  Created by Ruchira Macbook on 2021-10-23.
//

import UIKit

class ViewController: UIViewController {

    let tableView = UITableView()
    var arrayOfPeople = [PersonEntity]()
    var dbHandler: DBHandler?
    
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
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        dbHandler = DBHandler(withContext: context)
        syncWithDB()
        
    }
    
    @objc func addButtonPressed() {
        print("Add button pressed..")
        
        let alert = UIAlertController.init(title: "Add person", message: "Please enter details about the person to add.", preferredStyle: .alert)
        alert.addTextField { textFieldName in
            textFieldName.placeholder = "Please enter name."
        }
        alert.addTextField { textFieldAge in
            textFieldAge.placeholder = "Please enter age."
        }
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
                    let alert = UIAlertController(title: "Oops...", message: "Please enter a non empty name and a valid age", preferredStyle: .actionSheet)
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
        tableView.reloadData()
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
        let person = arrayOfPeople[indexPath.row]
        cell.textLabel?.text = person.name
        return cell
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayOfPeople.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
}

