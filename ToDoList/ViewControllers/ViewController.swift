//
//  ViewController.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/07.
//

import UIKit
import PagingKit

class ViewController: UIViewController {

    var menuViewController: PagingMenuViewController!
    var contentViewController: PagingContentViewController!
    var menus = ["1", "2"]
    
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addButton: UIButton!
    var dataSource = [(menu: String, content: UIViewController)]() {
        didSet{
            menuViewController.reloadData()
            contentViewController.reloadData()
        }
    }
    
    static var viewController: (UIColor) -> UIViewController = { (color) in
        let vc = UIViewController()
        vc.view.backgroundColor = color
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setPagingController()
        setAddButton()
        setContentView()
        
    }
    
    fileprivate func makeDataSource() -> [(menu: String, content: UIViewController)] {
        return menus.map {
            let title = $0
            switch title {
            case "1":
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MainViewController") as! MainViewController
                return (menu: "할 일", content: vc)
            default:
                let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "HistoryViewController") as! HistoryViewController
                return (menu: "완료", content: vc)
            }
        }
    }
    
    fileprivate func setAddButton() {
        addButton.layer.cornerRadius = addButton.frame.width/2
    }
    
    fileprivate func setContentView() {
        contentView.layer.borderWidth = 1.2
        contentView.layer.borderColor = #colorLiteral(red: 0.2457507253, green: 0.2251502872, blue: 0.9558088183, alpha: 1)
        contentView.layer.cornerRadius = 10
    }
    
    fileprivate func setPagingController() {
        menuViewController.register(nib: UINib(nibName: "MenuCell", bundle: nil), forCellWithReuseIdentifier: "MenuCell")
        menuViewController.registerFocusView(nib: UINib(nibName: "FocusView", bundle: nil))
        menuViewController.cellAlignment = .center
        
        dataSource = makeDataSource()
    }
    
    @IBAction func didTabAddBtn(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if #available(iOS 13.0, *) {
            let popup = storyboard.instantiateViewController(identifier: "AddToDoViewController") as! AddToDoViewController
            popup.modalTransitionStyle = .crossDissolve
            popup.modalPresentationStyle = .overFullScreen
            
            self.present(popup, animated: false)
        } else {
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if let vc = segue.destination as? PagingMenuViewController {
                menuViewController = vc
                menuViewController.dataSource = self
                menuViewController.delegate = self
            }
            else if let vc = segue.destination as? PagingContentViewController {
                contentViewController = vc
                contentViewController.dataSource = self
                contentViewController.delegate = self
            }
       
        }
}

extension ViewController: PagingMenuViewControllerDataSource {
    func numberOfItemsForMenuViewController(viewController: PagingMenuViewController) -> Int {
        return dataSource.count
    }
    
    func menuViewController(viewController: PagingMenuViewController, widthForItemAt index: Int) -> CGFloat {
        return 100
    }
    
    func menuViewController(viewController: PagingMenuViewController, cellForItemAt index: Int) -> PagingMenuViewCell {
        let cell = viewController.dequeueReusableCell(withReuseIdentifier: "MenuCell", for: index) as! MenuCell
        cell.label.text = dataSource[index].menu
        print(dataSource[index].menu)
        
        return cell
    }
}

extension ViewController: PagingMenuViewControllerDelegate {
    func menuViewController(viewController: PagingMenuViewController, didSelect page: Int, previousPage: Int) {
        contentViewController.scroll(to: page, animated: true)
    }
}

extension ViewController: PagingContentViewControllerDataSource {
    func numberOfItemsForContentViewController(viewController: PagingContentViewController) -> Int {
        return dataSource.count
    }
    
    func contentViewController(viewController: PagingContentViewController, viewControllerAt index: Int) -> UIViewController {
        return dataSource[index].content
    }
}

extension ViewController: PagingContentViewControllerDelegate {
    func contentViewController(viewController: PagingContentViewController, didManualScrollOn index: Int, percent: CGFloat) {
        menuViewController.scroll(index: index, percent: percent, animated: true)
    }
}
