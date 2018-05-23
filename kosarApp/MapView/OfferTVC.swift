//
//  OfferTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 11.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

// MARK: - Инициализаруем объявление
var offer = Offer()

class OfferTableViewController: UITableViewController, UITextFieldDelegate {
   
   @IBOutlet weak var priceTextField: UITextField!
   @IBOutlet weak var locationTextField: UITextField!
   @IBOutlet weak var infoTextField: UITextField!
   @IBOutlet weak var offerEquipmentSwitch: UISwitch!
   @IBOutlet weak var offerElectricitySwitch: UISwitch!
   @IBOutlet weak var offerTransportSwitch: UISwitch!
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // текстфилды
      setTextFieldValueAndDelegate(delegate: self, textField: priceTextField, key: "price")
      setTextFieldValueAndDelegate(delegate: self, textField: locationTextField, key: "location")
      setTextFieldValueAndDelegate(delegate: self, textField: infoTextField, key: "info")
      // переключатели
      setSwitchPosition(switcher: offerEquipmentSwitch, key: "equipment")
      setSwitchPosition(switcher: offerElectricitySwitch, key: "electricity")
      setSwitchPosition(switcher: offerTransportSwitch, key: "transport")
      
      orderOfferAlertIsActive = true
      NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextfield(notification:)),
                                             name: Notification.Name("userLocationButtonPressed"),
                                             object: nil)
   }
   // перезагрузка таблицы
   @objc func updateTextfield(notification: Notification){
      self.tableView.reloadData()
   }
   
   // MARK: - TextFieldDelegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      switch textField {
      case priceTextField:
         offer.price = UInt(priceTextField.text!)
         userDefaults.set(offer.price, forKey: "price")
         user.price = offer.price
         priceTextField.resignFirstResponder()
         return true
      case locationTextField:
         offer.location = locationTextField.text
         userDefaults.set(offer.location, forKey: "location")
         user.location = offer.location
         locationTextField.resignFirstResponder()
         return true
      case infoTextField:
         offer.info = infoTextField.text
         userDefaults.set(offer.info, forKey: "info")
         user.info = offer.info
         infoTextField.resignFirstResponder()
         return true
      default:
         return true
      }
   }
   
   func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      switch textField {
      case priceTextField:
         offer.price = UInt(priceTextField.text!)
         userDefaults.set(offer.price, forKey: "price")
         user.price = offer.price
         priceTextField.resignFirstResponder()
         return true
      case locationTextField:
         offer.location = locationTextField.text
         userDefaults.set(offer.location, forKey: "location")
         user.location = offer.location
         locationTextField.resignFirstResponder()
         return true
      case infoTextField:
         offer.info = infoTextField.text
         userDefaults.set(offer.info, forKey: "info")
         user.info = offer.info
         infoTextField.resignFirstResponder()
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
      offer.price = UInt(priceTextField.text!)
      offer.location = locationTextField.text
      offer.info = infoTextField.text
      user.price = offer.price
      user.location = offer.location
      user.info = offer.info
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func offerEquipmentSwitcher(_ sender: UISwitch) {
      offer.equipment = sender.isOn
      userDefaults.set(offer.equipment, forKey: "equipment")
   }
   @IBAction func offerElectricitySwitcher(_ sender: UISwitch) {
      offer.electricity = sender.isOn
      userDefaults.set(offer.electricity, forKey: "electricity")
   }
   @IBAction func offerTransportSwitcher(_ sender: UISwitch) {
      offer.transport = sender.isOn
      userDefaults.set(offer.transport, forKey: "transport")
   }
   
   // MARK: - Присвоение user.location текущего местоположения
   @IBAction func userLocationButton(_ sender: UIButton) {
      let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(user.latitude!),
                                            longitude: CLLocationDegrees(user.longitude!))
      reverseGeocodeCoordinate(position)
      // после нажатия кнопочки надо обновить поле текстфилда
      locationTextField.text = user.location
      NotificationCenter.default.post(name: Notification.Name("userLocationButtonPressed"),
                                      object: nil)
   }
   
   // MARK: Подтверждение оформления объявления
   @IBAction func offerConfirmButton(_ sender: UIButton) {
      newData() // дублируем присваивание на всякий пожарный
      //снимаем со всех текстфилдов первого ответчика, чтобы убрать клавиатуру
      priceTextField.resignFirstResponder()
      locationTextField.resignFirstResponder()
      infoTextField.resignFirstResponder()
      
      guard offer.price != nil else {
         alertWarning(emptyField: "Стоимость покоса", currentVC: self)
         return
      }
      guard offer.location != "" else {
         alertWarning(emptyField: "Адрес покоса", currentVC: self)
         return
      }
      alert(message: "Ваше объявление зарегистрировано", currentVC: self)
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

// MARK: - Сообщение о незаполненном обязательном поле
public func alertWarning(emptyField: String, currentVC: UIViewController) {
   let alert = UIAlertController(title: "НЕДОСТАТОЧНО ДАННЫХ",
                                 message: "Пожалуйста заполните поле \"\(emptyField)\"", preferredStyle: .alert)
   let orderAction = UIAlertAction(title: "OK", style: .cancel) { (action) in}
   alert.addAction(orderAction)
   currentVC.present(alert, animated: true, completion: nil)
}

// MARK: - Информационное сообщение
public func alert(message: String, currentVC: UIViewController) {
   let alert = UIAlertController(title: "ИНФОРМАЦИЯ", message: "\(message)", preferredStyle: .alert)
   let alertAction = UIAlertAction(title: "OK", style: .cancel) { (action) in
      orderOfferIsActive = true
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
   orderOfferAlertIsActive = false
}
