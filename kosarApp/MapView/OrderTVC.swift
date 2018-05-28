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
//var order = Order()

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
         priceTextField.resignFirstResponder()
         return true
      case locationTextField:
         userDefaults.set(locationTextField.text, forKey: "location")
         locationTextField.resignFirstResponder()
         return true
      case workAreaTextField:
         userDefaults.set(UInt(workAreaTextField.text!), forKey: "workArea")
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
   
   // MARK: - Присваивание значений из всех текстфилдов
   fileprivate func newData() {
      userDefaults.set(UInt(priceTextField.text!), forKey: "price")
      userDefaults.set(locationTextField.text, forKey: "location")
      userDefaults.set(UInt(workAreaTextField.text!), forKey: "workArea")
      //снимаем со всех текстфилдов первого ответчика, чтобы убрать клавиатуру
      priceTextField.resignFirstResponder()
      locationTextField.resignFirstResponder()
      workAreaTextField.resignFirstResponder()
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func orderElectricitySwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "electricity")
   }
   @IBAction func orderHardReliefSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "hardRelief")
   }
   @IBAction func orderPlantsSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "plants")
   }
   
   // MARK: - Присвоение location текущего местоположения
   @IBAction func userLocationButton(_ sender: UIButton) {
      let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(user.latitude!),
                                            longitude: CLLocationDegrees(user.longitude!))
      locationTextField.becomeFirstResponder()
      // после нажатия кнопочки надо обновить поле текстфилда
      locationTextField.text = reverseGeocodeCoordinate(position)
   }
   
   // MARK: - Подтверждение заявки
   @IBAction func orderConfirmButton(_ sender: UIButton) {
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
      alert(message: "Ваша заявка принята", currentVC: self)
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}
