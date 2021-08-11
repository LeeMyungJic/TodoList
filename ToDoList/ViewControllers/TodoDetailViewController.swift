//
//  TodoDetailViewController.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/10.
//

import UIKit

class TodoDetailViewController: UIViewController {

    var getDate = ""
    var getTodo = ""
    
    weak var delegate: DeliveryDataProtocol?
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var todoLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        containerView.layer.cornerRadius = 10
        
        dateLabel.text = getDate
        todoLabel.text = getTodo

        // Do any additional setup after loading the view.
    }
    
    @IBAction func didTapCompleteBtn(_ sender: Any) {
        delegate?.deliveryData(true)
        self.dismiss(animated: true)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        self.dismiss(animated: true)
    }

}
