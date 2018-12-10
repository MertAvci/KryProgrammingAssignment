//
//  AddServiceController.swift
//  KryProgrammingAssignment
//
//  Created by Mert Avci on 2018-12-07.
//  Copyright © 2018 MertAvci. All rights reserved.
//

import UIKit

class AddServiceController: UIViewController, UITextFieldDelegate {


    // MARK: Outlets

    @IBOutlet weak var urlField: UITextField!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var saveButton: UIButton!


    var serviceAddedCallback: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        saveButton.isEnabled = false

        urlField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        nameField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissSearchKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc private func dismissSearchKeyboard() {

        urlField.endEditing(true)
        nameField.endEditing(true)
    }


    @IBAction func cancelAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }


    @IBAction func addServiceAction(_ sender: UIButton) {

        sender.isEnabled = false
        if let url = URL(string: urlField.text ?? ""), let name = nameField.text {

            let newService = Service(baseURL: url, name: "\(name)", isAvailable: nil, lastUpdate : nil)
            ApiService.sharedInstance.getServiceStatus(service: newService) { (service, error) in

                if error == .couldNotFind {
                    self.presentErrorAlert()
                    return
                }
                DispatchQueue.main.async {
                    sender.isEnabled = true
                }
                self.serviceAddedCallback?()
                self.dismiss(animated: true, completion: nil)
            }
        } else {
            presentErrorAlert()
        }
        sender.isEnabled = true
    }

    private func presentErrorAlert() {

        let alertController = UIAlertController(title: "Error", message: "URL is not valid", preferredStyle: .alert)
        let okayAction = UIAlertAction(title: "Okay", style: .default) { (UIAlertAction) in }
        alertController.addAction(okayAction)
        DispatchQueue.main.async {
            self.present(alertController, animated: true, completion: nil)
        }
    }

    @objc func textFieldDidChange(_ textField: UITextField) {

        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard
            let url = urlField.text, !url.isEmpty,
            let name = nameField.text, !name.isEmpty
            else {
                self.saveButton.isEnabled = false
                return
        }
        saveButton.isEnabled = true
    }
}
