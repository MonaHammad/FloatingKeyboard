//
//  ViewController.swift
//  FloatingKeyboard
//
//  Created by Mona Hammad on 12/2/19.
//  Copyright © 2019 Mona Hammad. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var bottonConstraint: NSLayoutConstraint!
    var initialConstant: CGFloat!
    @IBOutlet weak var textField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initialConstant = bottonConstraint.constant
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissKeyboard))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        textField.inputAccessoryView = keyboardToolbar
        
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        self.keyboardControl(notification, isShowing: true)
    }

    @objc func keyboardWillHide(notification: Notification) {
        self.keyboardControl(notification, isShowing: false)
    }

    private func keyboardControl(_ notification: Notification, isShowing: Bool) {
        print(isShowing)

        /* Handle the Keyboard property of Default*/

        let userInfo = notification.userInfo!
        let keyboardRect = (userInfo[UIResponder.keyboardFrameEndUserInfoKey]! as AnyObject).cgRectValue
        let curve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey]! as AnyObject).uint32Value

        let convertedFrame = self.view.convert(keyboardRect!, from: nil)
        let heightOffset = self.view.bounds.size.height - convertedFrame.origin.y
        let options = UIView.AnimationOptions(rawValue: UInt(curve!) << 16 | UIView.AnimationOptions.beginFromCurrentState.rawValue)
        let duration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey]! as AnyObject).doubleValue



        var  pureheightOffset : CGFloat = -heightOffset

        if isShowing { /// Wite space of save area in iphonex ios 11
            if #available(iOS 11.0, *) {
                pureheightOffset = pureheightOffset + view.safeAreaInsets.bottom
            }
        }
        
        bottonConstraint.constant = isShowing ? pureheightOffset : -initialConstant
        UIView.animate(
            withDuration: duration!,
            delay: 0,
            options: options,
            animations: {
                self.view.layoutIfNeeded()
        },
            completion: { bool in

        })

    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }

}

