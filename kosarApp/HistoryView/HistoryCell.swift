//
//  HistoryCell.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 16.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class HistoryCell: UITableViewCell {
   
   // MARK: - IBOutlets
   @IBOutlet weak var photo: UIImageView!
   @IBOutlet weak var dateLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var rating: UIImageView!
   
   // MARK: - Properties
   var contractor: Contractor? {
      didSet {
         guard let contractor = contractor else { return }
         
         photo.image = UIImage(named: contractor.photo)
         dateLabel.text = contractor.date
         nameLabel.text = contractor.name
         rating.image = UIImage(named: contractor.rating)
      }
   }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
