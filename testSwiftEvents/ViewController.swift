//
//  ViewController.swift
//  testSwiftEvents
//
//  Created by Gabriela Pittari on 19/07/2016.
//  Copyright © 2016 Gabriela Pittari. All rights reserved.
//

import UIKit
import Alamofire
import Gloss

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityButton: UIButton!
    @IBOutlet weak var acitivtyIndicator: UIActivityIndicatorView!
    @IBOutlet weak var cityPicker: UIPickerView!
    @IBOutlet weak var pickerView: UIView!
    private var events: [Event]? = []
    private let cities: [String] = ["New York", "Madrid", "London"]
    private var citySelected: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.pickerView.hidden = true
        
        self.cityPicker.dataSource = self
        self.cityPicker.delegate = self
        
        self.setCity(cities[0])
        self.loadEventsForPage("1")
    }
    
    func setCity (city: String) {
        self.citySelected = city
        self.cityButton.titleLabel?.text = city
    }
    
    func loadEventsForPage(page: String) {
        let qualityOfServiceClass = QOS_CLASS_BACKGROUND
        let backgroundQueue = dispatch_get_global_queue(qualityOfServiceClass, 0)
        self.showActivityIndicator()
        dispatch_async(backgroundQueue, {
            
            APIManager().getEvents(self.citySelected, page: page, success: { (response) in
                
                self.modelJsonData(response)
                
                }, failure: { (error) in
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.showAlert("Error", message: (error?.domain)!)
                    })
            })
        })
    }
    
    func showAlert(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default) { (result : UIAlertAction) -> Void in
            print("OK")
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true, completion: nil)
        self.pickerView.hidden = true
    }
    
    func modelJsonData(json: [String: AnyObject]!) -> Any! {
       
        guard let topEvents = TopEvents(json: json) else {
            print("Error initializing object")
            return nil
        }
        self.events = topEvents.events
        
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            
            self.pickerView.hidden = true
            self.tableView.reloadData()
        })
        
        return nil
    }
    
    func convertDateFormater(date: Date) -> String
    {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let date = dateFormatter.dateFromString(date.utc)
        
        dateFormatter.dateFormat = "dd-MM-yy HH:mm"
        dateFormatter.timeZone = NSTimeZone(name: "UTC")
        let timeStamp = dateFormatter.stringFromDate(date!)
        
        return timeStamp
    }
    
    @IBAction func citySelected(sender: UIButton) {
        self.showPickerView()
    }
    
    func showPickerView () {
        self.cityPicker.hidden = false
        self.acitivtyIndicator.hidden = true
        self.pickerView.hidden = false
    }
    
    func showActivityIndicator () {
        self.cityPicker.hidden = true
        self.acitivtyIndicator.hidden = false
        self.pickerView.hidden = false
    }
    
    //MARK - TableView Delegate and Datasource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events!.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("Cell")! as UITableViewCell
        
        if let nameLabel: UILabel = cell.viewWithTag(100) as? UILabel {
            nameLabel.text = self.events?[indexPath.item].name
        }
        
        if let dateLabel: UILabel = cell.viewWithTag(101) as? UILabel {
            let startDate = convertDateFormater((self.events?[indexPath.item].start)!)
            let endDate = convertDateFormater((self.events?[indexPath.item].end)!)
            dateLabel.text = "\(startDate) - \(endDate)"
        }
        
        if let logoImageView: UIImageView = cell.viewWithTag(102) as? UIImageView {
            logoImageView.image = UIImage.init(named: "default-placeholder")
            Alamofire.request(.GET, (self.events?[indexPath.item].iconURL)!).response { (request, response, data, error) in
                if error == nil && data != nil {
                    logoImageView.image = UIImage(data: data!, scale:1)
                }
            }
            
        }
        return cell
    }
    
    //MARK - PickerView Delegate and Datasource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.cities.count
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.cities[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.setCity(cities[row])
        self.pickerView.hidden = true
        self.loadEventsForPage("1")
    }
    
}

