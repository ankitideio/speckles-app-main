//
//  ImagePicker.swift
//  iSignIn
//
//  Created by meet sharma on 25/07/23.
//

import Foundation
import UIKit
class ImagePicker: NSObject, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
  var picker = UIImagePickerController()
  var alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet )
  var viewController: UIViewController?
  var pickImageCallback : ((UIImage) -> ())?
  override init(){
    super.init()
  }
    func pickCameraImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        picker.sourceType = .camera
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }
    
    func pickGalleryImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ())) {
        pickImageCallback = callback
        self.viewController = viewController
        picker.sourceType = .photoLibrary
        picker.delegate = self
        viewController.present(picker, animated: true, completion: nil)
    }
  func pickImage(_ viewController: UIViewController, _ callback: @escaping ((UIImage) -> ()))
  {
    pickImageCallback = callback;
    self.viewController = viewController;
    let cameraAction = UIAlertAction(title: "Camera", style: .default){
      UIAlertAction in
      self.openCamera()
    }
    let galleryAction = UIAlertAction(title: "Gallery", style: .default){
      UIAlertAction in
      self.openGallery()
    }
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel){
      UIAlertAction in
    }
    // Add the actions
    picker.delegate = self
    alert.addAction(cameraAction)
    alert.addAction(galleryAction)
    alert.addAction(cancelAction)
    alert.popoverPresentationController?.sourceView = self.viewController!.view
    viewController.present(alert, animated: true, completion: nil)
  }
  func openCamera()
  {
    alert.dismiss(animated: true, completion: nil)
    if(UIImagePickerController .isSourceTypeAvailable(.camera)){
      picker.sourceType = .camera
      self.viewController!.present(picker, animated: true, completion: nil)
    } else {
//      viewController?.showAlert(title: "Warning", message: "You don't have camera", actionTitles: ["OK"], actions: [{ (action) in
//      },nil])
    }
  }
  func openGallery()
    
  {
    alert.dismiss(animated: true, completion: nil)
    picker.sourceType = .photoLibrary
    self.viewController!.present(picker, animated: true, completion: nil)
  }
  func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true, completion: nil)
  }
  func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//    DispatchQueue.main.async {
//      UIApplication.shared.windows.first?.rootViewController?.showHUD()
//    }
    picker.dismiss(animated: true, completion: nil)
    DispatchQueue.main.async {
      guard let image = info[.originalImage] as? UIImage else{
        return
      }
      self.pickImageCallback?(image)
      picker.delegate = nil
    }
  }
  @objc func imagePickerController(_ picker: UIImagePickerController, pickedImage: UIImage?) {
  }
}
