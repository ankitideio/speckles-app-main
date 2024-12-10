//
//  SearchAttendeeViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import UIKit

class SearchAttendeeViewController: UIViewController, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var viewSearchParams: UIView!
    @IBOutlet weak var textFieldFirstName: UITextField!
    @IBOutlet weak var textFieldLastName: UITextField!
    @IBOutlet weak var textFieldNPI: UITextField!
    @IBOutlet weak var textFieldCity: UITextField!
    @IBOutlet weak var textFieldState: UITextField!
    
    @IBOutlet weak var buttonState: UIButton!
    @IBOutlet weak var buttonSearch: UIButton!
    @IBOutlet weak var buttonCancel: UIButton!
    
    @IBOutlet weak var viewButtonSearch: UIView!
    @IBOutlet weak var viewButtonCancel: UIView!
    
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var labelCancel: UILabel!
    
    
    var currentProgram: Program!
    
    private var _selectedState = ""
    
    private var _searchResults = [Attendee]()
    private var _searchRunning = false
    
    private var _selectedAttendee: Attendee?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        }
        else {
            collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        }

        collectionView.collectionViewLayout = ISCollectionViewFlowLayout(cellHeight: 258.0)
        
        for tf in [viewSearchParams, textFieldFirstName, textFieldLastName, textFieldNPI, textFieldCity, textFieldState] {
            if let tf = tf {
                tf.layer.borderColor = UIColor.textFieldBorderDefaultColor().cgColor
                tf.layer.borderWidth = 1.0
                tf.layer.cornerRadius = 4.0
            }
        }
        
        navigationItem.title = "Search Attendee"
        
        let buttonBack = UIBarButtonItem(image: UIImage(named: "BackButtonImage")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(buttonBackAction(_:)))
        navigationItem.leftBarButtonItem = buttonBack
        
        labelCancel.textColor = .textColorRed()
        
        let stateList =  RealmManager.shared.getStateList()
        
        var menuItems = [UIAction]()
        
        let clearItem = UIAction(title: "Deselect") { [weak self] action in
            guard let strongSlf = self else {
                return
            }
            strongSlf.textFieldState.text = nil
            strongSlf._selectedState = ""
        }
        menuItems.append(clearItem)
        
        for state in stateList {
            let menuItem = UIAction(title: state) { [weak self] (action) in
                guard let strongSlf = self else {
                    return
                }
                strongSlf.textFieldState.text = state
                strongSlf._selectedState = state
            }
            menuItems.append(menuItem)
        }
        
        let menu = UIMenu(title: "States", options: .displayInline, children: menuItems)
        buttonState.menu = menu
        buttonState.showsMenuAsPrimaryAction = true
        
        buttonState.setTitle("", for: .normal)
        buttonCancel.setTitle("", for: .normal)
        buttonSearch.setTitle("", for: .normal)
        
        viewButtonSearch.backgroundColor = .buttonBackgroundGradientColor1(bounds: viewButtonSearch.bounds)
        viewButtonSearch.layer.cornerRadius = 4.0
        
        labelInfo.textColor = .mainTextGradientColor(bounds: CGRect(origin: CGPoint.zero, size: labelInfo.sizeThatFits(CGSize.zero)))
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    //MARK: - Actions
    
    @IBAction func cancelAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func searchAction(_ sender: Any) {
        
        view.endEditing(true)
        
        _selectedAttendee = nil
        
        _searchRunning = true
        activity.startAnimating()
        _searchResults.removeAll()
        buttonSearch.isUserInteractionEnabled = false
        collectionView.reloadData()
        
        APIManager.shared.searchAttendees(firstName: textFieldFirstName.text, lastName: textFieldLastName.text, npi: textFieldNPI.text, city: textFieldCity.text, state: _selectedState) { [weak self] result in
            
            guard let strongSlf = self else {
                return
            }
            
            strongSlf._searchResults.removeAll()
            
            switch result {
            case .failure(let error):
                let alert = UIAlertController(title: "Error", message: "\(error.localizedDescription)", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
                alert.preferredAction = alert.actions.last
                strongSlf.present(alert, animated: true)
            case .success(let attendees):
                strongSlf._searchResults.append(contentsOf: attendees)
            }
            
            strongSlf.buttonSearch.isUserInteractionEnabled = true
            strongSlf._searchRunning = false
            strongSlf.activity.stopAnimating()
            strongSlf.collectionView.reloadData()
        }
    }
    
    @objc func buttonBackAction(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Methods
    
    private func _signInSelectedAttendee () {
        
        guard let attendee = _selectedAttendee else {
            return
        }
        
        guard let realm = RealmManager.shared.getMainRealm() else {
            return
        }
        
        
        try? realm.write {
            attendee.manuallyAdded = true
            currentProgram.attendees.append(attendee)
            realm.add(attendee)
        }
        
        guard let signInViewController = storyboard?.instantiateViewController(withIdentifier: "signature") as? AttendeeSigninViewController, var viewControllers = navigationController?.viewControllers else {
            navigationController?.popViewController(animated: true)
            return
        }
        
        signInViewController.currentAttendee = attendee
        signInViewController.currentProgram = currentProgram
        viewControllers.removeLast()
        viewControllers.append(signInViewController)
        navigationController?.setViewControllers(viewControllers, animated: true)
        
    }
    
    
    //MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    //MARK: - UICollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return _searchResults.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let baseCell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        guard let cell = baseCell as? AttendeeSearchCollectionCell else {
            return baseCell
        }
        let attendee = _searchResults[indexPath.row]
        
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
        cell.attendeeCard.labelDegree.text = degree
        
        var cityState = attendee.city
        let state = attendee.stateProvince
        if !cityState.isEmpty && !state.isEmpty {
            cityState += ", " + state
        }
        else if !state.isEmpty {
            cityState += state
        }
        cell.attendeeCard.labelCityState.text = cityState
        
        cell.attendeeCard.labelNPI.text = attendee.npi
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: true)

        guard !_searchRunning else {
            return
        }

        guard indexPath.row < _searchResults.count else {
            return
        }

        _selectedAttendee = _searchResults[indexPath.row]

        let alert = UIAlertController(title: "Info", message: "Are you sure you want to sign in \(_selectedAttendee?.firstName ?? "") \(_selectedAttendee?.lastName ?? "")?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { [weak self] _ in
            guard let strongSlf = self else {
                return
            }
            strongSlf._signInSelectedAttendee()
        }))
        alert.preferredAction = alert.actions.last
        present(alert, animated: true)
    }
    

}

class AttendeeSearchCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var attendeeCard: AttendeeSearchCardView!
    
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

