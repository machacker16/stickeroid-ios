//
//  MessagesViewController.swift
//  Stickeroid MessagesExtension
//
//  Created by Vadym Sidorov on 9/13/18.
//  Copyright © 2018 Vadym Sidorov. All rights reserved.
//

import UIKit
import Messages

class MessagesViewController: MSMessagesAppViewController, UICollectionViewDataSource, UICollectionViewDelegate, UISearchBarDelegate {
    
    var lastQueryStickerUrls: [StickerURL]?
    
    @IBOutlet weak var stickerCollectionView: UICollectionView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        setupCollectionView()
        performSearch(searchQuery: Constants.DefaultRequestQuery)
    }
    
    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        if presentationStyle == .expanded {
            searchBar.becomeFirstResponder()
        }
    }
    
    override func willBecomeActive(with conversation: MSConversation) {
        
    }
    
    func setupCollectionView() {
        stickerCollectionView.register(UINib(nibName: "StickerCell", bundle: .main), forCellWithReuseIdentifier: UIConstants.CellReusabilityIdentifier)
        stickerCollectionView.dataSource = self
        stickerCollectionView.delegate = self
    }
    
    func performSearch(searchQuery: String) {
        lastQueryStickerUrls = nil
        stickerCollectionView.reloadData()
        
        Request.getStickerURLsFor(searchQuery: searchQuery,
                                  numberOfStickers: RequestConstants.ItemsPerRequest) { [weak self] (_ urls: [StickerURL]) in
                                    self?.lastQueryStickerUrls = urls
                                    
                                    DispatchQueue.main.async { [weak self] in
                                        self?.stickerCollectionView.reloadData()
                                    }
        }
    }
}

extension MessagesViewController {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        requestPresentationStyle(.expanded)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let query = searchBar.text {
            performSearch(searchQuery: query)
        }
    }
}
