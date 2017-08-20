//
//  ViewController.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 7/29/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var resourceView: UIImageView!

    let requestInstance = STRequest()
    
    @IBAction func performResourceSearch(_ sender: UITextField) {
        guard let searchQuery = sender.text else {
            print("Search query is nil.")
            return
        }
        
        requestInstance.getResourceWithSearchQuery(searchQuery) { (data) in
            performUIUpdatesOnMain {
                self.resourceView.image = UIImage(data: data!)
            }
        }
    }
    
    @IBAction func requestNextResource(_ sender: UIButton) {
        requestInstance.getNextResourceFromLastSession {data in
            performUIUpdatesOnMain {
                self.resourceView.image = UIImage(data: data!)
            }
        }
    }

}

