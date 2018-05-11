//
//  InfoTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 11.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

class InfoTableViewController: UITableViewController {
   
   @IBOutlet weak var infoWorkAreaLabel: UILabel!
   @IBOutlet weak var infoClientsLabel: UILabel!
   @IBOutlet weak var infoWorkersLabel: UILabel!
   @IBOutlet weak var infoAvPriceLabel: UILabel!
   @IBOutlet weak var infoButtonLabel: UIButton!
   @IBOutlet weak var extensionWorkAreaOrDeleteButton: UIButton!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // получение данных информационного сообщения
      var clietnsInSearch: UInt = 0, workersInSearch: UInt = 0
      var sumOrdersPrice: UInt = 0, sumOffersPrice: UInt = 0
      for partner in partners {
         // сортировка по значению диапозона поиска
         guard partner.value.distance! <= searchArea else { continue }
         switch partner.value.type {
         case .client:
            clietnsInSearch += 1
            sumOrdersPrice += partner.value.price!
         case .worker:
            workersInSearch += 1
            sumOffersPrice += partner.value.price!
         }
      }
      // заполнение данных Информационного сообщения
      infoWorkAreaLabel.text = String(searchArea)
      infoClientsLabel.text = String(clietnsInSearch)
      infoWorkersLabel.text = String(workersInSearch)
      // проверка на нулевые значения clietnsInSearch и workersInSearch
      (clietnsInSearch == 0 || workersInSearch == 0) ?
         (infoAvPriceLabel.text = "не известны") :
         (infoAvPriceLabel.text = String(sumOrdersPrice / clietnsInSearch) + " - " + String(sumOffersPrice / workersInSearch) + " руб/сотка")
      // формирование внешнего вида Информационного сообщения (варианты надписей на кнопках)
      if orderOfferIsActive {
         fillButtonLabel(button: infoButtonLabel,
                         forClient: "Редактировать заявку", forWorker: "Редактировать объявление")
         fillButtonLabel(button: extensionWorkAreaOrDeleteButton,
                         forClient: "Удалить заявку", forWorker: "Удалить объявление")
         return
      } else {
         fillButtonLabel(button: infoButtonLabel,
                         forClient: "Оформить заявку", forWorker: "Разместить объявление")
         fillButtonLabel(button: extensionWorkAreaOrDeleteButton,
                         forClient: "Расширить зону поиска", forWorker: "Расширить зону поиска")
         infoAlertIsActive = true
      }
   }
   
   // MARK: - Выбор надписи на кнопке в зависимости от типа (Заказчик или Исполнитель)
   func fillButtonLabel(button: UIButton, forClient: String, forWorker: String) {
      user.type == .client ?
         button.setTitle(forClient, for: .normal) :
         button.setTitle(forWorker, for: .normal)
   }
   
   // MARK: - Нажатие кнопки подтверждения/редактирования Заявки/Объявления
   @IBAction func infoButton(_ sender: UIButton) {
      user.type == .client ?
         popoverVC(currentVC: self, identifierPopoverVC: "OrderTVC", heightPopoverVC: 254) :
         popoverVC(currentVC: self, identifierPopoverVC: "OfferTVC", heightPopoverVC: 254)
   }
   
   //MARK: - Нажатие кнопки удаления Заявки-Объявления или Расширения зоны поиска
   @IBAction func extensionWorkAreaOrDeleteButton(_ sender: UIButton) {
      switch orderOfferIsActive{
      case true:
         eraseOrderOffer()
         self.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
      case false:
         searchArea += 10.0
         zoomLevel -= 1.0
         dismiss(animated: true, completion: nil)
      }
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

// MARK: - Стирание заявки или объявления
public func eraseOrderOffer() {
   orderOfferIsActive = false
   order = Order()
   offer = Offer()
}

// MARK: - Для корректной отработки всплывающих окон, иначе они растягиваются на весь экран
extension InfoTableViewController: UIPopoverPresentationControllerDelegate {
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
}
