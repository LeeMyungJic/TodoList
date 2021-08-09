//
//  AddToDoViewController.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/07.
//

import UIKit
import TweeTextField

class AddToDoViewController: UIViewController {

    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var todoLabel: TweeActiveTextField!
    @IBOutlet weak var dateLabel: UITextField!
    
    weak var delegate: DeliveryDataProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubView()

        // Do any additional setup after loading the view.
    }
    
    fileprivate func setSubView() {
        self.subView.layer.cornerRadius = 10
    }
    @IBAction func didTabCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func didTabAddBtn(_ sender: Any) {
        delegate?.deliveryData(Todo(todo: self.todoLabel.text!, date: parseDate(self.dateLabel.text!)))
    }
    
}
