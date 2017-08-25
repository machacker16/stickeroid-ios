//
//  ViewController.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 7/29/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var resourceView: UIImageView!
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 250), animated: true)
        //scrollView.contentInset = UIEdgeInsetsMake(0, 0, 250, 0)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        scrollView.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
        //scrollView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
}

