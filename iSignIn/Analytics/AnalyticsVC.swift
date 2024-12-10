//
//  AnalyticsVC.swift
//  EventManagement
//
//  Created by meet sharma on 04/07/23.
//

import UIKit

class AnalyticsVC: UIViewController {
    
   //MARK: - OUTLETS
    
    @IBOutlet private weak var scrollVw: UIScrollView!
    @IBOutlet private weak var segmentControl: UISegmentedControl!
    
    //MARK: - LIFE CYCLE METHOD
    
    override func viewDidLoad() {
        super.viewDidLoad()

       uiData()
       
    }
    
    //MARK: - FUNTIONS
    
    private func uiData(){
        
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

    @objc private func selectTab(sender:UISegmentedControl){
        
        if sender.selectedSegmentIndex == 0{
            scrollVw.setContentOffset(.zero, animated: true)
            scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*0, y: 0), animated: true)
        }else{
            scrollVw.setContentOffset(.zero, animated: true)
            scrollVw.setContentOffset(CGPoint(x: scrollVw.frame.size.width*1, y: 0), animated: true)
//            NotificationCenter.default.post(name: Notification.Name("GlobalAnalytics"), object: nil)
        }
      
    }

}
