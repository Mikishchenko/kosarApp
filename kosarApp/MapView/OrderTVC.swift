//
//  OrderTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 09.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

// MARK: - Инициализаруем заявку
var order = Order()

class OrderTableViewController: UITableViewController, UITextFieldDelegate {
   
   @IBOutlet weak var priceTextField: UITextField!
   @IBOutlet weak var locationTextField: UITextField!
   @IBOutlet weak var workAreaTextField: UITextField!
   @IBOutlet weak var orderElectricitySwitch: UISwitch!
   @IBOutlet weak var orderHardReliefSwitch: UISwitch!
   @IBOutlet weak var orderPlantsSwitch: UISwitch!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // текстфилды
      setTextFieldValueAndDelegate(delegate: self, textField: priceTextField, key: "price")
      setTextFieldValueAndDelegate(delegate: self, textField: locationTextField, key: "location")
      setTextFieldValueAndDelegate(delegate: self, textField: workAreaTextField, key: "workArea")
      // переключатели
      setSwitchPosition(switcher: orderElectricitySwitch, key: "electricity")
      setSwitchPosition(switcher: orderHardReliefSwitch, key: "hardRelief")
      setSwitchPosition(switcher: orderPlantsSwitch, key: "plants")
      
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
         order.price = UInt(priceTextField.text!)
         userDefaults.set(order.price, forKey: "price")
         user.price = order.price
         priceTextField.resignFirstResponder()
         return true
      case locationTextField:
         order.location = locationTextField.text
         userDefaults.set(order.location, forKey: "location")
         user.location = order.location
         locationTextField.resignFirstResponder()
         return true
      case workAreaTextField:
         order.workArea = UInt(workAreaTextField.text!)
         userDefaults.set(order.workArea, forKey: "workArea")
         user.workArea = order.workArea
         workAreaTextField.resignFirstResponder()
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
      order.price = UInt(priceTextField.text!)
      order.location = locationTextField.text
      order.workArea = UInt(workAreaTextField.text!)
      user.price = order.price
      user.location = order.location
      user.workArea = order.workArea
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func orderElectricitySwitcher(_ sender: UISwitch) {
      order.electricity = sender.isOn
      userDefaults.set(order.electricity, forKey: "electricity")
   }
   @IBAction func orderHardReliefSwitcher(_ sender: UISwitch) {
      order.hardRelief = sender.isOn
      userDefaults.set(order.hardRelief, forKey: "hardRelief")
   }
   @IBAction func orderPlantsSwitcher(_ sender: UISwitch) {
      order.plants = sender.isOn
      userDefaults.set(order.plants, forKey: "plants")
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
   
   // MARK: - Подтверждение заявки
   @IBAction func orderConfirmButton(_ sender: UIButton) {
      newData() // дублируем присваивание на всякий пожарный
      //снимаем со всех текстфилдов первого ответчика, чтобы убрать клавиатуру
      priceTextField.resignFirstResponder()
      locationTextField.resignFirstResponder()
      workAreaTextField.resignFirstResponder()
      
      guard order.price != nil else {
         warningAlert(emptyField: "Стоимость покоса", currentVC: self)
         return
      }
      guard order.location != "" else {
         warningAlert(emptyField: "Адрес покоса", currentVC: self)
         return
      }
      alert(message: "Ваша заявка принята", currentVC: self)
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}
