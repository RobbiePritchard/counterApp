//
//  ViewController.swift
//  RobbieiOSCounter
//
//  Created by Robbie Pritchard on 5/6/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import UIKit
import CoreData

let detailViewControllerID = "Detail"


class MasterViewController: UIViewController {
    var counters = [NSManagedObject]()
    @IBOutlet weak var tableView: UITableView!
    
    
    var coreDataManager = CoreDataManager.shared
    lazy var networkManager = NetworkManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        if isFirstLaunch(){
            pullSampleData()
        }
        else{
            fetchSavedData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    
    func fetchSavedData(){
        self.counters = coreDataManager.fetchSavedData()
    }
    
    func pullSampleData(){
        
        let sv = UIViewController.displaySpinner(onView: self.view)
        networkManager.getSampleData(completion: { (result) in
            switch result{
            case let .success(data):
                for counter in data{
                    let newCoutner = self.coreDataManager.saveNewCounter(counterName: counter.name, count: counter.count)
                    self.counters.append(newCoutner)
                }
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
                UIViewController.removeSpinner(spinner: sv)

                
            case let .failure(error):
                print("Error: \(error)")
                self.displayAlert(with: error)
            }
        })
    }
    

    func isFirstLaunch()->Bool{
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil{
            //app already launched
            return false
        }else{
            defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
            //first time app launced
            return true
        }
    }
    
    func displayAlert(with message: String){
        let alert = UIAlertController(title: "Alert", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    
    func deleteRecord(at indexPath: IndexPath) {
        
        
        let counterToDelete = self.counters[indexPath.row]
        self.counters.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
        
        coreDataManager.deleteOne(counter: counterToDelete)
    }
    
    // UI
    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: detailViewControllerID) as! DetailViewController
        vc.parentVC = self
        show(vc,sender: nil)
    }
    
}


extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //Update
        let vc = storyboard?.instantiateViewController(withIdentifier: detailViewControllerID) as! DetailViewController
        vc.parentVC = self
        vc.updating = true
        vc.counterIndex = indexPath.row
        show(vc,sender: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return counters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CounterCell")!
        let counter = counters[indexPath.row] as! CounterEntity
        cell.textLabel?.text = counter.name
        cell.detailTextLabel?.text = counter.count.description
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRecord(at: indexPath)
        }
    }
    
    
}




