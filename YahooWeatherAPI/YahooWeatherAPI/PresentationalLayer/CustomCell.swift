//
//  CustomCell.swift
//  YahooWeatherAPI
//
//  Created by user on 10/8/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

final class CustomCell: UITableViewCell {
    @IBOutlet private weak var dayLabel: UILabel!
    @IBOutlet private weak var stateLabel: UILabel!
    @IBOutlet private weak var highLabel: UILabel!
    @IBOutlet private weak var lowLabel: UILabel!
    
    func configure(by day: Day) {
        dayLabel.text = convertDay(day.day)
        stateLabel.text = day.text
        highLabel.text = convertTemperatureToString(day.high)
        lowLabel.text = convertTemperatureToString(day.low)
    }
    
    private func convertDay(_ day: String) -> String {
        guard let dayOfAWeek = Constants.days[day] else { return "" }
        return dayOfAWeek
    }
    
    private func convertTemperatureToString(_ temperature: Int) -> String {
        return temperature >= 0 ? "+\(temperature)℃" : "\(temperature)℃"
    }
}
