//
//  ContactorInfoTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 17.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class ContactorInfoTableViewController: UITableViewController {

   @IBOutlet weak var contractorPrice: UILabel!
   @IBOutlet weak var contractorDistance: UILabel!
   @IBOutlet weak var contractorName: UILabel!
   @IBOutlet weak var contractorRating: UIImageView!
   @IBOutlet weak var contractorConditions: UILabel!
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      // MARK: - Имея userID текущего партнера, отображаем его параметры
      let currentPartner = partners[partnerID ?? 0]
      contractorPrice.text = "\(String(describing: currentPartner?.price! ?? 0 ))"
      contractorDistance.text = "10.0" // ******* ЗАГЛУШКА *******
      contractorName.text = currentPartner?.name
      contractorRating.image = UIImage(named: (currentPartner?.rating!)!)
      contractorConditions.text = setConditions(currentPartner: currentPartner!)
      self.tableView.reloadData()
   }
   
   // MARK: - Кнопки
   @IBAction func detailsButton(_ sender: UIButton) {
      popoverVC(currentVC: self, identifierPopoverVC: "ContractorDetailsTVC", heightPopoverVC: 236)
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

// MARK: - Добавление партнера в userHistory
func addContractorInUserHistory (id: userID, name: String, photo: String) {
   let contractor = Contractor(photo: photo, name: name, date: Date(timeIntervalSinceNow: 0), rating: nil, iD: id)
   userHistory.append(contractor)
   print(contractor.date)
}

// MARK: - Заполнение параметров у текущего партнера из данных его профиля
func setConditions(currentPartner: Partner) -> String {
   var conditions = ""
   conditions += (currentPartner.electricity! ? "220V |" : "")
   conditions += (currentPartner.equipment! ? " своё оборудование |" : "")
   conditions += (currentPartner.transport! ? " свой транспорт |" : " нужна доставка |")
   guard currentPartner.type == .client else { return conditions as String }
   conditions += (currentPartner.hardRelief! ? " сложный рельеф |" : "")
   conditions += (currentPartner.plants! ? " деревья на участке" : " пустой участок")
   return conditions as String
}
// это расширение необходимо для корректной отработки всплывающих окон, иначе они растягиваются на весь экран
extension ContactorInfoTableViewController: UIPopoverPresentationControllerDelegate {
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
}
