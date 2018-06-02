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
//var offer = Offer()

class OfferTableViewController: UITableViewController, UITextFieldDelegate {
   
   @IBOutlet weak var priceTextField: UITextField!
   @IBOutlet weak var locationTextField: UITextField!
   @IBOutlet weak var infoTextField: UITextField!
   @IBOutlet weak var offerEquipmentSwitch: UISwitch!
   @IBOutlet weak var offerElectricitySwitch: UISwitch!
   @IBOutlet weak var offerTransportSwitch: UISwitch!
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.isScrollEnabled = false
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
      return newDataForEveryTextField(textField)
   }
   
   func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      return newDataForEveryTextField(textField)
   }
   
   // обновление значений userDefaults из каждого текстфилда
   func newDataForEveryTextField(_ textField: UITextField) -> Bool {
      switch textField {
      case priceTextField:
         userDefaults.set(UInt(priceTextField.text!), forKey: "price")
         userDefaults.synchronize()
         priceTextField.resignFirstResponder()
         return true
      case locationTextField:
         performGoogleSearch(for: locationTextField.text!)
         userDefaults.set(locationTextField.text, forKey: "location")
         userDefaults.synchronize()
         locationTextField.resignFirstResponder()
         return true
      case infoTextField:
         userDefaults.set(infoTextField.text, forKey: "info")
         userDefaults.synchronize()
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
      userDefaults.set(UInt(priceTextField.text!), forKey: "price")
      userDefaults.set(locationTextField.text, forKey: "location")
      userDefaults.set(infoTextField.text, forKey: "info")
      userDefaults.synchronize()
      //снимаем со всех текстфилдов первого ответчика, чтобы убрать клавиатуру
      priceTextField.resignFirstResponder()
      locationTextField.resignFirstResponder()
      infoTextField.resignFirstResponder()
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func offerEquipmentSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "equipment")
      userDefaults.synchronize()
   }
   @IBAction func offerElectricitySwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "electricity")
      userDefaults.synchronize()
   }
   @IBAction func offerTransportSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "transport")
      userDefaults.synchronize()
   }
   
   // MARK: - Присвоение location текущего местоположения
   @IBAction func userLocationButton(_ sender: UIButton) {
      customLocation = false
      let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(userDefaults.object(forKey:
                                             "currentLatitude") as! Double),
                                            longitude: CLLocationDegrees(userDefaults.object(forKey:
                                             "currentLongitude") as! Double))
      locationTextField.becomeFirstResponder()
      // после нажатия кнопочки надо обновить поле текстфилда
      locationTextField.text = reverseGeocodeCoordinate(position)
   }
   
   // MARK: Подтверждение оформления объявления
   @IBAction func offerConfirmButton(_ sender: UIButton) {
      newData() // дублируем присваивание на всякий пожарный
      // проверяем заполнение обязательных полей
      guard UInt(priceTextField.text!) != nil else {
         alertWarning(emptyField: "Стоимость покоса", currentVC: self)
         return
      }
      guard locationTextField.text != "" else {
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
