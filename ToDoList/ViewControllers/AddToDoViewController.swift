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
    @IBOutlet weak var myDatePicker: UIDatePicker!
    
    weak var delegate: DeliveryDataProtocol?
    
    var selectedDate = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSubView()

    }
    
    fileprivate func setSubView() {
        self.subView.layer.cornerRadius = 10
    }
    @IBAction func didTabCancel(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTabAddBtn(_ sender: Any) {
        delegate?.deliveryData(Todo(todo: self.todoLabel.text!, date: self.selectedDate, index: 0))
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func changeDatePicker(_ sender: UIDatePicker) {
        let datePickerView = sender
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        selectedDate = formatter.string(from: datePickerView.date)
    }
    
}


