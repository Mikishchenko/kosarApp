//
//  OfferTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 11.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

// MARK: - Инициализаруем объявление
var offer = Offer()

class OfferTableViewController: UITableViewController, UITextFieldDelegate {
   
   @IBOutlet weak var offerPrice: UITextField!
   @IBOutlet weak var offerWorkLocation: UITextField!
   @IBOutlet weak var offerWorkerInfo: UITextField!
   @IBOutlet weak var offerEquipmentSwitch: UISwitch!
   @IBOutlet weak var offerElectricitySwitch: UISwitch!
   @IBOutlet weak var offerTransportSwitch: UISwitch!
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // текстфилды
      var offerPriceString: String
      offer.price != nil ? (offerPriceString = "\(offer.price!)") : (offerPriceString = "")
      setTextFieldValueAndDelegate(textField: offerPrice, value: offerPriceString)
      setTextFieldValueAndDelegate(textField: offerWorkLocation, value: offer.workLocation)
      setTextFieldValueAndDelegate(textField: offerWorkerInfo, value: offer.workerInfo)
      
      // переключатели (функция лежит в SettingsTableController)
      setSwitchPosition(switcher: offerEquipmentSwitch, value: offer.equipment)
      setSwitchPosition(switcher: offerElectricitySwitch, value: offer.electricity)
      setSwitchPosition(switcher: offerTransportSwitch, value: offer.transport)
      
      offerAlertIsActive = true
   }
   
   // MARK: - Отображение текущего значения текстфилда и назначение делегата
   func setTextFieldValueAndDelegate(textField: UITextField, value: String?) {
      textField.text = value
      textField.delegate = self
   }
   
   // MARK: - TextFieldDelegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      switch textField {
      case offerPrice:
         offer.price = Int(offerPrice.text!)
         offerPrice.resignFirstResponder()
         return true
      case offerWorkLocation:
         offer.workLocation = offerWorkLocation.text
         offerWorkLocation.resignFirstResponder()
         return true
      case offerWorkerInfo:
         offer.workerInfo = offerWorkerInfo.text
         offerWorkerInfo.resignFirstResponder()
         return true
      default:
         return true
      }
   }
   
   // MARK: - Если хотя бы в одном поле нажать DONE, то сохраняются значения всех полей
   func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
      switch reason {
      case .committed:
         newData()
         return
      case .cancelled:
         break
      }
   }
   
   // MARK: - Присваивание значений из текстфилдов
   fileprivate func newData() {
      offer.price = Int(offerPrice.text!)
      offer.workLocation = offerWorkLocation.text
      offer.workerInfo = offerWorkerInfo.text
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func offerEquipmentSwitcher(_ sender: UISwitch) {
      sender.isOn ? (offer.equipment = true) : (offer.equipment = false)
   }
   @IBAction func offerElectricitySwitcher(_ sender: UISwitch) {
      sender.isOn ? (offer.electricity = true) : (offer.electricity = false)
   }
   @IBAction func offerTransportSwitcher(_ sender: UISwitch) {
      sender.isOn ? (offer.transport = true) : (offer.transport = false)
   }
   
   // MARK: Подтверждение оформления объявления
   @IBAction func offerConfirmButton(_ sender: UIButton) {
      newData() // дублируем присваивание на всякий пожарный
      //снимаем со всех текстфилдов первого ответчика, чтобы убрать клавиатуру
      offerPrice.resignFirstResponder()
      offerWorkLocation.resignFirstResponder()
      offerWorkerInfo.resignFirstResponder()
      
      guard offer.price != nil else {
         warningAlert(emptyField: "Стоимость покоса", currentVC: self)
         return
      }
      guard offer.workLocation != "" else {
         warningAlert(emptyField: "Адрес покоса", currentVC: self)
         return
      }
      alert(message: "Ваше объявление зарегистрировано", currentVC: self, orderOrOfferWillActive: offerIsActive)
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

// MARK: - Сообщение о незаполненном обязательном поле
public func warningAlert(emptyField: String, currentVC: UIViewController) {
   let alert = UIAlertController(title: "НЕДОСТАТОЧНО ДАННЫХ",
                                 message: "Пожалуйста заполните поле \"\(emptyField)\"", preferredStyle: .alert)
   let orderAction = UIAlertAction(title: "OK", style: .cancel) { (action) in}
   alert.addAction(orderAction)
   currentVC.present(alert, animated: true, completion: nil)
}

// MARK: - Информационное сообщение
public func alert(message: String, currentVC: UIViewController, orderOrOfferWillActive: Bool) {
   let alert = UIAlertController(title: "ИНФОРМАЦИЯ", message: "\(message)", preferredStyle: .alert)
   let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
      orderOrOfferWillActive == offerIsActive ? (offerIsActive = true) : (orderIsActive = true)
      infoAlertsOff()
      // убирает с текущего viewController все контроллеры, лежащие сверху
      currentVC.view.window?.rootViewController?.dismiss(animated: true, completion: nil)
   }
   alert.addAction(alertAction)
   currentVC.present(alert, animated: true, completion: nil)
}

// MARK: - Выключение всех инфо контроллеров
public func infoAlertsOff () {
   infoAlertIsActive = false
   orderAlertIsActive = false
   offerAlertIsActive = false
}
