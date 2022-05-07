//
//  TheoryViewController.swift
//  EGEKit
//
//  Created by user on 13.04.2022.
//

import Foundation
import UIKit
import PinLayout

final class TheoryViewController: UIViewController {
    
    private let titleOfScreen = UILabel()
    private let titleInfo = UILabel()
    private var tableView = UITableView()
    var theoryNames: [String] = []
    var theoryUrls: [String] = []
    var fontSize: CGFloat = 16
    let activityIndicator = UIActivityIndicatorView(style: .large)
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        getNamesUrls()
        
        titleOfScreen.text = "Полезный материал"
        titleOfScreen.font = .boldSystemFont(ofSize: 20)
        
        titleInfo.text = "Теоретический материал, разделенный по типам задач, который необходим для их решения"
        titleInfo.textColor = .systemGray
        titleInfo.numberOfLines = 2
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(.init(nibName: "UIViewTableViewCell", bundle: nil), forCellReuseIdentifier: "UIViewTableViewCell")
        tableView.separatorStyle = .none

//        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        [tableView,titleOfScreen,titleInfo,activityIndicator].forEach{self.view.addSubview($0)}
        
        activityIndicator.startAnimating()
        
        view.backgroundColor = .systemBackground
        
        let pinchRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(handlePinch))
        view.addGestureRecognizer(pinchRecognizer)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        activityIndicator.pin
            .center()
        
        titleOfScreen.pin
            .top(view.pin.safeArea.top)
            .hCenter()
            .sizeToFit()
        
        titleInfo.pin.below(of: titleOfScreen)
            .left()
            .right()
            .marginHorizontal(10)
            .height(60)
        
        tableView.pin
            .below(of: titleInfo)
            .left()
            .right()
            .bottom()
    }
    
    @objc
    private func handlePinch(gestureRecognizer: UIPinchGestureRecognizer) {
        guard gestureRecognizer.state == .began || gestureRecognizer.state == .changed else {
            return
        }
        self.fontSize = fontSize * gestureRecognizer.scale
//        print(fontSize)
        gestureRecognizer.scale = 1

        tableView.reloadData()
    }
    
    private func getNamesUrls() {
        Task {
            let result = await NetworkManager.shared.loadTheoryNamesAndUrls()
            
            theoryNames = result.0
            theoryUrls = result.1
            tableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    
    private func open(with urlString: String, title: String) {
        
        let viewC = TheoryDetailsViewController(urlString: urlString,title0: title)
        let navC = UINavigationController(rootViewController: viewC)
        present(navC, animated: true, completion: nil)
        
    }
}

extension TheoryViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        self.open(with: theoryUrls[indexPath.row], title: theoryNames[indexPath.row])
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        theoryNames.count
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
            
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UIViewTableViewCell", for: indexPath)
        
        let font = UIFont.systemFont(ofSize: self.fontSize, weight: .regular)
        
        cell.textLabel?.text = theoryNames[indexPath.row]
        cell.textLabel?.font = font
        
        return cell
    }

}