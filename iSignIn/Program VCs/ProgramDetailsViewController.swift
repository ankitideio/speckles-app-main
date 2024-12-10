//
//  ProgramDetailsViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2022-12-26.
//

import UIKit

class ProgramDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableViewProgram: UITableView!

    
    var currentProgram: Program!
    
    private let _dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
        let buttonClose = UIBarButtonItem(image: UIImage(named: "BackButtonImage")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(buttonCloseAction(_:)))
        navigationItem.leftBarButtonItem = buttonClose
        
        _dateFormatter.dateStyle = .long

    }
    

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if segue.identifier == "OpenAttendees" {
            let destination = segue.topLevelDestinationViewController() as? AttendeeListViewController
            destination?.currentProgram = currentProgram
        }
    }
    
    
    //MARK: - Methods
    
    
    //MARK: - Actions
    
    @IBAction func buttonCloseAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func buttonContinueAction(_ sender: Any) {
        performSegue(withIdentifier: "OpenAttendees", sender: self)
    }
    
    //MARK: - UITableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let baseCell = tableView.dequeueReusableCell(withIdentifier: "detailsCell", for: indexPath)
        guard let cell = baseCell as? ProgramDetailsTableViewCell else {
            return baseCell
        }
        let detailsView = cell.viewProgramDetails
        cell.viewProgramDetails.labelProgramId.text = "\(currentProgram.programId)"
        if let date = currentProgram.startDate {
            detailsView?.labelProgramDate.text = _dateFormatter.string(from: date)
        }
        else {
            detailsView?.labelProgramDate.text = "--"
        }
        detailsView?.labelBrand.text = currentProgram.brand
        detailsView?.labelRep.text = currentProgram.repName
        detailsView?.labelProgramType.text = currentProgram.programType
        detailsView?.labelSpeaker.text = currentProgram.speakerName
        detailsView?.labelVenue.text = currentProgram.venue
        detailsView?.labelVenueAddress.text = currentProgram.getFullAddress()

        var size = detailsView?.viewProgramType.sizeThatFits(CGSize.zero) ?? CGSize(width: 200, height: 100)
        detailsView?.viewProgramType.backgroundColor = .buttonBackgroundGradientColor2(bounds: CGRect(origin: CGPoint.zero, size: size))
        
        detailsView?.viewSpeaker.backgroundColor = .mainNavigationBarColor()
        
        size = detailsView?.labelProgramType.sizeThatFits(CGSize.zero) ?? CGSize(width: 200, height: 100)
        detailsView?.labelProgramType.textColor = .buttonBackgroundGradientColor1(bounds: CGRect(origin: CGPoint.zero, size: size))
        
        size = detailsView?.labelSpeaker.sizeThatFits(CGSize.zero) ?? CGSize(width: 200, height: 100)
        detailsView?.labelSpeaker.textColor = .mainTextGradientColor(bounds: CGRect(origin: CGPoint.zero, size: size))
        
        detailsView?.buttonBack.removeTarget(nil, action: nil, for: .touchUpInside)
        detailsView?.buttonBack.addTarget(self, action: #selector(buttonCloseAction(_:)), for: .touchUpInside)
        
        detailsView?.buttonContinue.removeTarget(nil, action: nil, for: .touchUpInside)
        detailsView?.buttonContinue.addTarget(self, action: #selector(buttonContinueAction(_:)), for: .touchUpInside)
        detailsView?.layoutIfNeeded()
        
        return cell
    }

}

class ProgramDetailsTableViewCell: UITableViewCell {
    @IBOutlet weak var viewProgramDetails: ProgramDetailsView!
}
