//
//  GlobalAnalyticsVC.swift
//  EventManagement
//
//  Created by meet sharma on 10/07/23.
//

import UIKit
import Charts
import RealmSwift


class GlobalAnalyticsVC: UIViewController {
    
    //MARK: - OUTLETS
    
    @IBOutlet private weak var vwBarChartsRegistration: BarChartView!
    @IBOutlet private weak var vwBarChartPrograms: BarChartView!
    @IBOutlet private weak var viewActivityIndicator: UIActivityIndicatorView!
    
    //MARK: - VARIABLES
    var currentYear = ""
    let arrMonths = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    var arrMyPrograms = [Int]()
    var arrAvgPrograms = [Float]()
    var arrTopPrograms = [Int]()
    var arrMyRegistration = [Int]()
    var arrAvgRegistration = [Float]()
    var arrTopRegistration = [Int]()
    var selectedIndex = 0
    
    private var _notificationtoken: NotificationToken?
    private var _notificationtokenProgram: NotificationToken?
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let date = DateFormatter()
        date.dateFormat = "yyyy"
        currentYear = date.string(from: Date())
        programAnalyticalData()
        registrationAnalyticsData()
   
}
    deinit {
        _notificationtoken?.invalidate()
        _notificationtoken = nil
        _notificationtokenProgram?.invalidate()
        _notificationtokenProgram = nil
    }
    
    
    private func programAnalyticalData(){
        viewActivityIndicator.isHidden = true
        if let realm = RealmManager.shared.getMainRealm() {
            let objects = realm.objects(GlobalProgramAnalytics.self)
            _notificationtokenProgram = objects.observe { [weak self] changes in
                guard let strongSlf = self else {
                    return
                }
                for item in objects {
                    strongSlf.arrMyPrograms.append(item.my)
                    strongSlf.arrAvgPrograms.append(Float(item.average) ?? 0.0)
                    strongSlf.arrTopPrograms.append(item.top)
                    
                }
                if strongSlf.arrMyPrograms.count > 0 || strongSlf.arrAvgPrograms.count > 0 || strongSlf.arrTopPrograms.count > 0{
                    strongSlf.setProgramsData(dataPoints: strongSlf.arrMonths, valuesA: strongSlf.arrMyPrograms, valuesB: strongSlf.arrAvgPrograms, valuesC: strongSlf.arrTopPrograms)
                }
                
            }
     
           }
        }
    
    private func registrationAnalyticsData(){
        viewActivityIndicator.isHidden = true
        if let realm = RealmManager.shared.getMainRealm() {
            let objects = realm.objects(GlobalRegistrationAnalytics.self)
            _notificationtoken = objects.observe { [weak self] changes in
                guard let strongSlf = self else {
                    return
                }
                for item in objects {
                    strongSlf.arrMyRegistration.append(item.my)
                    strongSlf.arrAvgRegistration.append(Float(item.average) ?? 0.0)
                    strongSlf.arrTopRegistration.append(item.top)
                    
                }
                if strongSlf.arrMyRegistration.count > 0 || strongSlf.arrAvgRegistration.count > 0 || strongSlf.arrTopRegistration.count > 0{
                    strongSlf.setRegistrationData(dataPoints: strongSlf.arrMonths, valuesA: strongSlf.arrMyRegistration, valuesB: strongSlf.arrAvgRegistration, valuesC: strongSlf.arrTopRegistration)
                }
            }
            
            
           }
        }
    
