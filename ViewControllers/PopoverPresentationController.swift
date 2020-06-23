//
//  PopoverPresentationController.swift
//  Recur
//
//  Created by Wenyuan Bao on 9/3/19.
//  Copyright © 2019 buildschool. All rights reserved.
//

import UIKit

class PopoverPresentationController: UIPresentationController {
    private var dimmingView: UIView!
    private let padding: CGFloat = 21.0
    private var keyboardIsShowing = false
    private var shouldAutosizeToPresentedVC = false
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        presentedViewController.view.layer.cornerRadius = 24.0
        presentedViewController.view.clipsToBounds = true
        setupDimmingView()
        setupKeyboard()
    }
    
    convenience init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?, sizeToPresentedVC: Bool) {
        self.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        self.shouldAutosizeToPresentedVC = sizeToPresentedVC
    }
    
    override var frameOfPresentedViewInContainerView: CGRect {
        return idealFrame()
    }
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        containerView.insertSubview(dimmingView, at: 0)
        containerView.constrain(subview: dimmingView)
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 1.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 1.0
        })
    }
    
    override func dismissalTransitionWillBegin() {
        guard let coordinator = presentedViewController.transitionCoordinator else {
            dimmingView.alpha = 0.0
            return
        }
        coordinator.animate(alongsideTransition: { _ in
            self.dimmingView.alpha = 0.0
        })
    }
    
    // MARK: - Private
    
    private func idealFrame() -> CGRect {
        guard let containerView = self.containerView,
            let presentedView = self.presentedViewController.view else {
                return CGRect.zero
        }
        
        let bottomPadding = containerView.safeAreaInsets.bottom + padding
        let width = UIScreen.main.bounds.width - padding * 2
        var size: CGSize
        if shouldAutosizeToPresentedVC {
            size = presentedView.systemLayoutSizeFitting(CGSize(width: width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .defaultLow)
        } else {
            size = CGSize(width: width, height: containerView.bounds.height * 0.85)
        }
        let verticalOffset = containerView.bounds.maxY - size.height - bottomPadding
        
        return CGRect(x: padding, y: verticalOffset, width: size.width, height: size.height)
    }
    
    private func setupDimmingView() {
        dimmingView = UIView()
        dimmingView.translatesAutoresizingMaskIntoConstraints = false
        dimmingView.backgroundColor = UIColor(white: 0.0, alpha: 0.5)
        dimmingView.alpha = 0.0
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dimmingViewTapped))
        self.dimmingView.addGestureRecognizer(gesture)
    }
    
    @objc private func dimmingViewTapped() {
        if keyboardIsShowing {
            presentedView?.endEditing(true)
        }
        presentedViewController.dismiss(animated: true, completion: nil)
    }
    
    private func setupKeyboard() {
        let center = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardWillShow),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        
        center.addObserver(self,
                           selector: #selector(keyboardWillHide),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        keyboardIsShowing = true
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        guard let containerView = self.containerView else { return }
        let maxFrame = idealFrame()
        let fullHeight: CGFloat = containerView.bounds.height - keyboardFrame.cgRectValue.height
        let height = min(fullHeight - 2 * padding - containerView.safeAreaInsets.top, maxFrame.height)
        self.presentedView?.frame = CGRect(x: padding, y: fullHeight - padding - height,
                                           width: containerView.bounds.width - 2 * padding, height: height)
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        keyboardIsShowing = false
        presentedView?.frame = idealFrame()
        presentedView?.endEditing(true)
    }
}
