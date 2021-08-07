//
//  AddToDoViewController.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/07.
//

import UIKit

class AddToDoViewController: UIViewController {

    @IBOutlet weak var subView: UIView!
    
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
