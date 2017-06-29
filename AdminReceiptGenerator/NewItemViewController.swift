//
//  NewItemViewController.swift
//  AdminReceiptGenerator
//
//  Created by Artem Misesin on 5/6/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

extension NewItemViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        // Try to find next responder
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // Not found, so remove keyboard.
            textField.resignFirstResponder()
        }
        // Do not add a line break
        return false
    }
    
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
}

class NewItemViewController: UIViewController{

    var delegate: NewItemDelegate?
    
    var newItem = MenuItem()
    
    var menu = Menu()
    
    @IBOutlet weak var nameTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    @IBOutlet weak var errorLabel: UILabel!
    @IBAction func submitAction() {
        newItem.name = nameTextField.text!
        newItem.price = Double(priceTextField.text!)!
        if !menu.existing(value: newItem.name){
            if let delegate = self.delegate{
                delegate.sendDataBack(menuItem: newItem)
            }
            navigationController?.popViewController(animated: true)
        } else {
            errorLabel.text = "Menu includes " + newItem.name + " already."
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameTextField.tag = 0
        priceTextField.tag = 1
        nameTextField.delegate = self
        priceTextField.delegate = self
        self.view.backgroundColor = Colors.mainBackground
        submitButton.tintColor = Colors.deleteColor
        submitButton.isEnabled = false
        // Do any additional setup after loading the view.
        nameTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        priceTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

    func textFieldDidChange(){
        if nameTextField.text != "", priceTextField.text != ""{
                submitButton.isEnabled = true
        } else {
            submitButton.isEnabled = false
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
