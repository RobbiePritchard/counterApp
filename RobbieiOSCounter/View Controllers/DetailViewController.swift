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
    
    
    var parentVC : MasterViewController?

    
    //coredata
    var coreDataManager = CoreDataManager.shared
    
    
    
    //if updating
    var updating = false
    var counterIndex: Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationSetup()
        updatingSetup(isUpdate: updating)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updating ? updateCounter() : saveCounter()
    }
    
    func updatingSetup(isUpdate: Bool){
        if isUpdate{
            //updating flow
            guard let counter = parentVC?.counters[counterIndex!] as? CounterEntity  else{
                fatalError()
            }
            nameTextField.text = counter.name
            self.count = Int(counter.count)
            self.countLabel.text = self.count.description
        }
        else{
            // new flow
            nameTextField.becomeFirstResponder()
        }
    }
    
    //UI Navigation Bar
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
    
    
    // save + update
    
    func saveCounter(){
        let counterName = nameTextField.text ?? ""
        let newCounter = coreDataManager.saveNewCounter(counterName: counterName, count: self.count)
        
        //update datasource
        parentVC?.counters.insert(newCounter, at: 0)
    }
    
    func updateCounter(){
        guard let counter = parentVC?.counters[counterIndex!] as? CounterEntity  else{
            fatalError()
        }
        
        let counterName = nameTextField.text ?? ""
        
        let updatedCounter = coreDataManager.updateOne(counterEntity: counter, counterName: counterName, count: self.count)
        
        // update datasource
        parentVC?.counters.remove(at: counterIndex!)
        parentVC?.counters.insert(updatedCounter, at: 0)
    }
}

extension DetailViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
