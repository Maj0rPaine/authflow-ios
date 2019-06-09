//
//  KeyboardObservable.swift
//  authflow-ios
//
//  Created by Chris Paine on 6/9/19.
//

import UIKit

protocol KeyboardObservable: class {
    func keyboardWillShow(withSize size: CGSize)
    func keyboardWillHide()
}

extension KeyboardObservable {
    func addKeyboardObserver(to notificationCenter: NotificationCenter) {
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillShowNotification,
            object: nil,
            queue: nil,
            using: { [unowned self] notification in
                guard let kbRect = notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? CGRect else { return }
                self.keyboardWillShow(withSize: kbRect.size)
        })
        notificationCenter.addObserver(
            forName: UIResponder.keyboardWillHideNotification,
            object: nil,
            queue: nil,
            using: { [unowned self] _ in
                self.keyboardWillHide()
        })
    }
    
    func removeKeyboardObserver(from notificationCenter: NotificationCenter) {
        notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillHideNotification,
            object: nil)
        notificationCenter.removeObserver(
            self,
            name: UIResponder.keyboardWillShowNotification,
            object: nil)
    }
}

protocol ScrollViewKeyboardObservable: KeyboardObservable {
    /// The scroll view to manage
    var keyboardObservableScrollView: UIScrollView { get }
    /// The view to keep visible
    var keyboardObservableView: UIView { get }
}

extension ScrollViewKeyboardObservable {
    func keyboardWillShow(withSize size: CGSize) {
        keyboardObservableScrollView.contentInset.bottom = size.height
        keyboardObservableScrollView.scrollIndicatorInsets.bottom = size.height
        
        if let view = keyboardObservableScrollView.superview {
            var viewRect = view.frame
            viewRect.size.height -= size.height
            if !viewRect.contains(keyboardObservableView.frame) {
                keyboardObservableScrollView.scrollRectToVisible(keyboardObservableView.frame, animated: true)
            }
        }
    }
    
    func keyboardWillHide() {
        keyboardObservableScrollView.contentInset.bottom = 0
        keyboardObservableScrollView.scrollIndicatorInsets.bottom = 0
    }
    
}
