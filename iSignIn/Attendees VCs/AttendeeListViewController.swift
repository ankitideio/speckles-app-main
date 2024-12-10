//
//  AtendeeListViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import UIKit
import RealmSwift

class AttendeeListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource{
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewSearchBox: UIView!
    @IBOutlet weak var viewAddNewBox: UIView!
    @IBOutlet weak var buttonSubmitAttendees: UIButton!
    @IBOutlet weak var buttonAddNew: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var labelLoaderTitle: UILabel!
    @IBOutlet weak var viewActivityIndicator: UIView!
    
    
    var currentProgram: Program!
    private var _attendeeList: Results<Attendee>!
    
    private var _selectedAttendee: Attendee?
    
    private var _notificationtoken: NotificationToken?
    
    private var _syncInProgress = false

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        viewActivityIndicator.isHidden = true
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        else {
            collectionView.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 0, right: 0)
        }
        
        collectionView.collectionViewLayout = ISCollectionViewFlowLayout(cellHeight: 258.0)
        
        viewSearchBox.layer.cornerRadius = 4.0
        viewSearchBox.layer.borderColor = UIColor.secondaryLabel.cgColor
        viewSearchBox.layer.borderWidth = 1.0
        
        viewAddNewBox.layer.cornerRadius = 4.0
        viewAddNewBox.layer.borderColor = UIColor.secondaryLabel.cgColor
        viewAddNewBox.layer.borderWidth = 1.0
        
        buttonSubmitAttendees.layer.cornerRadius = 4.0
        buttonSubmitAttendees.backgroundColor = UIColor.buttonBackgroundGradientColor1(bounds: buttonSubmitAttendees.bounds)
        buttonSubmitAttendees.setAttributedTitle(NSAttributedString(string: "Submit Attendees", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 13.0, weight: .semibold), NSAttributedString.Key.foregroundColor : UIColor.white]), for: .normal)
        
        buttonAddNew.setTitle("", for: .normal)
        buttonSearch.setTitle("", for: .normal)
        
        
        let buttonBack = UIBarButtonItem(image: UIImage(named: "BackButtonImage")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(buttonBackAction(_:)))
        navigationItem.leftBarButtonItem = buttonBack
        
        _attendeeList = currentProgram.attendees.sorted(by: [SortDescriptor(keyPath: "submitSubmited", ascending: true), SortDescriptor(keyPath: "submitStatus", ascending: true), SortDescriptor(keyPath: "firstName", ascending: true), SortDescriptor(keyPath: "lastName", ascending: true)])
        
        _notificationtoken = _attendeeList.observe { [weak self] changes in
            guard let strongSlf = self else {
                return
            }
            strongSlf.collectionView.reloadData()
        }
        
    }
    
    
    
    deinit {
        _notificationtoken?.invalidate()
        _notificationtoken = nil
    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OpenAttendeeSignin" {
            let destination = segue.topLevelDestinationViewController() as? AttendeeSigninViewController
            destination?.currentAttendee = _selectedAttendee
            destination?.currentProgram = currentProgram
        }
        else if segue.identifier == "OpenAddNewAttendee" {
            let destination = segue.topLevelDestinationViewController() as? EditAttendeeViewController
            destination?.currentAttendee = Attendee()
            destination?.currentAttendee.manuallyAdded = true
            destination?.currentProgram = currentProgram
        }
        else if segue.identifier == "OpenSearchAttendee" {
            let destination = segue.topLevelDestinationViewController() as? SearchAttendeeViewController
            destination?.currentProgram = currentProgram
        }
    }
    
    
    //MARK: - Methods
    
    
    @IBAction @objc func didTapSubmitAttendeeButton(sender: AnyObject) {
        
        guard !_syncInProgress else {
            return
        }
        
        if currentProgram.isReadyToSubmit() {
            labelLoaderTitle.text = "Uploading Attendees"
            viewActivityIndicator.isHidden = false
            navigationController?.view.isUserInteractionEnabled = false
            _syncInProgress = true
            collectionView.reloadData()
            
//            APIManager.shared.uploadAttendees(program: currentProgram, signatureImage: nil) { [weak self] result in
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
//                
//                strongSlf.viewActivityIndicator.isHidden = true
//                strongSlf.navigationController?.view.isUserInteractionEnabled = true
//                strongSlf._syncInProgress = false
//                strongSlf.collectionView.reloadData()
//            }
        }
        else {
            let alert = UIAlertController(title: "Info", message: "Cannot submit attendees. There are no attendees to submit in the selected program.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.preferredAction = alert.actions.last
            present(alert, animated: true)
        }
        
    }
    
    
    @IBAction @objc func didTapAddNewButton(sender: AnyObject){
        performSegue(withIdentifier: "OpenAddNewAttendee", sender: self)
    }
    
    
    @IBAction @objc func didTapSearchButton(sender: AnyObject){
        performSegue(withIdentifier: "OpenSearchAttendee", sender: self)
    }
    
    //MARK: - Actions
    
    @objc func buttonBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc private func _buttonOpenAttendeeAction(_ sender: UIButton) {
        guard let indexPath = collectionView.indexPathForItem(at: collectionView.convert(sender.bounds.origin, from: sender)) else {
            return
        }
        
        if _attendeeList[indexPath.row].submitStatus == .notReady {
            _selectedAttendee = _attendeeList[indexPath.row]
            performSegue(withIdentifier: "OpenAttendeeSignin", sender: self)
        }
        
    }
    
    //MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _syncInProgress ? 0 : _attendeeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let baseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = baseCell as? AttendeeListCollectionCell else {
            return baseCell
        }

        let attendee = _attendeeList[indexPath.row]
        
        var nameString = attendee.firstName
        let middleName = attendee.middleName.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let middleInitials = attendee.middleInitials.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !middleName.isEmpty {
            nameString += " " + middleName
        }
        else if !middleInitials.isEmpty {
            nameString += " " + middleInitials
        }
        nameString += " " + attendee.lastName
        
        cell.attendeeCard.labelName.text = nameString
        
        let degree = attendee.degree.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if !degree.isEmpty {
            cell.attendeeCard.labelDegree.text = degree
        }
        else {
            cell.attendeeCard.labelDegree.text = ""
        }
        
        cell.attendeeCard.labelAddress.text = attendee.address
        var cityState = attendee.city
        let state = attendee.stateProvince
        if !cityState.isEmpty && !state.isEmpty {
            cityState += ", " + state
        }
        else if !state.isEmpty {
            cityState += state
        }
        cell.attendeeCard.labelCityState.text = cityState
        
        if let imageColor = attendee.getSubmitStatusImage() {
            cell.attendeeCard.imageViewStatus.tintColor = imageColor.color
            cell.attendeeCard.imageViewStatus.image = imageColor.image
        }
        else {
            cell.attendeeCard.imageViewStatus.image = nil
        }
        cell.attendeeCard.viewButtonBox.isHidden = attendee.submitStatus != .notReady
        
        cell.attendeeCard.buttonOpenAttendee.removeTarget(nil, action: nil, for: .allEvents)
        cell.attendeeCard.buttonOpenAttendee.addTarget(self, action: #selector(_buttonOpenAttendeeAction(_:)), for: .touchUpInside)
        
        return cell
    }

}



class AttendeeListCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var attendeeCard: AttendeeCardView!
    
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



extension Attendee {
    
    func getSubmitStatusImage () -> (image: UIImage?, color: UIColor)? {
        if submitSubmited {
            return (image: UIImage(systemName: "checkmark.icloud")?.withRenderingMode(.alwaysTemplate), color: UIColor.label)
        }
        
        switch submitStatus {
        case .readySigned:
            return (image: UIImage(systemName: "checkmark.circle")?.withRenderingMode(.alwaysTemplate), color: UIColor.systemGreen)
        case .readyNoShow:
            return (image: UIImage(systemName: "xmark.circle")?.withRenderingMode(.alwaysTemplate), color: UIColor.systemRed)
        default:
            return nil
        }
    }
}
