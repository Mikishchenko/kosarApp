//
//  ProfileViewControllerTableViewController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 14.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

// MARK: - Установка первоначальных настроек профиля
var user = SampleData.generateUserData()

// место хранения всех значений профиля и настроек
let userDefaults = UserDefaults.standard

class ProfileTableController: UITableViewController, UITextFieldDelegate {
   
   // MARK: - Объекты, которые мы будем отображать
   @IBOutlet weak var clientWorkerSegment: UISegmentedControl!
   @IBOutlet weak var priceTextField: UITextField!
   @IBOutlet weak var nameTextField: UITextField!
   @IBOutlet weak var infoTextField: UITextField!
   @IBOutlet weak var locationTextField: UITextField!
   @IBOutlet weak var workAreaTextField: UITextField!
   @IBOutlet weak var electricitySwitch: UISwitch!
   @IBOutlet weak var equipmentSwitch: UISwitch!
   @IBOutlet weak var transportSwitch: UISwitch!
   @IBOutlet weak var hardReliefSwitch: UISwitch!
   @IBOutlet weak var plantsSwitch: UISwitch!
   
   // MARK: - Отображение:
   override func viewDidLoad() {
      super.viewDidLoad()
      // назначение уведомления на окончание редактирования в текстфилдах
      NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nameTextField)
      NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidEndEditing, object: infoTextField)
      // выставляем наблюдателя за нажатием userLocationButton
      NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextfield(notification:)),
                                             name: Notification.Name("userLocationButtonPressed"),
                                             object: nil)
   }
   // перезагрузка таблицы
   @objc func updateTextfield(notification: Notification){
      self.tableView.reloadData()
   }
   
   // MARK: - Текущие значения профиля
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)      
      // выбор сегмента (отображение текущей роли: Заказчик или Исполнитель)
      if let type = userDefaults.object(forKey: "type") {
         clientWorkerSegment.selectedSegmentIndex = type as! Int
      } else {
         clientWorkerSegment.selectedSegmentIndex = (user.type == .client ? 0 : 1)
      }
      // текстфилды
      setTextFieldValueAndDelegate(delegate: self, textField: priceTextField, key: "price")
      setTextFieldValueAndDelegate(delegate: self, textField: nameTextField, key: "name")
      setTextFieldValueAndDelegate(delegate: self, textField: infoTextField, key: "info")
      setTextFieldValueAndDelegate(delegate: self, textField: locationTextField, key: "location")
      setTextFieldValueAndDelegate(delegate: self, textField: workAreaTextField, key: "workArea")
      // переключатели
      setSwitchPosition(switcher: electricitySwitch, key: "electricity")
      setSwitchPosition(switcher: equipmentSwitch, key: "equipment")
      setSwitchPosition(switcher: transportSwitch, key: "transport")
      setSwitchPosition(switcher: hardReliefSwitch, key: "hardRelief")
      setSwitchPosition(switcher: plantsSwitch, key: "plants")
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
         return newIntForTextField(priceTextField, key: "price")
      case nameTextField:
         return newStringForTextField(nameTextField, key: "name")
      case infoTextField:
         return newStringForTextField(infoTextField, key: "info")
      case locationTextField:
         performGoogleSearch(for: locationTextField.text!)
         return newStringForTextField(locationTextField, key: "location")
      case workAreaTextField:
         return newIntForTextField(workAreaTextField, key: "workArea")
      default:
         return true
      }
   }

   // если хотя бы в одном поле нажать DONE, то сохраняются значения всех полей
   func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
      switch reason {
      case .committed:
         userDefaults.set(UInt(priceTextField.text!), forKey: "price")
         userDefaults.set(nameTextField.text, forKey: "name")
         userDefaults.set(infoTextField.text, forKey: "info")
         userDefaults.set(locationTextField.text, forKey: "location")
         userDefaults.set(UInt(workAreaTextField.text!), forKey: "workArea")
         userDefaults.synchronize()
         return
      case .cancelled:
         break
      }
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func clientWorkerSegment(_ sender: UISegmentedControl) {
      user.type = (sender.selectedSegmentIndex == 0 ? .client : .worker)
      userDefaults.set(sender.selectedSegmentIndex, forKey: "type")
      userDefaults.set(true, forKey: "typeChoiceIsDone")
      userDefaults.synchronize()
      // при смене типа пользователя, обнуляем заявки / объявления
      orderOfferIsActive = false
      typeChoiceIsDone = true
      tableView.reloadData() // обновление вида профиля после смены типа пользователя
   }
   @IBAction func electricitySwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "electricity")
      userDefaults.synchronize()
   }
   @IBAction func equipmentSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "equipment")
      userDefaults.synchronize()
   }
   @IBAction func transportSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "transport")
      userDefaults.synchronize()
   }
   @IBAction func hardReliefSwitcher(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "hardRelief")
      userDefaults.synchronize()
   }
   @IBAction func plantsSwitcher(_ sender: UISwitch) {
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
   
   // MARK: - Сокрытие некоторых элементов для пользователя Worker
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      guard user.type == .worker else { return 35.00 }
      guard indexPath.row != 5 else { return 0.00 }
      guard indexPath.row != 9 else { return 0.00 }
      guard indexPath.row != 10 else { return 0.00 }
      return 35.00
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

// MARK: - Обновление текстовых значений userDefault по ключу в указанном TextField
func newStringForTextField(_ textField: UITextField, key: String) -> Bool {
   userDefaults.set(textField.text, forKey: key)
   userDefaults.synchronize()
   textField.resignFirstResponder()
   return true
}

// MARK: - Обновление цифровых значений userDefault по ключу в указанном TextField
func newIntForTextField(_ textField: UITextField, key: String) -> Bool {
   userDefaults.set(UInt(textField.text!), forKey: key)
   userDefaults.synchronize()
   textField.resignFirstResponder()
   return true
}

// MARK: - Отображение текущего значения текстфилда и назначение делегата
public func setTextFieldValueAndDelegate(delegate: UITableViewController, textField: UITextField, key: String) {
   textField.delegate = delegate as? UITextFieldDelegate
   if let object = userDefaults.object(forKey: key){
      textField.text = "\(object)"
   } else {
      textField.text = ""
   }
}
