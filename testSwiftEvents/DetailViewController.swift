//
//  DetailViewController.swift
//  testSwiftEvents
//
//  Created by Gabriela Pittari on 26/07/2016.
//  Copyright © 2016 Gabriela Pittari. All rights reserved.
//

import UIKit
import Gloss

class DetailViewController: UIViewController {

    var event : Event?
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var eventImage: UIImageView!
    @IBOutlet weak var eventDescTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(event!.name)")
        // Do any additional setup after loading the view.
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backButtonPressed(sender: AnyObject) {
    }

}
