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
   @IBOutlet weak var photoImage: UIImageView!
   @IBOutlet weak var dateLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   
   // MARK: - Properties
   var contractor: Contractor? {
      didSet {
         guard let contractor = contractor else { return }
         
         photoImage.image = UIImage(named: contractor.photo!)
         dateLabel.text = contractor.date?.to(format: "dd.MM.yyyy")
         nameLabel.text = contractor.name
         ratingImage.image = UIImage(named: contractor.rating ?? "Rating 0")
      }
   }

   // MARK: - Кнопки
   @IBAction func messageButton(_ sender: UIButton) {
      smsToPartner(contractor?.phoneNumber ?? "")
   }
   
   @IBAction func callButton(_ sender: UIButton) {
      callToPartner(contractor?.phoneNumber ?? "")
   }
   
   override func awakeFromNib() {
      super.awakeFromNib()
   }
   
   override func setSelected(_ selected: Bool, animated: Bool) {
      super.setSelected(selected, animated: animated)
   }
}
