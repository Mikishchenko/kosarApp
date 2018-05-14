//
//  ContractorDetailsTVC.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 17.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

class ContractorDetailsTVC: UITableViewController {
   
   @IBOutlet weak var photoImage: UIImageView!
   @IBOutlet weak var priceLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   @IBOutlet weak var distanceLabel: UILabel!
   @IBOutlet weak var infoLabel: UILabel!
   @IBOutlet weak var conditionsLabel: UILabel!
   
   let currentPartner = partners[partnerID ?? 0]
   
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
      // добавляем партнера в историю
      addContractorInUserHistory(id: partnerID!, name: (currentPartner?.name)!,
                                 photo: (currentPartner?.image)!)
      print("Пользователь пытается отправить сообщение Контрагету")
   }
   
   @IBAction func callButton(_ sender: UIButton) {
      // добавляем партнера в историю
      addContractorInUserHistory(id: partnerID!, name: (currentPartner?.name)!,
                                 photo: (currentPartner?.image)!)
      print("Пользователь пытается дозвониться до Контрагета")
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
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}

