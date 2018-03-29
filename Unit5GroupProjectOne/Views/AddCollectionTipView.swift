//
//  AddCollectionTipView.swift
//  Unit5GroupProjectOne
//
//  Created by C4Q on 1/21/18.
//  Copyright © 2018 C4Q. All rights reserved.
//

import UIKit
import SnapKit
import Kingfisher

//Message by Melissa: this is the view that the users will see after tapping the "+" bar button item in the venue detail view to add the venue to their collections or create a new collection with that venue
    //could also be what they see if they're in the collections tab; in the venue detail view, instead of seeing the "+" sign, they should see the "edit" sign so they can edit their tips!

class AddCollectionTipView: UIView {
    
    let radius: CGFloat = 5.0
    //to do:
        //should have a collection view at the bottom, and some stuff at the top
        //should have a textfield at the top which takes in the collection name
        //should have a "leave a tip" label
        //and below it should be a text view that lets you write/edit tips
        //create properties and initializers
    
        //maybe name the collection view the bottom view?
    lazy var venueTipCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.backgroundColor = .white
        cv.layer.borderWidth = 1
        cv.register(VenueCollectionViewCell.self, forCellWithReuseIdentifier: "AddCollectionTipCell")// not sure if we can use the same cell as venue collection??
        makeCornerRadius(view: cv)
        return cv
    }()
    
    lazy var venueTipTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter a name for your collection"
        tf.autocorrectionType = .no
        tf.textAlignment = .center
        tf.borderStyle = .roundedRect
        tf.layer.shadowColor = UIColor.black.cgColor
        tf.layer.shadowOpacity = 1
        tf.layer.shadowOffset = CGSize.zero
        tf.layer.shadowRadius = 10
        makeCornerRadius(view: tf)
        return tf
    }()
    
    lazy var venueTipLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.text = "Please Leave a Tip"
        label.textAlignment = .center
        label.layer.borderWidth = 1
        label.backgroundColor = .white
        makeCornerRadius(view: label)
        return label
    }()
    lazy var venueTipTextView: UITextView = {
        let textView = UITextView()
        textView.layer.borderWidth = 1
        makeCornerRadius(view: textView)
        return textView
    }()
    lazy var homeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage.init(named: "backhome"), for: .normal)
        button.setTitle("Home", for: .normal)
        button.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -45)// top, left, bottom, right
        button.titleEdgeInsets = UIEdgeInsetsMake(0, -30, -30, 0)
        makeCornerRadius(view: button)
        button.backgroundColor = UIColor(displayP3Red: 0.67, green: 0.07, blue: 0.50, alpha: 1)
        return button
    }()
    
    private func makeCornerRadius(view: UIView) {
        view.layer.masksToBounds = true
        view.layer.cornerRadius = radius
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        backgroundColor = .lightGray
        setupViews()
    }
    
    private func setupViews() {
        let viewObject = [venueTipCollectionView, venueTipTextField, venueTipLabel, venueTipTextView, homeButton] as [UIView]
        viewObject.forEach{addSubview($0)}
        
        let padding: CGFloat = 5
        
        venueTipTextField.snp.makeConstraints { (field) in
            field.top.leading.equalTo(self).offset(padding)
            field.trailing.equalTo(self).offset(-padding)
            field.height.equalTo(50)
        }
        venueTipLabel.snp.makeConstraints { (label) in
            label.width.equalTo(venueTipTextField)
            label.leading.equalTo(self).offset(padding)
            label.height.equalTo(venueTipLabel.snp.width).multipliedBy(0.05)
            label.top.equalTo(venueTipTextField.snp.bottom).offset(5)
        }
        venueTipTextView.snp.makeConstraints { (view) in
            view.leading.equalTo(self).offset(padding)
            view.width.equalTo(venueTipTextField)
            view.height.equalTo(venueTipTextView.snp.width).multipliedBy(0.5)
            view.top.equalTo(venueTipLabel.snp.bottom)
            
        }
        venueTipCollectionView.snp.makeConstraints { (collection) in
            collection.width.equalTo(venueTipTextField)
            collection.leading.equalTo(self).offset(padding)
            collection.top.equalTo(venueTipTextView.snp.bottom).offset(padding)
            collection.bottom.equalTo(homeButton.snp.top).offset(-padding)
        }
        homeButton.snp.makeConstraints { (button) in
            button.bottom.trailing.equalTo(self).offset(-padding)
            button.width.equalTo(venueTipTextField)
            button.height.equalTo(50)
        }
        
    }
    
    
    // MARK:- ---> Textfield Delegates
    func textFieldDidBeginEditing(textField: UITextField) {
        print("TextField did begin editing method called")
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("TextField did end editing method called")
    }
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        print("TextField should begin editing method called")
        return true;
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        print("TextField should clear method called")
        return true;
    }
    
    func textFieldShouldEndEditing(textField: UITextField) -> Bool {
        print("TextField should snd editing method called")
        return true;
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        print("While entering the characters this method gets called")
        return true;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        print("TextField should return method called")
        textField.resignFirstResponder();
        return true;
    }
    
    
}
