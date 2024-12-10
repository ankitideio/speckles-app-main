//
//  ProgramListViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-02-08.
//

import UIKit
import RealmSwift

class ProgramListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var labelTitle1: UILabel!
    @IBOutlet weak var labelTitle2: UILabel!
    @IBOutlet weak var labelTitle3: UILabel!
    @IBOutlet weak var labelLoaderTitle: UILabel!
    @IBOutlet weak var viewSyncPrograms: UIView!
    @IBOutlet weak var viewActivityIndicator: UIView!
    @IBOutlet weak var labelSyncPrograms: UILabel!
    @IBOutlet weak var viewNavigation: UIView!
    @IBOutlet weak var buttonAccount: UIButton!
    @IBOutlet weak var buttonSubmitAttendees: UIButton!
    @IBOutlet weak var buttonSync: UIButton!
    
    @IBOutlet weak var collectionViewList: UICollectionView!
    
    private var _syncInProgress = false
    private var _selectedProgram: Program?
    
    private var _realmToken: NotificationToken?
    private var _programs: Results<Program>?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        
        labelTitle1.text = "Horizon Therapeutics"
        labelTitle2.text = " - "
        labelTitle3.text = "Programs"
        let size = labelTitle3.sizeThatFits(CGSize.zero)
        labelTitle3.textColor = .mainTextGradientColor(bounds: CGRect(origin: CGPoint.zero, size: size))
        
        labelSyncPrograms.text = "Sync Programs"
        viewSyncPrograms.layer.cornerRadius = 4.0
        viewSyncPrograms.backgroundColor = .buttonBackgroundGradientColor1(bounds: viewSyncPrograms.bounds)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
        viewNavigation.backgroundColor = .mainNavigationBarColor()
        view.backgroundColor = .mainNavigationBarColor()
        
        buttonSync.setTitle("", for: .normal)
        buttonAccount.setTitle("", for: .normal)
        buttonSubmitAttendees.setTitle("", for: .normal)
        
        viewActivityIndicator.isHidden = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionViewList.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        else {
            collectionViewList.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        collectionViewList.collectionViewLayout = ISCollectionViewFlowLayout(cellHeight: 258.0)
        
        let startofToday = Calendar.current.startOfDay(for: Date()) as NSDate
        _programs = RealmManager.shared.getMainRealm()?.objects(Program.self).filter("startDate >= %@", startofToday).sorted(byKeyPath: "startDate", ascending: true)
        //_programs = RealmManager.shared.getMainRealm()?.objects(Program.self)
        _realmToken = _programs?.observe { [weak self] changes in
            guard let strongSlf = self else {
                return
            }
            strongSlf.collectionViewList.reloadData()
        }
        
        
        
    }
    
    
    deinit {
        _realmToken?.invalidate()
        _realmToken = nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OpenDetails" {
            let destination = segue.topLevelDestinationViewController() as? ProgramDetailsViewController
            destination?.currentProgram = _selectedProgram
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "OpenDetails" {
            if let _ = _selectedProgram {
                return true
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    //MARK: -  Actions
    
    @IBAction func submitAttendeesAction () {
        
        guard !_syncInProgress else {
            return
        }
        
        let attendees = RealmManager.shared.getAttendeesToSubmit(program: nil)
        
        if attendees.count > 0 {
            labelLoaderTitle.text = "Uploading Attendees"
            viewActivityIndicator.isHidden = false
            navigationController?.view.isUserInteractionEnabled = false
            _syncInProgress = true
            collectionViewList.reloadData()
            
//            APIManager.shared.uploadAttendees(program: nil, signatureImage: nil) { [weak self] result in
//                guard let strongSlf = self else {
//                    return
//                }
//                
//                switch result {
//                case .failure(let error):
//                    let alert = UIAlertController(title: "Error", message: "Cannot submit attendees. Error: \(error.localizedDescription)", preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//                    alert.preferredAction = alert.actions.last
//                    strongSlf.present(alert, animated: true)
//                case .success(let count):
//                    var message = "\(count) attendees were successfully submitted."
//                    if count == 1 {
//                        message = "\(count) attendee was successfully submitted."
//                    }
//                    let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
//                    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                        strongSlf.navigationController?.dismiss(animated: true)
//                    }))
//                    alert.preferredAction = alert.actions.last
//                    strongSlf.present(alert, animated: true)
//                }
//                strongSlf._syncInProgress = false
//                strongSlf.viewActivityIndicator.isHidden = true
//                strongSlf.collectionViewList.reloadData()
//                strongSlf.navigationController?.view.isUserInteractionEnabled = true
//            }
        }
        else {
            let alert = UIAlertController(title: "Info", message: "Cannot submit attendees. There are no attendees to submit.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.preferredAction = alert.actions.last
            present(alert, animated: true)
        }
    }
    
    @IBAction func syncProgramsAction () {
        guard !_syncInProgress else {
            return
        }
        
        _syncInProgress = true
        collectionViewList.reloadData()
        viewActivityIndicator.isHidden = false
        labelLoaderTitle.text = "Syncing Programs"
        
        APIManager.shared.syncPrograms { [weak self] result in
            guard let strongSlf = self else {
                return
            }
            switch result {
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                alert.preferredAction = alert.actions.last
                strongSlf.present(alert, animated: true)
            default:
                break
            }
            strongSlf._syncInProgress = false
            strongSlf.collectionViewList.reloadData()
            strongSlf.viewActivityIndicator.isHidden = true
        }
    }
    
    @IBAction func openAccountAction () {
        performSegue(withIdentifier: "OpenSettings", sender: self)
    }
    
    @objc private func _openProgramAction (_ sender: UIButton) {
        
        guard let indexPath = collectionViewList.indexPathForItem(at: collectionViewList.convert(sender.bounds.origin, from: sender)) else {
            return
        }
        
        _selectedProgram = _programs?[indexPath.row]
        performSegue(withIdentifier: "OpenDetails", sender: self)
        
        
    }
    
    //MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return 5
        return _syncInProgress ? 0 : _programs?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let baseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = baseCell as? ProgramListCollectionViewCell else {
            return baseCell
        }
        let program = _programs?[indexPath.row]
        if let programId = program?.programId {
            cell.programCard.labelProgramId.text = "\(programId)"
        }
        else {
            cell.programCard.labelProgramId.text = "--"
        }
        cell.programCard.labelSpeaker.text = program?.speakerName ?? ""
        cell.programCard.labelRepValue.text = program?.repName ?? ""
        cell.programCard.labelBrandValue.text = program?.brand ?? ""
        cell.programCard.labelVenueValue.text = program?.venue ?? ""
        
        cell.programCard.buttonOpenProgram.removeTarget(nil, action: nil, for: .allEvents)
        cell.programCard.buttonOpenProgram.addTarget(self, action: #selector(_openProgramAction(_:)), for: .touchUpInside)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        _selectedProgram = _programs?[indexPath.row]
        performSegue(withIdentifier: "OpenDetails", sender: self)
    }
    

}


class ProgramListCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var programCard: ProgramCardView!
    
    override func systemLayoutSizeFitting(_ targetSize: CGSize, withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority, verticalFittingPriority: UILayoutPriority) -> CGSize {
        
        var targetSize = targetSize
        targetSize.height = CGFloat.greatestFiniteMagnitude
        
        let size = super.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
        
        return size
    }
}
