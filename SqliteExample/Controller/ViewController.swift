//
//  ViewController.swift
//  SqliteExample
//
//  Created by Kürşat Akyürek on 31.07.2023.
//

import UIKit

final class ViewController: UIViewController {
    
    var db = DBSetting()
    var personels: [PersonelModel] = []

    @IBOutlet weak var personelTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        personels.removeAll()
       
        db.insert(id: 1, name: "Kürşat Akyürek")
        db.insert(id: 2, name: "Mehmet Efendi")
        db.insert(id: 3, name: "Cansu Tezgelen")
        db.insert(id: 4, name: "Ahmet Fevzi")
        
        personels = db.read()
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return personels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = personelTableView.dequeueReusableCell(withIdentifier: "PersonelCell", for: indexPath)
        cell.textLabel?.text = personels[indexPath.row].name
        return cell
    }
    
    
}

