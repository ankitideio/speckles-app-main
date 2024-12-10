//
//  SubmitAttendeesViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

/*
 !!!!! Not used, can be removed, storyboards should be cleaned also !!!!!!!!!!
 */

import UIKit

class SubmitAttendeesViewController: UIViewController {
    
    var currentProgram: Program!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        navigationItem.title = "Submit Attendees"

    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "LoadTableView" {
            let destination = segue.topLevelDestinationViewController() as? SubmitAttendeesTableViewController
            destination?.currentProgram = currentProgram
        }
    }

}
