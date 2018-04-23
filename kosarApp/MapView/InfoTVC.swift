//
//  InfoTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 11.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class InfoTableViewController: UITableViewController {
   
   @IBOutlet weak var infoWorkAreaLabel: UILabel!
   @IBOutlet weak var infoClientsLabel: UILabel!
   @IBOutlet weak var infoWorkersLabel: UILabel!
   @IBOutlet weak var infoMaxOrderPriceLabel: UILabel!
   @IBOutlet weak var infoMinOfferPriceLabel: UILabel!
   @IBOutlet weak var infoButtonLabel: UIButton!
   @IBOutlet weak var infoDeleteButtonLabel: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      infoWorkAreaLabel.text = "3"
      infoClientsLabel.text = "4"
      infoWorkersLabel.text = "4"
      infoMaxOrderPriceLabel.text = "250"
      infoMinOfferPriceLabel.text = "350"
      guard orderIsActive == false && offerIsActive == false else {
         fillButtonLabel(button: infoButtonLabel,
                         forClient: "Редактировать заявку", forWorker: "Редактировать объявление")
         fillButtonLabel(button: infoDeleteButtonLabel,
                         forClient: "Удалить заявку", forWorker: "Удалить объявление")
         return
      }
      fillButtonLabel(button: infoButtonLabel,
                      forClient: "Оформить заявку", forWorker: "Разместить объявление")
      infoAlertIsActive = true
   }
   
   // вроде не работает это плавное удаление окна
   override func viewWillDisappear(_ animated: Bool) {
      dismiss(animated: true, completion: nil)
   }
   
   // MARK: - Выбор надписи на кнопке в зависимости от типа (Заказчик или Исполнитель)
   func fillButtonLabel(button: UIButton, forClient: String, forWorker: String) {
      user.type == .client ?
         button.setTitle(forClient, for: .normal) :
         button.setTitle(forWorker, for: .normal)
   }
   
   // MARK: - Нажатие кнопки подтверждения/редактирования
   @IBAction func infoButton(_ sender: UIButton) {
      user.type == .client ?
         popoverVC(currentVC: self, identifierPopoverVC: "OrderTVC", heightPopoverVC: 254) :
         popoverVC(currentVC: self, identifierPopoverVC: "OfferTVC", heightPopoverVC: 254)
   }
   
   //MARK: - Нажатие кнопки удаления
   @IBAction func infoDeleteButton(_ sender: UIButton) {
      eraseOrderOffer()
      self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

// MARK: - Стирание заявки или объявления
public func eraseOrderOffer() {
   orderIsActive = false
   offerIsActive = false
   order = Order()
   offer = Offer()
}

// MARK: - Для корректной отработки всплывающих окон, иначе они растягиваются на весь экран
extension InfoTableViewController: UIPopoverPresentationControllerDelegate {
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
}
