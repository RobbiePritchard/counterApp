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
    lazy var coreDataManager = CoreDataManager()


    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
        fetchSavedData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }


    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: detailViewControllerID) as! DetailViewController
        vc.parentVC = self
        show(vc,sender: nil)
    }
    
    func fetchSavedData(){
        self.counters = coreDataManager.fetchSavedData()
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
    
    
}

