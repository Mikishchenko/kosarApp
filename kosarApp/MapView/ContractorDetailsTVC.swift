//
//  ContractorDetailsTVC.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 17.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps
import MessageUI

class ContractorDetailsTVC: UITableViewController {
   
   @IBOutlet weak var photoImage: UIImageView!
   @IBOutlet weak var priceLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   @IBOutlet weak var distanceLabel: UILabel!
   @IBOutlet weak var infoLabel: UILabel!
   @IBOutlet weak var conditionsLabel: UILabel!
   
   let currentPartner = partners[partnerID ?? 0]
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.isScrollEnabled = false
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      setCurrentPartnersParameters()
      self.tableView.reloadData()
   }
   
   override func viewWillLayoutSubviews() {
      preferredContentSize = CGSize(width: self.view.bounds.width, height: tableView.contentSize.height)
   }
   
   //MARK: - Кнопки
   
   @IBAction func messageButton(_ sender: UIButton) {
      smsToPartner("1111111111", currentPartner: currentPartner!, currentVC: self)
   }
   
   @IBAction func callButton(_ sender: UIButton) {
      // дозваниваемся до контрагента
      callToPartner("1111111111", currentPartner: currentPartner!, currentVC: self)
   }
   
   // MARK: - Имея userID текущего партнера, отображаем его параметры
   fileprivate func setCurrentPartnersParameters() {
      photoImage.image = UIImage(named: (currentPartner?.image!)!)
      priceLabel.text = String(describing: currentPartner?.price! ?? 0)
      nameLabel.text = currentPartner?.name
      ratingImage.image = UIImage(named: (currentPartner?.rating!)!)
      distanceLabel.text = String(describing: currentPartner?.distance! ?? 0.0)
      infoLabel.text = currentPartner?.info
      conditionsLabel.text = (setConditions(currentPartner: currentPartner!))
   }
}

// MARK: - Отправляем смс контрагенту
func smsToPartner(_ number: String, currentPartner: Partner, currentVC: UITableViewController) {
   let url = URL(string: "sms://\(number)")!
   if UIApplication.shared.canOpenURL(url) {
      UIApplication.shared.open(url)
   }
   print("Пользователь пытается отправить смс Контрагету")
   // добавляем партнера в историю
   addContractorInUserHistory(id: partnerID!, name: (currentPartner.name)!,
                              photo: (currentPartner.image)!)
   currentVC.resignFirstResponder()
   currentVC.dismiss(animated: true, completion: nil)
}

