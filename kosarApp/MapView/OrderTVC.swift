//
//  OrderTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 09.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

class OrderTableViewController: UITableViewController, UITextFieldDelegate {
   
   @IBOutlet weak var phoneNumberTextField: UITextField!
   @IBOutlet weak var priceTextField: UITextField!
   @IBOutlet weak var locationTextField: UITextField!
   @IBOutlet weak var workAreaTextField: UITextField!
   @IBOutlet weak var orderElectricitySwitch: UISwitch!
   @IBOutlet weak var orderHardReliefSwitch: UISwitch!
   @IBOutlet weak var orderPlantsSwitch: UISwitch!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      tableView.isScrollEnabled = false
      // текстфилды
      setTextFieldValueAndDelegate(delegate: self, textField: phoneNumberTextField, key: "phoneNumber")
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
      tableView.reloadData()
      return newDataForEveryTextField(textField)
   }
   func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      tableView.reloadData()
      return newDataForEveryTextField(textField)
   }
   
   // обновление значений userDefaults из каждого текстфилда
   func newDataForEveryTextField(_ textField: UITextField) -> Bool {
      switch textField {
      case phoneNumberTextField:
         guard validate(value: textField.text!) else {
            phoneNumberValidInfoAlert(currentVC: self)
            return false
         }
         return newStringForTextField(phoneNumberTextField, key: "phoneNumber")
      case priceTextField:
         return newIntForTextField(priceTextField, key: "price")
      case locationTextField:
         performGoogleSearch(for: locationTextField.text!)
         return newStringForTextField(locationTextField, key: "location")
      case workAreaTextField:
         return newIntForTextField(workAreaTextField, key: "workArea")
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
      userDefaults.set(phoneNumberTextField.text, forKey: "phoneNumber")
      userDefaults.set(UInt(priceTextField.text!), forKey: "price")
      userDefaults.set(locationTextField.text, forKey: "location")
      userDefaults.set(UInt(workAreaTextField.text!), forKey: "workArea")
      userDefaults.synchronize()
      //снимаем со всех текстфилдов первого ответчика, чтобы убрать клавиатуру
      phoneNumberTextField.resignFirstResponder()
      priceTextField.resignFirstResponder()
      locationTextField.resignFirstResponder()
      workAreaTextField.resignFirstResponder()
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func orderElectricitySwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "electricity")
      userDefaults.synchronize()
   }
   @IBAction func orderHardReliefSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "hardRelief")
      userDefaults.synchronize()
   }
   @IBAction func orderPlantsSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "plants")
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
   
   // MARK: - Подтверждение заявки
   @IBAction func orderConfirmButton(_ sender: UIButton) {
      newData() // дублируем присваивание на всякий пожарный
      // проверяем заполнение обязательных полей
      guard phoneNumberTextField.text != nil else {
         alertWarning(emptyField: "Телефон для связи", currentVC: self)
         return
      }
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
