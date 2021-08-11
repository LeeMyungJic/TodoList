//
//  MainViewController.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/07.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    var delete: (() -> ()) = {}
    
    @IBOutlet weak var todoLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBAction func didTapDelete(_ sender: Any) {
        delete()
    }
    
}

class MainViewController: UITableViewController, DeliveryDataProtocol {
    
    let myUserDefaults = UserDefaults.standard
    
    var todo = [GroupedSection<Date, Todo>]() {
        didSet {
            print("todo 데이터 변경")
            saveTodoList()
        }
    }
    
    var todoData = [Todo]()
    var selectedIndex = 0
    var selectedSection = 0
   
    @IBAction func didTabAddButton(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let popup = storyboard.instantiateViewController(identifier: "AddToDoViewController") as! AddToDoViewController
            popup.modalTransitionStyle = .crossDissolve
            popup.modalPresentationStyle = .overFullScreen
            
            popup.delegate = self

            self.present(popup, animated: true)
        }
        else {
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getTodoList()
        self.todo = GroupedSection.group(rows: todoData, by: { firstDayOfMonth(date: parseDate($0.date)) })
        self.todo.sort { lhs, rhs in lhs.sectionItem < rhs.sectionItem }

        // Do any additional setup after loading the view.
    }
    
//    override func viewDidDisappear(_ animated: Bool) {
//        saveTodoList()
//    }
    
    @IBAction func didTabAddBtn(_ sender: Any) {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell

        let section = self.todo[indexPath.section]
        let todoData = section.rows[indexPath.row].todo
        
        cell.delete = { [unowned self] in
            self.showDeleteWarningMessage(section: indexPath.section, row: indexPath.row)
        }
        
        cell.todoLabel.text = todoData

        return cell
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        saveTodoList()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let id = segue.identifier, "detail" == id {
            if let controller = segue.destination as? TodoDetailViewController {
                    if let indexPath = tableView.indexPathForSelectedRow {
                        let section = self.todo[indexPath.section]
                        let todoData = section.rows[indexPath.row]
                        
                        controller.getDate = todoData.date
                        controller.getTodo = todoData.todo
                        controller.delegate = self
                
                }
            }
        }
    }
    
    fileprivate func showDeleteWarningMessage(section: Int, row: Int) {
        let msgalert = UIAlertController(title: "주의", message: "상품을 삭제하시겠습니까?", preferredStyle: .alert)
        
        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
            self.todoData.remove(at: self.todo[section].rows[row].index)
            self.changeTableView()
        })
        let CANCEL = UIAlertAction(title: "취소", style: .default)
        msgalert.addAction(YES)
        msgalert.addAction(CANCEL)
        self.present(msgalert, animated: true, completion: nil)
    }
    
    fileprivate func saveTodoList() {
        UserDefaults.standard.set(try? PropertyListEncoder().encode(todoData), forKey:"todoList")
    }

    fileprivate func getTodoList() {
        if let data = UserDefaults.standard.value(forKey:"todoList") as? Data {
            let getData = try! PropertyListDecoder().decode([Todo].self, from: data)
            self.todoData = getData
            changeTableView()
        }
    }
    
    fileprivate func changeTableView() {
        self.todo = GroupedSection.group(rows: todoData, by: { firstDayOfMonth(date: parseDate($0.date)) })
        self.todo.sort { lhs, rhs in lhs.sectionItem < rhs.sectionItem }
        self.tableView.reloadData()
    }
    
    
    func deliveryData(_ data: Any) {
        if data as? Bool == true {
            AppDelegate.todoHistory.append(todo[selectedSection].rows[selectedIndex])
            self.todoData.remove(at: todo[selectedSection].rows[selectedIndex].index)
            changeTableView()
        }
        else {
            let getData = data as! Todo
            
            self.todoData.append(Todo(todo: getData.todo, date: getData.date, index: todoData.count))
            changeTableView()
        }
    }
}
