//
//  CheckTableViewCell.swift
//  ToDoList
//
//  Created by longv on 20/11/2023.
//

import UIKit

protocol CheckTabViewCellDelegate: AnyObject{
    func checkTableViewCell(_ cell:CheckTableViewCell,didChangeCheckedState checked: Bool)
}

class CheckTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var checkbox: Checkbox!
    
    weak var delegate: CheckTabViewCellDelegate?
    
    @IBAction func checked(_ sender: Checkbox) {
        updateChecked()
        delegate?.checkTableViewCell(self, didChangeCheckedState: checkbox.checked)
    }
    
    func set(title:String,checked: Bool){
        label.text = title
        set(checked: checked)
    }
    
    func set(checked: Bool){
     
        checkbox.checked = checked
        updateChecked()
    }
    
    private func updateChecked(){
        let attributedString = NSMutableAttributedString(string: label.text!)
        
        if checkbox.checked{
            attributedString.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributedString.length-1))
        }else{
            attributedString.removeAttribute(.strikethroughStyle, range: NSMakeRange(0, attributedString.length-1))
        }
        
        label.attributedText = attributedString
    }
    
   
    
}
