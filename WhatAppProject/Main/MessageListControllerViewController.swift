//
//  MessageListControllerViewController.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 15/04/2025.
//


import UIKit
import SwiftUI
import Combine

class MessageListControllerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var viewModel: ChatViewModel
    private var subscriptions = Set<AnyCancellable>()
    private let cellIdentifier = "MessageCell"
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        return tableView
    }()
    
    init(viewModel: ChatViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        subscriptions.forEach { $0.cancel() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupMessageListeners()
    }
    
    private func setupMessageListeners() {
        viewModel.$messageItem
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
                self?.scrollToBottom()
            }
            .store(in: &subscriptions)
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor)
        ])
    }
    
    private func scrollToBottom() {
        guard !viewModel.messageItem.isEmpty else { return }
        let indexPath = IndexPath(row: viewModel.messageItem.count - 1, section: 0)
        tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
    }
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.messageItem.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        let message = viewModel.messageItem[indexPath.row]
        let showDateHeader: Bool
        let currentDateLabel = message.date.relativeDateString

        if indexPath.row == 0 {
            showDateHeader = true
        } else {
            let previousMessage = viewModel.messageItem[indexPath.row - 1]
            showDateHeader = previousMessage.date.relativeDateString != currentDateLabel
         
        }
        
        cell.contentConfiguration = UIHostingConfiguration {
            switch message.type {
            case .photo:
                  BubbleImageView(item: message)
            case .text:
                BubbleTextView(item: message, showDateHeader: showDateHeader, dateHeaderText: currentDateLabel)
            case .video:
                BubbleAudioView(item: message)
            case .audio:
                BubbleAudioView(item: message)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

let chatPreViewwModel = ChatViewModel()

#Preview {
   
    MessageListView(viewModel: chatPreViewwModel)
}
