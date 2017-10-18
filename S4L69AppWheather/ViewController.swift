//
//  ViewController.swift
//  S4L69AppWheather
//
//  Created by Martin Berger on 10/18/17.
//  Copyright © 2017 Martin Berger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBAction func submit(_ sender: Any) {
        if let url = URL(string:"https://www.weather-forecast.com/locations/" + textField.text!.replacingOccurrences(of: " ", with: "-") + "/forecasts/latest") {
            
            let request = NSMutableURLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: request as URLRequest) {
                data, response, error in
                var message = ""
                if let error = error {
                    print(error)
                } else {
                    if let unwrapedData = data {
                        let dataString = NSString(data: unwrapedData, encoding: String.Encoding.utf8.rawValue)
                        
                        var stringSeparator = "Weather Forecast Summary:</b><span class=\"read-more-small\"><span class=\"read-more-content\"> <span class=\"phrase\">"
                        if let contentArray = dataString?.components(separatedBy: stringSeparator) {
                            print(contentArray)
                            if contentArray.count > 1 {
                                stringSeparator = "</span>"
                                let newContentArray = contentArray[1].components(separatedBy: stringSeparator)
                                if newContentArray.count > 1 {
                                    message = newContentArray[0].replacingOccurrences(of: "&deg;",with: "°")
                                    print(message)
                                }
                                
                            }
                        }
                    }
                }
                if message == "" {
                    message = "The weather there couldn't be found. Please try again."
                    
                }
                DispatchQueue.main.sync(execute: {
                    self.weatherLabel.text = message
                })
                
                
            }
            
            
            task.resume()
        } else {
            weatherLabel.text = "The weather there couldn't be found. Please try again."
        }
       
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
    }
        
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

}

