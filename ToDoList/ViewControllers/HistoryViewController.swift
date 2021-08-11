//
//  HistoryViewController.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/07.
//

import UIKit

class historyCell: UITableViewCell {
    
    @IBOutlet weak var todoLabel: UILabel!
    
}

class HistoryViewController: UITableViewController {
    
    var todo = [GroupedSection<Date, Todo>]() {
        didSet {
            saveTodoList()
        }
    }
    
    var selectedSection = 0
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.todo = GroupedSection.group(rows: AppDelegate.todoHistory, by: { firstDayOfMonth(date: parseDate($0.date)) })
        self.todo.sort { lhs, rhs in lhs.sectionItem < rhs.sectionItem }
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.todo.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let section = self.todo[section]
        let date = section.sectionItem
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM yyyy"
        return dateFormatter.string(from: date)
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.todo[section]
        return section.rows.count
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSection = indexPath.section
        selectedIndex = indexPath.row
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "historyCell", for: indexPath) as! historyCell

        let section = self.todo[indexPath.section]
        let todoData = section.rows[indexPath.row].todo

        cell.todoLabel.text = todoData

        return cell
    }

    fileprivate func saveTodoList() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(AppDelegate.todoHistory), forKey:"historyList")
    }
}
