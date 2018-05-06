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
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func addButtonPress(_ sender: UIBarButtonItem) {
        let vc = storyboard?.instantiateViewController(withIdentifier: detailViewControllerID) as! DetailViewController
        show(vc,sender: nil)
    }
    
}

extension MasterViewController: UITableViewDelegate, UITableViewDataSource {
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

