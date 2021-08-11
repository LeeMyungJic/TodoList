//
//  CustomButton.swift
//  ToDoList
//
//  Created by 이명직 on 2021/08/10.
//

import Foundation
import UIKit

class CustomButton : UIButton{
    required init(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)!
        
        self.layer.cornerRadius = 10
        self.layer.borderWidth = 1
        self.layer.borderColor = #colorLiteral(red: 0.2457507253, green: 0.2251502872, blue: 0.9558088183, alpha: 1)
        self.setTitleColor(#colorLiteral(red: 0.2457507253, green: 0.2251502872, blue: 0.9558088183, alpha: 1), for: .normal)
        
    }
     
}
