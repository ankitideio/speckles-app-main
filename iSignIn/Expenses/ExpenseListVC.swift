//
//  ExpenseListVC.swift
//  iSignIn
//
//  Created by Apple on 25/07/23.
//

import UIKit
import RealmSwift

class ExpenseListVC: UIViewController {
   
    //MARK: - OUTLETS
    
    @IBOutlet weak var tblVwList: UITableView!
    
    //MARK: - VARIABLES
    
    var arrExpenses:Results<Costs>?
    var currentProgram: Program!
    private var _notificationtoken: NotificationToken?
    var cost:Costs?
    var arrData = [Costs]()
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrExpenses = currentProgram.costs.sorted(by: [SortDescriptor(keyPath: "costId", ascending: false)])
        _notificationtoken = arrExpenses?.observe { [weak self] changes in
              guard let strongSlf = self else {
                return
              }
            strongSlf.tblVwList.reloadData()
            
            }
        
    }

    deinit {
        _notificationtoken?.invalidate()
        _notificationtoken = nil
    }
    
    //MARK: - ACTIONS
    
    @IBAction func actionBack(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionAddExpense(_ sender: UIButton) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "AddExpensesVC") as! AddExpensesVC
        vc.programId = currentProgram?.programId ?? 0
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension ExpenseListVC: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrExpenses?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ExpenseListTVC", for: indexPath) as! ExpenseListTVC
        cell.lblCostItem.text = arrExpenses?[indexPath.row].label
        cell.lblAmount.text = "$\(arrExpenses?[indexPath.row].estimate ?? "")"
        
        return cell
    }
    
    
}
