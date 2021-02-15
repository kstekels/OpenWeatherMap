//
//  WeatherViewController.swift
//  OpenWeatherApp
//
//  Created by Karlis Stekels on 04/02/2021.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
   

    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    
    let weatherDataModel = WeatherDataModel()
    let loactionManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loactionManager.delegate = self
        loactionManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        loactionManager.requestAlwaysAuthorization()
        loactionManager.startUpdatingLocation()
    }
    
    //MARK: - CLLocationManager
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            loactionManager.stopUpdatingLocation()
            print("long: \(location.coordinate.longitude), lat: \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params: [String:String] = ["lat": latitude , "lon": longitude , "appid": weatherDataModel.apiId]
            
            getWeatherData(url: weatherDataModel.apiUrl, params: params)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("err: ", error)
        //update
    }
    
    
    func getWeatherData(url: String, params: [String: String]){
        
        AF.request(url, method: .get, parameters: params).responseJSON { (response) in
            if response.value != nil {
                let weatherJSON: JSON = JSON(response.value!)
                print("weatherJSON: ", weatherJSON)
                //update
                self.updateWeatherData(json: weatherJSON)
            }else{
                print("err, \(String(describing: response.error))")
                self.cityLabel.text = "Weather unavailible !"
            }
        }
    }
    
    func updateWeatherData(json: JSON){
        
        if let tempResult = json["main"]["temp"].double {
            weatherDataModel.temp = Int(tempResult - 273.15)
            
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            updateUI()
            
        }else{
            self.cityLabel.text = "Weather unavailible !"
        }
        
    }
    
    //MARK: - UpdateUI
    
    func updateUI(){
        cityLabel.text = weatherDataModel.city
        tempLabel.text = "\(weatherDataModel.temp) º"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    //MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "city"{
            let vc = segue.destination as! ChangeCityViewController
            vc.delegate = self
        }
    }
    
    
    func userEnterCityName(city: String) {
        print(city)
        let params: [String:String] = ["q": city , "appid": weatherDataModel.apiId]
        
        getWeatherData(url: weatherDataModel.apiUrl, params: params)
    }
    

}