func setProgramsData(dataPoints: [String], valuesA: [Int], valuesB: [Float], valuesC: [Int]) {
    var dataEntriesA: [BarChartDataEntry] = []
    var dataEntriesB: [BarChartDataEntry] = []
    var dataEntriesC: [BarChartDataEntry] = []

    for i in 0..<dataPoints.count {
        let dataEntryA = BarChartDataEntry(x: Double(i), y: Double(valuesA[i]))
        dataEntriesA.append(dataEntryA)

        let dataEntryB = BarChartDataEntry(x: Double(i), y: Double(valuesB[i]))
        dataEntriesB.append(dataEntryB)

        let dataEntryC = BarChartDataEntry(x: Double(i), y: Double(valuesC[i]))
        dataEntriesC.append(dataEntryC)
    }

    let chartDataSetA = BarChartDataSet(entries: dataEntriesA, label: "")
    chartDataSetA.colors = [UIColor.init(red: 13.0/255.0, green: 27.0/255.0, blue: 62/255.0, alpha: 1.0)]

    let chartDataSetB = BarChartDataSet(entries: dataEntriesB, label: "")
    chartDataSetB.colors = [UIColor.init(red: 243.0/255.0, green: 118.0/255.0, blue: 43/255.0, alpha: 1.0)]

    let chartDataSetC = BarChartDataSet(entries: dataEntriesC, label: "")
    chartDataSetC.colors = [UIColor.init(red: 93.0/255.0, green: 168.0/255.0, blue: 221/255.0, alpha: 1.0)]

    var chartData = BarChartData(dataSets: [chartDataSetA, chartDataSetB, chartDataSetC])
    
    
    let xAxis = vwBarChartPrograms.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelCount = dataPoints.count
    

    let rightYAxis = vwBarChartPrograms.rightAxis
        rightYAxis.enabled = false

    let cxAxis = vwBarChartPrograms.xAxis
        cxAxis.drawGridLinesEnabled = false

    let leftYAxis = vwBarChartPrograms.leftAxis
        leftYAxis.drawGridLinesEnabled = false
    leftYAxis.axisMinimum = 0.0
    
    let barWidth = 0.15
    let groupSpace: CGFloat = 0.34
    let barSpace: CGFloat = 0.07
    
    chartData.barWidth = barWidth

    let groupCount = dataPoints.count
    let groupBarWidth = (barWidth + barSpace)
    let groupCenterOffset = (groupBarWidth * Double(groupCount)) / 6

    chartData.groupBars(fromX: -groupCenterOffset, groupSpace: groupSpace, barSpace: barSpace)
    
    chartDataSetA.drawValuesEnabled = false
    chartDataSetB.drawValuesEnabled = false
    chartDataSetC.drawValuesEnabled = false
    vwBarChartPrograms.legend.enabled = false
    vwBarChartPrograms.data = chartData
}

func setRegistrationData(dataPoints: [String], valuesA: [Int], valuesB: [Float], valuesC: [Int]) {
    var dataEntriesA: [BarChartDataEntry] = []
    var dataEntriesB: [BarChartDataEntry] = []
    var dataEntriesC: [BarChartDataEntry] = []

    for i in 0..<dataPoints.count {
        let dataEntryA = BarChartDataEntry(x: Double(i), y: Double(valuesA[i]))
        dataEntriesA.append(dataEntryA)

        let dataEntryB = BarChartDataEntry(x: Double(i), y: Double(valuesB[i]))
        dataEntriesB.append(dataEntryB)

        let dataEntryC = BarChartDataEntry(x: Double(i), y: Double(valuesC[i]))
        dataEntriesC.append(dataEntryC)
    }

    let chartDataSetA = BarChartDataSet(entries: dataEntriesA, label: "")
    chartDataSetA.colors = [UIColor.init(red: 13.0/255.0, green: 27.0/255.0, blue: 62/255.0, alpha: 1.0)]

    let chartDataSetB = BarChartDataSet(entries: dataEntriesB, label: "")
    chartDataSetB.colors = [UIColor.init(red: 243.0/255.0, green: 118.0/255.0, blue: 43/255.0, alpha: 1.0)]

    let chartDataSetC = BarChartDataSet(entries: dataEntriesC, label: "")
    chartDataSetC.colors = [UIColor.init(red: 93.0/255.0, green: 168.0/255.0, blue: 221/255.0, alpha: 1.0)]

    var chartData = BarChartData(dataSets: [chartDataSetA, chartDataSetB, chartDataSetC])
    
    
    let xAxis = vwBarChartsRegistration.xAxis
        xAxis.drawGridLinesEnabled = false
        xAxis.valueFormatter = IndexAxisValueFormatter(values: dataPoints)
        xAxis.labelPosition = .bottom
        xAxis.granularity = 1.0
        xAxis.granularityEnabled = true
        xAxis.labelCount = dataPoints.count
    

    let rightYAxis = vwBarChartsRegistration.rightAxis
        rightYAxis.enabled = false

    let cxAxis = vwBarChartsRegistration.xAxis
        cxAxis.drawGridLinesEnabled = false

    let leftYAxis = vwBarChartsRegistration.leftAxis
        leftYAxis.drawGridLinesEnabled = false
    leftYAxis.axisMinimum = 0.0
    
    let barWidth = 0.15
    let groupSpace: CGFloat = 0.34
    let barSpace: CGFloat = 0.07
    
    chartData.barWidth = barWidth

    let groupCount = dataPoints.count
    let groupBarWidth = (barWidth + barSpace)
    let groupCenterOffset = (groupBarWidth * Double(groupCount)) / 6

    chartData.groupBars(fromX: -groupCenterOffset, groupSpace: groupSpace, barSpace: barSpace)
    
    chartDataSetA.drawValuesEnabled = false
    chartDataSetB.drawValuesEnabled = false
    chartDataSetC.drawValuesEnabled = false
    vwBarChartsRegistration.legend.enabled = false
    vwBarChartsRegistration.data = chartData
}


  

}
