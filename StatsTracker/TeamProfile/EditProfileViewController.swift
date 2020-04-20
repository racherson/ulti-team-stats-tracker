//
//  EditProfileViewController.swift
//  StatsTracker
//
//  Created by Rachel Anderson on 4/15/20.
//  Copyright © 2020 Rachel Anderson. All rights reserved.
//

import UIKit

protocol EditProfileViewControllerDelegate {
    func cancelPressed()
    func savePressed(newName: String, newImage: UIImage)
}

class EditProfileViewController: UIViewController, Storyboarded, UINavigationControllerDelegate {
    
    //MARK: Properties
    var delegate: EditProfileViewControllerDelegate?
    var teamName: String?
    var teamImage: UIImage?
    var saveButton: UIBarButtonItem?
    @IBOutlet weak var teamNameTextField: UITextField!
    @IBOutlet weak var teamPhotoImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Handle the text field’s user input through delegate callbacks.
        teamNameTextField.delegate = self
        
        // Add bar button items to navigation
        setUpUI()
    }
    
    func setUpUI() {
        // Add cancel button
        let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(self.cancelPressed))
        self.navigationItem.leftBarButtonItem  = cancelButton
        
        // Add save button
        saveButton = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(self.savePressed))
        self.navigationItem.rightBarButtonItem = saveButton
        
        teamNameTextField.text = teamName
        teamPhotoImage.image = teamImage
        teamNameTextField.addTarget(self, action: #selector(textFieldIsNotEmpty), for: .allEditingEvents)
    }
    
    //MARK: Actions
    @objc func textFieldIsNotEmpty(sender: UITextField) {
        sender.text = sender.text?.trimmingCharacters(in: .whitespaces)
        
        // Validate text field is not empty
        guard let teamName = teamNameTextField.text, !teamName.isEmpty else {
            self.saveButton!.isEnabled = false
            return
        }
        // enable save button if conditions are met
        saveButton!.isEnabled = true
    }
    
    @objc func cancelPressed() {
        delegate?.cancelPressed()
    }
    
    @objc func savePressed() {
        delegate?.savePressed(newName: teamName!, newImage: teamImage!)
    }
    
    @IBAction func selectImageFromPhotoLibrary(_ sender: UITapGestureRecognizer) {
        // Hide the keyboard.
        teamNameTextField.resignFirstResponder()
        
        // UIImagePickerController is a view controller that lets a user pick media from their photo library.
        let imagePickerController = UIImagePickerController()
        
        // Only allow photos to be picked, not taken.
        imagePickerController.sourceType = .photoLibrary
        
        // Make sure ViewController is notified when the user picks an image.
        imagePickerController.delegate = self
        present(imagePickerController, animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        // Check that input is not empty
        if textField.text == nil {
            fatalError(Constants.Errors.emptyFieldsError)
        }
        teamName = textField.text!
    }
}

extension EditProfileViewController: UIImagePickerControllerDelegate {
    
    //MARK: UIImagePickerControllerDelegate
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // Dismiss the picker if the user canceled.
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // The info dictionary may contain multiple representations of the image. You want to use the original.
        guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        // Set photoImageView to display the selected image.
        teamPhotoImage.image = selectedImage
        teamImage = selectedImage
        
        // Dismiss the picker.
        dismiss(animated: true, completion: nil)
    }
}
