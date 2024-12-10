//
//  MyAnalyticsVC.swift
//  EventManagement
//
//  Created by meet sharma on 10/07/23.
//

import UIKit
import Charts
import RealmSwift

class MyAnalyticsVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var lblExpenses: UILabel!
    @IBOutlet private weak var lblRegistration: UILabel!
    @IBOutlet private weak var lblPrograms: UILabel!
    @IBOutlet private weak var viewActivityIndicator: UIActivityIndicatorView!
    @IBOutlet private weak var vwBarChart: BarChartView!
    @IBOutlet private weak var imgVwGraph: UIImageView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    //MARK: - VARIABLES
    
    let arrMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var arrPrograms = [Int]()
    var arrRgistration = [Int]()
    var arrPExpenses = [Int]()
    var selectedIndex = 0
    var program = 0
    var registration = 0
    var expenses = 0
    var currentYear = ""
    private var _notificationtoken: NotificationToken?
    private var _notificationtokenProgram: NotificationToken?
    private var _notificationtokenRegistration: NotificationToken?
    private var _notificationtokenExpenses: NotificationToken?
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      imgVwGraph.isHidden = true
    
      uiData()
        
    }
    
    deinit {
        _notificationtoken?.invalidate()
        _notificationtoken = nil
        _notificationtokenProgram?.invalidate()
        _notificationtokenProgram = nil
        _notificationtokenRegistration?.invalidate()
        _notificationtokenRegistration = nil
        _notificationtokenExpenses?.invalidate()
        _notificationtokenExpenses = nil
    }
    
    //MARK: - FUNTIONS
    
   private func uiData(){
       
       if let realm = RealmManager.shared.getMainRealm() {
           let objects = realm.objects(ProgramRegistrationExpenses.self)
           _notificationtoken = objects.observe { [weak self] changes in
               guard let strongSlf = self else {
                   return
               }
               for item in objects {
                   strongSlf.lblPrograms.text = "\(item.programs)"
                   strongSlf.lblRegistration.text = "\(item.registrations)"
                   strongSlf.lblExpenses.text = "$\(item.expenses)"
               }
           }
         
       }
       self.programAnalyticslData(type: "Program")
        self.segmentControl.layer.cornerRadius = 8
        self.segmentControl.selectedSegmentIndex = 0
        self.segmentControl.selectedSegmentTintColor = UIColor(red: 243/255, green: 118/255, blue: 43/255, alpha: 1.0)
        self.segmentControl.layer.backgroundColor = UIColor(red: 249/255, green: 251/255, blue: 255/255, alpha: 1.0).cgColor
        let selectSegmentColor = [NSAttributedString.Key.font:UIFont(name: "Lato-Bold", size: 14),NSAttributedString.Key.foregroundColor: UIColor.white]
        let unSelectSegmentColor = [NSAttributedString.Key.font:UIFont(name: "Lato-Bold", size: 14),NSAttributedString.Key.foregroundColor: UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)]
        segmentControl.setTitleTextAttributes(unSelectSegmentColor as [NSAttributedString.Key : Any], for: .normal)
        segmentControl.setTitleTextAttributes(selectSegmentColor as [NSAttributedString.Key : Any], for: .selected)
        segmentControl.addTarget(self, action: #selector(selectTab), for: .valueChanged)
        
        }
    
    func setChartData(dataPoints: [String], values: [Int]) {
        var dataEntries: [BarChartDataEntry] = []

        for i in 0..<dataPoints.count {
            let dataEntry = BarChartDataEntry(x: Double(i), y: Double(values[i]))
            dataEntries.append(dataEntry)
        }

        let chartDataSet = BarChartDataSet(entries: dataEntries, label: "")
        
        let chartData = BarChartData(dataSet: chartDataSet)
        let barWidth = 0.5
            chartData.barWidth = barWidth
        let xAxis = vwBarChart.xAxis
            xAxis.drawGridLinesEnabled = false
            xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
            xAxis.labelPosition = .bottom
            xAxis.granularity = 1.0
            xAxis.granularityEnabled = true
            xAxis.labelCount = dataPoints.count
        

        let rightYAxis = vwBarChart.rightAxis
            rightYAxis.enabled = false

        let cxAxis = vwBarChart.xAxis
            cxAxis.drawGridLinesEnabled = false

        let leftYAxis = vwBarChart.leftAxis
            leftYAxis.drawGridLinesEnabled = false
        leftYAxis.axisMinimum = 0.0

        chartDataSet.drawValuesEnabled = false
        
        if selectedIndex == 0{
            chartDataSet.colors = [UIColor.init(red: 13.0/255.0, green: 27.0/255.0, blue: 62/255.0, alpha: 1.0)]
        }else if selectedIndex == 1{
            chartDataSet.colors = [UIColor.init(red: 243.0/255.0, green: 118.0/255.0, blue: 43/255.0, alpha: 1.0)]
        }else if selectedIndex == 2{
            chartDataSet.colors = [UIColor.init(red: 93.0/255.0, green: 168.0/255.0, blue: 221/255.0, alpha: 1.0)]
        }
        vwBarChart.legend.enabled = false
        self.vwBarChart.data = chartData
    }
    private func programAnalyticslData(type:String){
            if type == "Program"{
                if let realm = RealmManager.shared.getMainRealm() {
                    let objects = realm.objects(ProgramAnalytics.self)
                    _notificationtokenProgram = objects.observe { [weak self] changes in
                        guard let strongSlf = self else {
                            return
                        }
                        for item in objects {
                            strongSlf.arrPrograms.append(item.January)
                            strongSlf.arrPrograms.append(item.February)
                            strongSlf.arrPrograms.append(item.March)
                            strongSlf.arrPrograms.append(item.April)
                            strongSlf.arrPrograms.append(item.May)
                            strongSlf.arrPrograms.append(item.June)
                            strongSlf.arrPrograms.append(item.July)
                            strongSlf.arrPrograms.append(item.August)
                            strongSlf.arrPrograms.append(item.September)
                            strongSlf.arrPrograms.append(item.October)
                            strongSlf.arrPrograms.append(item.November)
                            strongSlf.arrPrograms.append(item.December)
                        }
                        if strongSlf.arrPrograms.count > 0{
                            strongSlf.setChartData(dataPoints: strongSlf.arrMonths, values: strongSlf.arrPrograms)
                        }
                    }
                  
                }
            }else if type == "Registration"{
                if let realm = RealmManager.shared.getMainRealm() {
                    let objects = realm.objects(RegistrationAnalytics.self)
                    _notificationtokenRegistration = objects.observe { [weak self] changes in
                        guard let strongSlf = self else {
                            return
                        }
                        for item in objects {
                            strongSlf.arrRgistration.append(item.January)
                            strongSlf.arrRgistration.append(item.February)
                            strongSlf.arrRgistration.append(item.March)
                            strongSlf.arrRgistration.append(item.April)
                            strongSlf.arrRgistration.append(item.May)
                            strongSlf.arrRgistration.append(item.June)
                            strongSlf.arrRgistration.append(item.July)
                            strongSlf.arrRgistration.append(item.August)
                            strongSlf.arrRgistration.append(item.September)
                            strongSlf.arrRgistration.append(item.October)
                            strongSlf.arrRgistration.append(item.November)
                            strongSlf.arrRgistration.append(item.December)
                        }
                        if strongSlf.arrRgistration.count > 0{
                            strongSlf.setChartData(dataPoints: strongSlf.arrMonths, values: strongSlf.arrRgistration)
                        }
                    }
                   
                }
            }else{
                if let realm = RealmManager.shared.getMainRealm() {
                    let objects = realm.objects(ExpensesAnalytics.self)
                    _notificationtokenExpenses = objects.observe { [weak self] changes in
                        guard let strongSlf = self else {
                            return
                        }
                        for item in objects {
                            strongSlf.arrPExpenses.append(item.January)
                            strongSlf.arrPExpenses.append(item.February)
                            strongSlf.arrPExpenses.append(item.March)
                            strongSlf.arrPExpenses.append(item.April)
                            strongSlf.arrPExpenses.append(item.May)
                            strongSlf.arrPExpenses.append(item.June)
                            strongSlf.arrPExpenses.append(item.July)
                            strongSlf.arrPExpenses.append(item.August)
                            strongSlf.arrPExpenses.append(item.September)
                            strongSlf.arrPExpenses.append(item.October)
                            strongSlf.arrPExpenses.append(item.November)
                            strongSlf.arrPExpenses.append(item.December)
                        }
                        if strongSlf.arrPExpenses.count > 0{
                            strongSlf.setChartData(dataPoints: strongSlf.arrMonths, values: strongSlf.arrPExpenses)
                        }
                    }
                  
                }
            }
        
    }
    @objc private func selectTab(sender:UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            selectedIndex = 0
            imgVwGraph.image = UIImage(named: "Group 152")
            programAnalyticslData(type: "Program")
        }else if sender.selectedSegmentIndex == 1{
            selectedIndex = 1
            imgVwGraph.image = UIImage(named: "Group 150")
            programAnalyticslData(type: "Registration")
        }else{
            selectedIndex = 2
            imgVwGraph.image = UIImage(named: "Group 153")
            programAnalyticslData(type: "Expenses")
        }
      
    }

}
