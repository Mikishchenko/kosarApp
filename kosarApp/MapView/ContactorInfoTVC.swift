//
//  ContactorInfoTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 17.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

class ContactorInfoTableViewController: UITableViewController {

   @IBOutlet weak var priceLabel: UILabel!
   @IBOutlet weak var distanceLabel: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   @IBOutlet weak var conditionsLabel: UILabel!
   
   let currentPartner = partners[partnerID ?? 0]
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      setCurrentPartnersParameters()
      self.tableView.reloadData()
   }
   
   // MARK: - Кнопки
   @IBAction func detailsButton(_ sender: UIButton) {
      popoverVC(currentVC: self, identifierPopoverVC: "ContractorDetailsTVC", heightPopoverVC: 236)
   }
   @IBAction func callButton(_ sender: UIButton) {
      // добавляем партнера в историю
      addContractorInUserHistory(id: partnerID!, name: (currentPartner?.name)!,
                                 photo: (currentPartner?.image)!)
      print("Пользователь пытается дозвониться до Контрагета")
      resignFirstResponder()
      dismiss(animated: true, completion: nil)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
   // MARK: - Имея userID текущего партнера, отображаем его параметры
   func setCurrentPartnersParameters() {
      priceLabel.text = String(describing: currentPartner?.price! ?? 0)
      distanceLabel.text = String(describing: currentPartner?.distance! ?? 0.0)
      nameLabel.text = currentPartner?.name
      ratingImage.image = UIImage(named: (currentPartner?.rating!)!)
      conditionsLabel.text = setConditions(currentPartner: currentPartner!)
   }
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

// MARK: - Добавление партнера в сущность Contractor
func addContractorInUserHistory (id: userID, name: String, photo: String) {
   // для каждого контрактора из истории проверяем   
   let sortedUserHistory = userHistory?.sorted {( $0.date! > $1.date! )}
   for index in sortedUserHistory! {
      print("\(index.iD) : \(String(describing: index.date!.to(format: "dd.MM.yyyy"))) -> \(id) : \(Date(timeIntervalSinceNow: 0).to(format: "dd.MM.yyyy"))")
      // если с НИМ ранее на контакт не выходили, идём дальше по циклу
      guard index.iD != id else {
         // или если контачили НЕ СЕГОДНЯ, завершаем цикл, иначе выходим из функции
         if index.date!.to(format: "dd.MM.yyyy") != Date(timeIntervalSinceNow: 0).to(format: "dd.MM.yyyy") {
            break
         } else { return }
      }
   }
   // добавляем в историю
   CoreDataHandler.saveObject(photo: photo, date: Date(timeIntervalSinceNow: 0),
                              rating: nil, name: name, iD: id)
}

// это расширение необходимо для корректной отработки всплывающих окон, иначе они растягиваются на весь экран
extension ContactorInfoTableViewController: UIPopoverPresentationControllerDelegate {
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
}
