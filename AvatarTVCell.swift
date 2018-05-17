//
//  AvatarTableViewCell.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 16.05.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class AvatarTableViewCell: UITableViewCell {

   @IBOutlet weak var avatarCollectionView: UICollectionView!
   
   func setCollectionViewDelegate<D: UICollectionViewDelegate &
      UICollectionViewDataSource>(delegate: D, forRow row: Int) {
      avatarCollectionView.delegate = delegate
      avatarCollectionView.dataSource = delegate
      avatarCollectionView.reloadData()
   }
}
