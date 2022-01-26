//
//  ViewController+Helper.swift
//
//
//  Created by Tùng Xuân on 8/16/20.
//  Copyright © 2020 Tung Xuan. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import MessageUI

extension UIViewController {
    // MARK: - Alert
    func showAlert(title: String?, message: String?) {
        DispatchQueue.main.async {
            self.showAlert(title: title, message: message, negative: "Close".localized(), positive: nil, negativeCompletion: nil, positiveCompletion: nil)
        }
    }
    
    func showAlert(title: String?, message: String?, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async {
            self.showAlert(title: title, message: message, negative: "OK".localized(), positive: nil, negativeCompletion: completion, positiveCompletion: nil)
        }
    }
    
    func showAlert(title: String?, message: String?, negative: String? = nil, positive: String? = nil, negativeCompletion: (() -> (Void))? = nil, positiveCompletion: (() -> (Void))? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            if let n = negative {
                alert.addAction(UIAlertAction(title: n, style: .cancel, handler: {
                    (action) in
                    negativeCompletion?()
                }))
            }
            if let p = positive {
                alert.addAction(UIAlertAction(title: p, style: .default, handler: {
                    (action) in
                    positiveCompletion?()
                }))
            }
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func getPreviousNavVC() -> UIViewController? {
        if let navVC = self.navigationController {
            let count = navVC.viewControllers.count
            if count > 1 {
                return navVC.viewControllers[count - 2]
            }
        }
        return nil
    }
    
    // MARK: - Present video
    func presentVideo(url: URL) {
        DispatchQueue.main.async { [weak self] in
            let objAVPlayerVC = AVPlayerViewController()
            objAVPlayerVC.player = AVPlayer(url: url)
            self?.present(objAVPlayerVC, animated: true, completion: {() -> Void in
                objAVPlayerVC.player?.play()
            })
        }
    }
    
    // MARK: - Toolbar
    func addToolBarDoneButton(textField: UITextField) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 73/255, green: 145/255, blue: 233/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneToolbarHideKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.inputAccessoryView = toolBar
    }
    
    func addToolBarDoneButton(textView: UITextView) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 73/255, green: 145/255, blue: 233/255, alpha: 1)
        let doneButton = UIBarButtonItem(title: NSLocalizedString("Done", comment: ""), style: UIBarButtonItem.Style.done, target: self, action: #selector(doneToolbarHideKeyboard))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([spaceButton, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textView.inputAccessoryView = toolBar
    }
    
    @objc func doneToolbarHideKeyboard(){
        view.endEditing(true)
    }
    
    // MARK: - Dismiss
    @IBAction func dismiss() {
        DispatchQueue.main.async {
            if let nav = self.navigationController { nav.popViewController(animated: true) }
            else { self.dismiss(animated: true, completion: nil) }
        }
    }
}

// MARK: UIWindow Top Root
extension UIWindow {
    
    func topViewController() -> UIViewController {
        return self.topViewControllerWithRootViewController(rootVC: self.rootViewController!)
    }
    
    private func topViewControllerWithRootViewController(rootVC: UIViewController) -> UIViewController {
        if rootVC is UITabBarController {
            let tabBarController = rootVC as! UITabBarController
            return self.topViewControllerWithRootViewController(rootVC: tabBarController.selectedViewController!)
        } else if rootVC is UINavigationController {
            let navigationController = rootVC as! UINavigationController
            return self.topViewControllerWithRootViewController(rootVC: navigationController.visibleViewController!)
        } else if let vc = rootVC.presentedViewController {
            return self.topViewControllerWithRootViewController(rootVC: vc)
        } else {
            return rootVC
        }
    }
    
    /// Thay doi rootVC cua UIWindow
    func setRootViewController(root: UIViewController, animated: Bool) {
        var snapShotView: UIView?
        
        if animated {
            snapShotView = self.snapshotView(afterScreenUpdates: true)
            root.view.addSubview(snapShotView!)
        }
        self.rootViewController = root
        
        if animated {
            UIView.animate(withDuration: 0.3, animations: {
                snapShotView?.layer.opacity = 0
                snapShotView?.layer.transform = CATransform3DMakeScale(1.5, 1.5, 1.5)
            }) { (finished) in
                snapShotView?.removeFromSuperview()
            }
        }
    }
}

// MARK: Keyboard Delegate
extension UIViewController {
    func initObserverKeyboard() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShowSelector(notification:)), name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHideSelector(notification:)), name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    func removeObserverKeyboard() {
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillHideSelector(notification: NSNotification?) {
        DispatchQueue.main.async {
            self.keyboardWillHide()
        }
    }
    
    @objc private func keyboardWillShowSelector(notification: NSNotification) {
        if let dictUserInfo: NSDictionary = notification.userInfo as NSDictionary? {
            if let value: NSValue = dictUserInfo.object(forKey: UIWindow.keyboardFrameEndUserInfoKey) as? NSValue {
                let rectKeyboard = value.cgRectValue
                let keyboardHeight = rectKeyboard.size.height - Constant.bottomPadding
                DispatchQueue.main.async {
                    self.keyboardWillShow(height: keyboardHeight)
                }
            }
        }
    }
    
    @objc func keyboardWillHide() {}
    
    @objc func keyboardWillShow(height: CGFloat) {}
    
    func outsideHideKeyboard(target v: UIView? = nil, cancelsTouches: Bool = false) {
        if let v = v {
            let tapGesture = UITapGestureRecognizer(target: v, action: #selector(UIView.endEditing))
            v.addGestureRecognizer(tapGesture)
            tapGesture.cancelsTouchesInView = cancelsTouches
        }
        else {
            let tapGesture = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
            self.view.addGestureRecognizer(tapGesture)
            tapGesture.cancelsTouchesInView = cancelsTouches
        }
    }
    
    func showText(_ text: String?) {
        if let text = text {
            dpMain {
                HUD.showText(self.view, text: text, hide: 1.5)
            }
        }
    }
    
    func push(_ viewController: UIViewController) {
        if let nav = self.navigationController {
            nav.pushViewController(viewController, animated: true)
        }
        else {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}


// MARK: - Thread
func dpMain(_ f: @escaping () -> Void) {
    DispatchQueue.main.async {
        f()
    }
}

func dpGlobal(_ f: @escaping () -> Void) {
    DispatchQueue.global().async {
        f()
    }
}

// MARK: - Mail
extension UIViewController : MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIScene
@available(iOS 13.0, *)
extension UIResponder {
    @objc var scene: UIScene? {
        return nil
    }
}

@available(iOS 13.0, *)
extension UIScene {
    @objc override var scene: UIScene? {
        return self
    }
}

@available(iOS 13.0, *)
extension UIView {
    @objc override var scene: UIScene? {
        if let window = self.window {
            return window.windowScene
        } else {
            return self.next?.scene
        }
    }
}

@available(iOS 13.0, *)
extension UIViewController {
    @objc override var scene: UIScene? {
        // Try walking the responder chain
        var res = self.next?.scene
        if (res == nil) {
            // That didn't work. Try asking my parent view controller
            res = self.parent?.scene
        }
        if (res == nil) {
            // That didn't work. Try asking my presenting view controller
            res = self.presentingViewController?.scene
        }

        return res
    }
}


extension UIStoryboard {
    static let main: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    func get<T>(type: T.Type) -> T {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: String(describing: T.self)) as! T
        return vc
    }
}
