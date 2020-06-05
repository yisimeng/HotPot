//
//  ViewController.swift
//  HotPot
//
//  Created by duanzengguang on 2020/2/9.
//  Copyright © 2020 duanzengguang. All rights reserved.
//

import UIKit
import SwifterSwift
import WCDBSwift

private let hotpotIdentifier = "hotpotIdentifier"

class ViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var dataSource: [ShitDate] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "火锅铲屎"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: hotpotIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 80
        print(NSHomeDirectory())
        DBManager.create(table: "ShitDate", for: ShitDate.self)
        fatchData()
    }
    @IBAction func push(_ sender: Any) {
        let shitDate = ShitDate()
        DBManager.inseart(objects: shitDate, intoTable: "ShitDate")
        if let id = DBManager.qurey(fromTable: "ShitDate", cls: ShitDate.self, where: ShitDate.Properties.identifier == shitDate.identifier)?.first?.identifier {
            shitDate.identifier = id
            dataSource.insert(shitDate, at: 0)
            let indexSet = IndexSet(arrayLiteral: 0)
            tableView.reloadSections(indexSet, with: .automatic)
        }else {
            fatchData()
        }
    }
}

extension ViewController {
    private func fatchData (){
        DispatchQueue.global().async {
            if let dates = DBManager.qurey(fromTable: "ShitDate", cls: ShitDate.self){
                self.dataSource = dates.reversed()
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    }
    private func removeObject(at index: Int) {
        let shitDate = dataSource[index]
        DBManager.delete(fromTable: "ShitDate", where: ShitDate.Properties.identifier == shitDate.identifier)
        dataSource.remove(at: index)
    }
}

extension ViewController: UITableViewDelegate {}

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        removeObject(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .left)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: hotpotIdentifier, for: indexPath)
        let shitDate = dataSource[indexPath.row]
        cell.textLabel?.text = shitDate.dateString
        return cell
    }
}

