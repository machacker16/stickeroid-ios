//
//  GCD.swift
//  Stickeroid
//
//  Created by Vadym Sidorov on 8/4/17.
//  Copyright © 2017 Vadym Sidorov. All rights reserved.
//

import Foundation

func performUIUpdatesOnMain(_ updates: @escaping () -> Void) {
    DispatchQueue.main.async {
        updates()
    }
}
