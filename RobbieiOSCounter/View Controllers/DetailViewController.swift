//
//  DetailViewController.swift
//  RobbieiOSCounter
//
//  Created by Robbie Pritchard on 5/6/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var minusButton: UIButton!
    var nameTextField: UITextField!

    var count = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetup()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func navigationSetup(){
        //setup BackButton
        let backButton = UIBarButtonItem()
        backButton.title = ""
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        
        //setup name Textfield
        nameTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 22))
        nameTextField.text = "Unnamed Counter"
        nameTextField.font = UIFont.boldSystemFont(ofSize: 19)
        nameTextField.textColor = .black
        nameTextField.textAlignment = .center
        nameTextField.backgroundColor = .clear
        nameTextField.delegate = self
        
        nameTextField.becomeFirstResponder()

        
        
        self.navigationItem.titleView = nameTextField
    }
    
    
    @IBAction func incementButtonPress(_ sender: UIButton) {
        count += 1
        self.countLabel.text = count.description
    }
    
    
    @IBAction func decrementButtonPress(_ sender: UIButton) {
        if count == 0{
            //flash red
            self.countLabel.flashTextColor(from: .black, to: .red, for: 0.2)
        }
        else{
            count -= 1
            self.countLabel.text = count.description
        }

    }
}

extension DetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
