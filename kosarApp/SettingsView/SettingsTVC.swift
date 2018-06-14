//
//  SettingsTableController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 17.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class SettingsTableController: UITableViewController, UITextFieldDelegate {
   
   // MARK: - Объекты, которые мы будем отображать
   @IBOutlet weak var geopositionSwitch: UISwitch!
   @IBOutlet weak var phoneNumberTextField: UITextField!
   @IBOutlet weak var phoneSwitch: UISwitch!
   @IBOutlet weak var messagesSwitch: UISwitch!
   @IBOutlet weak var photosSwitch: UISwitch!
   @IBOutlet weak var cameraSwitch: UISwitch!
   @IBOutlet weak var microphoneSwitch: UISwitch!
   @IBOutlet weak var resetUserDefaultsData: UIButton!
   
   // MARK: - Отображение текстфилдов и кнопки сброса настроек
   override func viewDidLoad() {
      super.viewDidLoad()
      // у красной кнопки скруглённые углы
      resetUserDefaultsData.layer.cornerRadius = 12
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      // текущие значения настроек
      setSwitchPosition(switcher: geopositionSwitch, key: "geoposition")
      setTextFieldValueAndDelegate(delegate: self, textField: phoneNumberTextField, key: "phoneNumber")
      setSwitchPosition(switcher: phoneSwitch, key: "phone")
      setSwitchPosition(switcher: messagesSwitch, key: "messages")
      setSwitchPosition(switcher: photosSwitch, key: "photos")
      setSwitchPosition(switcher: cameraSwitch, key: "camera")
      setSwitchPosition(switcher: microphoneSwitch, key: "microphone")
   }
   
   // MARK: - TextFieldDelegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      guard validate(value: textField.text!) else {
         phoneNumberValidInfoAlert(currentVC: self)
         return false
      }
      return newStringForTextField(phoneNumberTextField, key: "phoneNumber")
   }
   func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
      guard validate(value: textField.text!) else {
         phoneNumberValidInfoAlert(currentVC: self)
         return false
      }
      return newStringForTextField(phoneNumberTextField, key: "phoneNumber")
   }
   
   // MARK: - Присваивание новых значений при переключении переключателей и указание телефонного номера
   @IBAction func geoposition(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "geoposition")
      userDefaults.synchronize()
   }
   @IBAction func phone(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "phone")
      userDefaults.synchronize()
      tableView.reloadData()
      if sender.isOn { phoneNumberInfoAler(currentVC: self) }
   }
   @IBAction func messages(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "messages")
      userDefaults.synchronize()
      tableView.reloadData()
      if sender.isOn { phoneNumberInfoAler(currentVC: self) }
   }
   
   @IBAction func photos(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "photos")
      userDefaults.synchronize()
   }
   @IBAction func camera(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "camera")
      userDefaults.synchronize()
   }
   @IBAction func microphone(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "microphone")
      userDefaults.synchronize()
   }
   
   // MARK: - Сброс всех настроек из userDefaults
   @IBAction func resetUserDefaultsData(_ sender: UIButton) {
      let defaults = UserDefaults.standard
      let dictionary = defaults.dictionaryRepresentation()
      dictionary.keys.forEach { key in
         defaults.removeObject(forKey: key)
      }
      userDefaults.synchronize()
      tableView.reloadData()
   }
   
   // MARK: - Сокрытие поля с телефонным номером, если нет разрешения на использование телефона или сообщений
   override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
      guard (userDefaults.object(forKey: "phone") as? Bool ?? false) == false &&
            (userDefaults.object(forKey: "messages") as? Bool ?? false) == false
         else { return 35.00 }
      guard indexPath.row != 1 else { return 0.00 }
      return 35.00
   }

   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

// MARK: - Информационное сообщение, предлагающее указать свой телефонный номер КОРРЕКТНО
func phoneNumberValidInfoAlert(currentVC: UIViewController) {
   alertSimpleInfo(message: "Пожалуйста, укажите Ваш телефонный номер корректно (например: +70123456789).", currentVC: currentVC)
}

// MARK: - Информационное сообщение, предлагающее указать свой телефонный номер
func phoneNumberInfoAler(currentVC: UIViewController) {
   alertSimpleInfo(message: "Пожалуйста, укажите Ваш телефонный номер\n(например: +70123456789).\nДругие пользователи смогу с Вами связаться.", currentVC: currentVC)
}

//MARK: - Показывает текущее значение переключателя
public func setSwitchPosition(switcher: UISwitch, key: String) {
   if let object = userDefaults.object(forKey: key) as? Bool {
      switcher.setOn(object, animated: false)
   } else {
      switcher.setOn(false, animated: false)
   }
}

// MARK: - Проверка корректности телефонного номера
public func validate(value: String) -> Bool {
   let PHONE_REGEX = "^((\\+)|(00))[0-9]{11,11}$"
   let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
   let result =  phoneTest.evaluate(with: value)
   return result
}
