//
//  CreateFavoriteViewController.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/22/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit

class CreateFavoriteViewController: UIViewController {

    lazy var favoriteTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a name for your collection"
        tf.autocorrectionType = .no
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowOpacity = 1
        tf.layer.shadowOffset = CGSize.zero
        tf.layer.shadowRadius = 10
        return tf
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        favoriteTextField.delegate = self
        constraints()
        navigationItem.title = "Create Collection"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(dismissView))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveCollection))
    }
    @objc private func dismissView() {
        dismiss(animated: true, completion: nil)
    }
    @objc private func saveCollection() {
        //TODO: Save textField text in filemanager
        guard let collectionTitle = favoriteTextField.text, !collectionTitle.isEmpty else {
            let alertController = createAlertController(withTitle: "Error", message: "Please enter a name for your new collection.", andActionHandler: nil)
            self.present(alertController, animated: true, completion: nil)
            return
        }
        let saveSuccessful = FileManagerHelper.manager.addNewEmptyCollection(withName: collectionTitle)
        if saveSuccessful {
            //present success alert
            let successAlert = createAlertController(withTitle: "Success", message: "Saved to Collections.", andActionHandler: {_ in
                self.dismiss(animated: true, completion: nil)
            })
            self.favoriteTextField.resignFirstResponder()
            self.present(successAlert, animated: true, completion: nil)
        } else {
            //present error alert
            let errorAlert = createAlertController(withTitle: "Error", message: "You already created a collection with this name.", andActionHandler: {_ in
                self.favoriteTextField.text = ""
            })
            self.present(errorAlert, animated: true, completion: nil)
        }
    }
    
    private func constraints() {
        view.addSubview(favoriteTextField)
        favoriteTextField.snp.makeConstraints { (textField) in
            textField.top.leading.equalTo(self.view.safeAreaLayoutGuide).offset(5)
            textField.trailing.equalTo(self.view.safeAreaLayoutGuide).offset(-5)
            textField.height.equalTo(50)
        }
    }
    private func createAlertController(withTitle title: String?, message: String?, andActionHandler action: ((UIAlertAction) -> Void)?) -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "OK", style: .default, handler: action)
        alertController.addAction(alertAction)
        return alertController
    }

}
extension CreateFavoriteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
