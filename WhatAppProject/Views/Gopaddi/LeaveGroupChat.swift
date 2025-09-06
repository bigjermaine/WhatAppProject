//
//  LeaveGroupChat.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 06/09/2025.
//
import SwiftUI
import UIKit

protocol LeaveBottomSheetDelegate: AnyObject {
    func bottomSheetDidTapFirstButton(_ sheet: LeaveGroupChatontroller)
    func bottomSheetDidTapSecondButton(_ sheet: LeaveGroupChatontroller)
    func bottomSheetDidDismiss(_ sheet: LeaveGroupChatontroller)
}
// MARK: - Bottom Sheet VC
class LeaveGroupChatontroller: UIViewController {
    
    weak var delegate: LeaveBottomSheetDelegate?
    
    private let containerView = UIView()
    private let firstButton = UIButton(type: .system)
    private let secondButton = UIButton(type: .system)
    private let handleView = UIView()
    
    private var panGesture: UIPanGestureRecognizer!
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Select Time"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Would you like to create a new group or to add a new chat?"
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var addLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.text = "Add new"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var closeButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named:"DMPlaceCloseButton"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    public let borderLine: UIView = {
        let borderLine = UIView()
        borderLine.translatesAutoresizingMaskIntoConstraints = false
        borderLine.backgroundColor = .gray.withAlphaComponent(0.3)
        return borderLine
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        setupContainer()
        setupButtons()
        setupPanGesture()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissSheet))
        view.addGestureRecognizer(tap)
    }
    
    private func setupContainer() {
       containerView.backgroundColor = .white
        containerView.layer.cornerRadius = 4
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        containerView.clipsToBounds = true
        view.addSubview(containerView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            containerView.heightAnchor.constraint(equalToConstant: 250)
        ])
        
        // Drag handle
        handleView.backgroundColor = .systemGray3
        handleView.layer.cornerRadius = 3
        containerView.addSubview(handleView)
        handleView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            handleView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8),
            handleView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            handleView.widthAnchor.constraint(equalToConstant: 120),
            handleView.heightAnchor.constraint(equalToConstant: 6)
        ])
        containerView.addSubview(addLabel)
        NSLayoutConstraint.activate([
            addLabel.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 15),
            addLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant: 10),
            addLabel.widthAnchor.constraint(equalToConstant: 120),
           
        ])
        containerView.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: handleView.bottomAnchor, constant: 15),
            closeButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor,constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
           
        ])
        
        containerView.addSubview(borderLine)
        NSLayoutConstraint.activate([
            borderLine.topAnchor.constraint(equalTo: closeButton.bottomAnchor, constant: 20),
            borderLine.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant:0),
            borderLine.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0),
            borderLine.heightAnchor.constraint(equalToConstant:1)
           
        ])
        
        containerView.addSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            descriptionLabel.topAnchor.constraint(equalTo: borderLine.bottomAnchor, constant: 20),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor,constant:16),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
        ])
  
    }
    
    private func setupButtons() {
        firstButton.setTitle("New group", for: .normal)
        firstButton.addTarget(self, action: #selector(firstButtonTapped), for: .touchUpInside)
        
        secondButton.setTitle("New chat", for: .normal)
        secondButton.addTarget(self, action: #selector(secondButtonTapped), for: .touchUpInside)
        
        let stack = UIStackView(arrangedSubviews: [firstButton, secondButton])
        stack.axis = .horizontal
        stack.spacing = 16
        stack.distribution = .fillEqually
        containerView.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
            stack.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor,constant: 20),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20)
        ])
    }
    
    private func setupPanGesture() {
        panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        containerView.addGestureRecognizer(panGesture)
    }
    
    @objc private func firstButtonTapped() {
        delegate?.bottomSheetDidTapFirstButton(self)
    }
    
    @objc private func secondButtonTapped() {
      delegate?.bottomSheetDidTapSecondButton(self)
      dismissSheet()
    }
    
    @objc private func dismissSheet() {
        dismiss(animated: true) {
            self.delegate?.bottomSheetDidDismiss(self)
        }
    }
    
    @objc private func handlePan(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: view)
        if translation.y > 100 {
            dismissSheet()
        }
    }
}


struct LeaveGroupChatontroller_Previews: PreviewProvider {
    static var previews: some View {
    
        ViewControllerPreview {
          UINavigationController(rootViewController:LeaveGroupChatontroller())
        }
        
    }
}


