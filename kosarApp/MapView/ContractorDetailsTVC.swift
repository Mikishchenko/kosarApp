//
//  ContractorDetailsTVC.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 17.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class ContractorDetailsTVC: UITableViewController {
   
   @IBOutlet weak var contractorImage: UIImageView!
   @IBOutlet weak var contractorPrice: UILabel!
   @IBOutlet weak var contractorName: UILabel!
   @IBOutlet weak var contractorRating: UIImageView!
   @IBOutlet weak var contractorDistance: UILabel!
   @IBOutlet weak var contractorInfo: UILabel!
   @IBOutlet weak var contractorConditions: UILabel!
   
   // MARK: - Имея userID текущего партнера, отображаем его параметры
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      let currentPartner = partners[partnerID ?? 0]
      contractorImage.image = UIImage(named: (currentPartner?.image!)!)
      contractorPrice.text = "\(String(describing: currentPartner?.price! ?? 0 ))"
      contractorName.text = currentPartner?.name
      contractorRating.image = UIImage(named: (currentPartner?.rating!)!)
      contractorDistance.text = "10.0" // ******* ЗАГЛУШКА *******
      contractorInfo.text = currentPartner?.info
      contractorConditions.text = (setConditions(currentPartner: currentPartner!)) 
      self.tableView.reloadData()
   }
   
   override func viewWillLayoutSubviews() {
      preferredContentSize = CGSize(width: self.view.bounds.width, height: tableView.contentSize.height)
   }
   
   //MARK: - Кнопки
   @IBAction func messageButton(_ sender: UIButton) {
      let currentPartner = partners[partnerID ?? 0]
      // добавляем партнера в историю
      addContractorInUserHistory(id: partnerID!, name: (currentPartner?.name)!, photo: (currentPartner?.image)!)
      print("Пользователь пытается отправить сообщение Контрагету")
   }
   
   @IBAction func callButton(_ sender: UIButton) {
      let currentPartner = partners[partnerID ?? 0]
      // добавляем партнера в историю
      addContractorInUserHistory(id: partnerID!, name: (currentPartner?.name)!, photo: (currentPartner?.image)!)
      print("Пользователь пытается дозвониться до Контрагета")
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}

