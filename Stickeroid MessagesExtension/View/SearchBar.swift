//
//  SearchBar.swift
//  Stickeroid MessagesExtension
//
//  Created by Vadym Sidorov on 10/11/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit

class SearchBar: UISearchBar {
    
    override func awakeFromNib() {
        guard let textFieldInsideSearchBar = value(forKey: "searchField") as? UITextField else {
            return
        }
        
        textFieldInsideSearchBar.tintColor = UIConstants.StickeroidOrange
        textFieldInsideSearchBar.borderStyle = .none
        
        textFieldInsideSearchBar.layer.borderWidth = 1.0
        textFieldInsideSearchBar.layer.borderColor = UIColor.lightGray.cgColor
        textFieldInsideSearchBar.layer.backgroundColor = UIColor(red: 245.0/255.0, green: 245.0/255.0, blue: 245.0/255.0, alpha: 1.0).cgColor
        textFieldInsideSearchBar.layer.cornerRadius = 6.0
    }
}
