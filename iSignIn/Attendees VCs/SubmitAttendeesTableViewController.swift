//
//  SubmitAttendeesTableViewController.swift
//  iSignIn
//
//  Created by Dmitrij on 2023-01-06.
//

/*
 !!!!! Not used, can be removed, storyboards should be cleaned also !!!!!!!!!!
 */

import UIKit
import PencilKit

class SubmitAttendeesTableViewController: UITableViewController, PKCanvasViewDelegate {
    
    var currentProgram: Program!
    
    private var _canvasInUse = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            tableView.isScrollEnabled = false
        }
    }
    
    //MARK: - Actions
    
    @IBAction func cancelAction () {
        navigationController?.dismiss(animated: true)
    }
    
    @IBAction func uploadAction () {
        
        guard let cell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? SubmitAttendeesTableViewCell else {
            return
        }
        
        let image = cell.canvasView.drawing.image(from: cell.canvasView.bounds, scale: 1.0, userInterfaceStyle: .light)
        
        guard !cell.canvasView.drawing.bounds.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Signature is missed. Please sign here before submit attendees.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .cancel))
            alert.preferredAction = alert.actions.last
            present(alert, animated: true)
            return
        }
        
        cell.submitInProgress = true
        navigationController?.view.isUserInteractionEnabled = false
        
//        APIManager.shared.uploadAttendees(program: currentProgram, signatureImage: image) { [weak self] result in
//            guard let strongSlf = self else {
//                return
//            }
//            
//            switch result {
//            case .failure(let error):
//                let alert = UIAlertController(title: "Error", message: "Cannot submit attendees. Error: \(error.localizedDescription)", preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .cancel))
//                alert.preferredAction = alert.actions.last
//                strongSlf.present(alert, animated: true)
//            case .success(let count):
//                var message = "\(count) attendees were successfully submitted."
//                if count == 1 {
//                    message = "\(count) attendee was successfully submitted."
//                }
//                let alert = UIAlertController(title: "Info", message: message, preferredStyle: .alert)
//                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
//                    strongSlf.navigationController?.dismiss(animated: true)
//                }))
//                alert.preferredAction = alert.actions.last
//                strongSlf.present(alert, animated: true)
//            }
//            
//            cell.submitInProgress = false
//            strongSlf.navigationController?.view.isUserInteractionEnabled = true
//        }
        
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let baseCell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        guard let cell = baseCell as? SubmitAttendeesTableViewCell else {
            return baseCell
        }

        _configureCell(cell)

        return cell
    }
    
    private func _configureCell(_ cell: SubmitAttendeesTableViewCell) {
        
        cell.labelInfo.textColor = UIColor.mainTextGradientColor(bounds: CGRect(origin: CGPoint.zero, size: cell.labelInfo.sizeThatFits(CGSize.zero)))
        
        cell.canvasView.layer.cornerRadius = 8.0
        cell.canvasView.layer.borderWidth = 1.0
        cell.canvasView.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        cell.viewBackground.layer.cornerRadius = 8.0
        cell.viewBackground.layer.borderWidth = 1.0
        cell.viewBackground.layer.borderColor = UIColor.tertiaryLabel.cgColor
        cell.viewBackground.clipsToBounds = true
        cell.viewBackground.backgroundColor = .backgroundGrayColor()
        
        cell.canvasView.overrideUserInterfaceStyle = .light
        cell.canvasView.tool = PKInkingTool(.pen, color: .darkText, width: 10)
        cell.canvasView.drawingPolicy = .anyInput
        cell.canvasView.delegate = self
        
        cell.buttonCancel.setTitle("", for: .normal)
        cell.buttonUpload.setTitle("", for: .normal)
        
        cell.viewButtonUpload.layer.cornerRadius = 4.0
        cell.buttonCancel.layer.cornerRadius = 4.0
        cell.buttonCancel.layer.borderWidth = 1.0
        cell.buttonCancel.layer.borderColor = UIColor.tertiaryLabel.cgColor
        
        cell.viewButtonUpload.backgroundColor = .buttonBackgroundGradientColor1(bounds: cell.viewButtonUpload.bounds)

    }
    
    
    //MARK: - PKCanvasViewDelegate
    
    func canvasViewDidBeginUsingTool(_ canvasView: PKCanvasView) {
        _canvasInUse = true
        tableView.isScrollEnabled = false
    }
    
    func canvasViewDidEndUsingTool(_ canvasView: PKCanvasView) {
        _canvasInUse = false
        guard UIDevice.current.userInterfaceIdiom != .pad else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            if !self._canvasInUse {
                self.tableView.isScrollEnabled = true
            }
        }
    }

}

class SubmitAttendeesTableViewCell: UITableViewCell {
    
    var submitInProgress = false {
        didSet {
            if submitInProgress {
                activity.startAnimating()
            }
            else {
                activity.stopAnimating()
            }
            
        }
    }
    
    @IBOutlet weak var labelInfo: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var canvasView: PKCanvasView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    @IBOutlet weak var viewButtonCancel: UIView!
    @IBOutlet weak var viewButtonUpload: UIView!
    
    @IBOutlet weak var buttonCancel: UIButton!
    @IBOutlet weak var buttonUpload: UIButton!
    
    @IBAction func clearAction () {
        canvasView.drawing = PKDrawing()
    }
    
}
