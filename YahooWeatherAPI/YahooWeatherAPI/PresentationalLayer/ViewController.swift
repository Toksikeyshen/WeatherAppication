//
//  ViewController.swift
//  YahooWeatherAPI
//
//  Created by user on 10/7/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import Dropper

final class ViewController: UIViewController {
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var dropDownButton: UIButton!
    
    private var weatherForWeek: [Day] = []
    private let dropper = Dropper(width: 100, height: 400)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.attributedTitle = NSAttributedString(string: "Updating...")
        tableView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        dropper.delegate = self
        tableView.dataSource = self
        
        dropDownButton.setTitle("Brest", for: .normal)
        getData(location: "brest,by")
    }
    
    // MARK: - Action method
    
    @IBAction private func dropDownAction(_ sender: UIButton) {
        if dropper.status == .hidden {
            dropper.items = ["Brest", "Minsk", "Vitebsk", "Grodno", "Gomel", "Mogilev"]
            dropper.theme = Dropper.Themes.white
            dropper.border = (1, .lightGray)
            dropper.cornerRadius = 8
            dropper.delegate = self
            dropper.showWithAnimation(0.5, options: .center, button: dropDownButton)
            dropper.center = CGPoint(x: view.frame.size.width / 2, y: dropper.center.y)
            view.addSubview(dropper)
        } else {
            dropper.hideWithAnimation(0.5)
        }
    }
    
    // MARK: - Private methods
    
    @objc private func refresh() {
        guard let city = dropDownButton.currentTitle else { return }
        guard let location = Constants.cities[city] else { return }
        
        getData(location: location)
        tableView.refreshControl?.endRefreshing()
    }
    
    private func getData(location: String) {
        weatherForWeek.removeAll()
        tableView.reloadData()
        ParseJSONService.shared.parse(location: location) {[weak self] result in
            switch result {
            case  .failure(let error):
                print(error)
                if error == .noConnection {
                    self?.networkAlert()
                }
            case .success(let forecasts):
                self?.weatherForWeek = forecasts
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    private func networkAlert() {
        let alert = UIAlertController(title: "Connection not found",
                                      message: "Please check your internet connection",
                                      preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}

// MARK: - TableView DataSource

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherForWeek.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        guard let customCell = cell as? CustomCell else { return cell }
        let day = weatherForWeek[indexPath.row]
        customCell.configure(by: day)
        return customCell
    }
}

//MARK: - DropperDelegate

extension ViewController: DropperDelegate {
    func DropperSelectedRow(_ path: IndexPath, contents: String) {
        getData(location: transformLocation(city: contents))
        dropDownButton.setTitle(contents, for: .normal)
    }
    
    private func transformLocation (city: String) -> String {
        guard let city = Constants.cities[city] else { return "brest,by" }
        return city
    }
}
