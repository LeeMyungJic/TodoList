//
//  MainViewController.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/07.
//

import UIKit

class ToDoCell: UITableViewCell {
    
    var delete: (() -> ()) = {}
    
    @IBOutlet weak var toDoLabel: UILabel!
    @IBOutlet weak var deleteBtn: UIButton!
    
    @IBAction func didTapDelete(_ sender: Any) {
        delete()
    }
    
}

class MainViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var todo = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        todo.append("dd")
        todo.append("aa")
        todo.append("pp")
        todo.append("dd")
        tableView.delegate = self
        tableView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    fileprivate func showDeleteWarningMessage(index: Int) {
        let msgalert = UIAlertController(title: "주의", message: "상품을 삭제하시겠습니까?", preferredStyle: .alert)
        
        let YES = UIAlertAction(title: "확인", style: .default, handler: { (action) -> Void in
            self.todo.remove(at: index)
            self.tableView.reloadData()
        })
        let CANCEL = UIAlertAction(title: "취소", style: .default)
        msgalert.addAction(YES)
        msgalert.addAction(CANCEL)
        self.present(msgalert, animated: true, completion: nil)
    }

}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCell", for: indexPath) as! ToDoCell
        
        cell.toDoLabel.text = todo[indexPath.row]
        
        cell.delete = { [unowned self] in
            self.showDeleteWarningMessage(index: indexPath.row)
        }
        
        return cell
    }
}

