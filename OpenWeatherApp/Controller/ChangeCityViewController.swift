//
//  ChangeCityViewController.swift
//  OpenWeatherApp
//
//  Created by Karlis Stekels on 04/02/2021.
//

import UIKit

protocol ChangeCityDelegate {
    func userEnterCityName(city: String)
}

class ChangeCityViewController: UIViewController {

    var delegate: ChangeCityDelegate?
    @IBOutlet weak var cityTextField: DesignableTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func getWeatherTapped(_ sender: Any) {
        
        guard let cityName = cityTextField.text else {
            return
        }
        if !cityName.isEmpty{
            delegate?.userEnterCityName(city: cityName)
        }
        
        
        self.dismiss(animated: true, completion: nil)
    }
    
}
