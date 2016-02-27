//
//  ViewController.swift
//  What's the Weather
//
//  Created by Kersuzan on 20/09/2015.
//  Copyright © 2015 Kersuzan. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cityTextField: UITextField!
    
    @IBOutlet var resultLabel: UILabel!
    
    @IBOutlet var cityNameLabel: UILabel!
    
    @IBAction func getWeather(sender: AnyObject) {
        
        // Hide the keyboard
        self.view.endEditing(true)
        
        var wasSuccessful: Bool = false
        
        let cityEnteredByUser = cityTextField.text
        
        let cityTrimmed = cityEnteredByUser?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        let city = cityTrimmed?.stringByReplacingOccurrencesOfString(" ", withString: "-")
        
        let attemptedUrl = NSURL(string: "http://www.weather-forecast.com/locations/" + city! + "/forecasts/latest")
        
        if let url = attemptedUrl {
            print("ok")
            let task = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) -> Void in
                
                // Check if we get data
                if let urlContent = data {
                    let webContent = NSString(data: urlContent, encoding: NSUTF8StringEncoding)
                    // Explode the webContent to get only the sentence we want to display to the user
                    let webContentArray = webContent?.componentsSeparatedByString("Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">")
                    // Check if the explode has successfully worked
                    if webContentArray!.count > 1 {
                        // Now we can get the weather informations
                        let weatherInfoArray = webContentArray![1].componentsSeparatedByString("</span>")
                    
                        // Check if the second explode succeeded
                        if weatherInfoArray.count > 1 {
                            // Request was successful
                            wasSuccessful = true
                            
                            // Put it into the result label
                            let weatherSummary = weatherInfoArray[0]
                            
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                self.resultLabel.text = weatherSummary.stringByReplacingOccurrencesOfString("&deg;", withString: "º")
                                
                                self.cityNameLabel.text = city!.uppercaseString
                                self.cityTextField.text = ""
                            })
                        }
                    }
                }
                
                if wasSuccessful == false {
                    print("Not ok")
                    self.resultLabel.text = "Please enter a valid city name!"
                    self.cityTextField.text = ""
                }
                
            } // End task
            
            task.resume()
        } else {
            print("Not ok")
            self.resultLabel.text = "Please enter a valid city name!"
            self.cityTextField.text = ""
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.cityTextField.delegate = self
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        cityTextField.resignFirstResponder()
        return true
    }


}

