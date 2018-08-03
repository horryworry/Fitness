//
//  SavedRunsViewController.swift
//  Fitness
//
//  Created by Atay Sultangaziev on 8/1/18.
//  Copyright © 2018 Atay Sultangaziev. All rights reserved.
//

import UIKit
import CoreData

class SavedRunsTVC: UITableViewController {
    
    var path: Int = 0
    var results = [Run]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        catchAllRuns()
    }
    
    func catchAllRuns() {
        let managedObjectContext = CoreDataHelper.context
        
        
        managedObjectContext.performAndWait {
            do {
                let fetchRequest: NSFetchRequest<Run> = Run.fetchRequest()
                
                let runs = try fetchRequest.execute()
                results = runs
                if let run = runs.first {
                    let distance = run.distance
                }
                
            } catch {
                print(error)
            }
        }
        
        
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return results.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runCell", for: indexPath)
        
        cell.textLabel?.textColor = .black
        cell.textLabel?.text = FormatDisplay.date(results[indexPath.section].timestamp)
        cell.textLabel?.font = UIFont(name: "AmericanTypewriter-CondensedLight", size: 17)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.popViewController(animated: true)
        path = indexPath.section
        self.performSegue(withIdentifier: "RunDetailsVC", sender: nil)
    }
    
}

extension SavedRunsTVC: SegueHandlerType {
    enum SegueIdentifier: String {
        case details = "RunDetailsVC"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segueIdentifier(for: segue) {
        case .details:
            let destination = segue.destination as! RunDetailsVC
            destination.run = results[path]
        }
    }
}


