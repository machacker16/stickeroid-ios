//
//  SearchField.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 9/23/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import UIKit

class SearchField: UITextField {
    
    private let textEdgeInsets = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textEdgeInsets)
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textEdgeInsets)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return UIEdgeInsetsInsetRect(bounds, textEdgeInsets)
    }
    
}
