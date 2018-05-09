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

class ProfileTableController: UITableViewController, UITextFieldDelegate {
   
   // MARK: - Объекты, которые мы будем отображать
   @IBOutlet weak var clientWorker: UISegmentedControl!
   @IBOutlet weak var userPrice: UITextField!
   @IBOutlet weak var userName: UITextField!
   @IBOutlet weak var userInfo: UITextField!
   @IBOutlet weak var workLocation: UITextField!
   @IBOutlet weak var workArea: UITextField!
   @IBOutlet weak var electricitySwitch: UISwitch!
   @IBOutlet weak var equipmentSwitch: UISwitch!
   @IBOutlet weak var transportSwitch: UISwitch!
   @IBOutlet weak var hardReliefSwitch: UISwitch!
   @IBOutlet weak var plantsSwitch: UISwitch!
   
   // MARK: - Отображение:
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // MARK: - Текущие значения профиля
      
      // выбор сегмента (смена роли: Заказчик или Исполнитель)
      user.type == .client ? (clientWorker.selectedSegmentIndex = 0) : (clientWorker.selectedSegmentIndex = 1)
      // текстфилды
      setTextFieldValueAndDelegate(textField: userName, value: user.name)
      setTextFieldValueAndDelegate(textField: userInfo, value: user.info)
      setTextFieldValueAndDelegate(textField: workLocation, value: user.location)
      // обработка price и workArea: Int и перевод в String
      var userWorkPrice: String
      user.price != nil ? (userWorkPrice = "\(user.price!)") : (userWorkPrice = "")
      setTextFieldValueAndDelegate(textField: userPrice, value: userWorkPrice)
      var userWorkArea: String
      user.workArea != nil ? (userWorkArea = "\(user.workArea!)") : (userWorkArea = "")
      setTextFieldValueAndDelegate(textField: workArea, value: userWorkArea)
      // переключатели (функция лежит в SettingsTableController)
      setSwitchPosition(switcher: electricitySwitch, value: user.electricity)
      setSwitchPosition(switcher: equipmentSwitch, value: user.equipment)
      setSwitchPosition(switcher: transportSwitch, value: user.transport)
      setSwitchPosition(switcher: hardReliefSwitch, value: user.hardRelief)
      setSwitchPosition(switcher: plantsSwitch, value: user.plants)
      // назначение уведомления на окончание редактирования в текстфилдах
      NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidEndEditing, object: userName)
      NotificationCenter.default.post(name: NSNotification.Name.UITextFieldTextDidEndEditing, object: userInfo)
      // выставляем наблюдателя за нажатием userLocationButton
      NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextfield(notification:)),
                                             name: Notification.Name("userLocationButtonPressed"),
                                             object: user.location)
   }
   // перезагрузка таблицы
   @objc func updateTextfield(notification: Notification){
      workLocation.text = user.location
      self.tableView.reloadData()
   }

   // MARK: - Отображение текущего значения текстфилда и назначение делегата
   func setTextFieldValueAndDelegate(textField: UITextField, value: String?) {
      textField.text = value
      textField.delegate = self
   }
   
   // MARK: - TextFieldDelegate
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      switch textField {
      case workArea:
         user.price = UInt(userPrice.text!)
         userPrice.resignFirstResponder()
         return true
      case userName:
         user.name = userName.text
         userName.resignFirstResponder()
         return true
      case userInfo:
         user.info = userInfo.text
         userInfo.resignFirstResponder()
         return true
      case workLocation:
         user.location = workLocation.text
         workLocation.resignFirstResponder()
         return true
      case workArea:
         user.workArea = UInt(workArea.text!)
         workArea.resignFirstResponder()
         return true
      default:
         return true
      }
   }
   
   // если хотя бы в одном поле нажать DONE, то сохраняются значения всех полей
   func textFieldDidEndEditing(_ textField: UITextField, reason: UITextFieldDidEndEditingReason) {
      switch reason {
      case .committed:
         user.price = UInt(userPrice.text!)
         user.name = userName.text
         user.info = userInfo.text
         user.location = workLocation.text
         user.workArea = UInt(workArea.text!)
         return
      case .cancelled:
         break
      }
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func clientWorkerSegment(_ sender: UISegmentedControl) {
      sender.selectedSegmentIndex == 0 ? (user.type = .client) : (user.type = .worker)
      // при смене типа пользователя, обнуляем заявки / объявления
      eraseOrderOffer()
      typeChoiceIsDone = true
      tableView.reloadData() // обновление вида профиля после смены типа пользователя
   }
   @IBAction func electricitySwitcher(_ sender: UISwitch) {
      sender.isOn ? (user.electricity = true) : (user.electricity = false)
   }
   @IBAction func equipmentSwitcher(_ sender: UISwitch) {
      sender.isOn ? (user.equipment = true) : (user.equipment = false)
   }
   @IBAction func transportSwitcher(_ sender: UISwitch) {
      sender.isOn ? (user.transport = true) : (user.transport = false)
   }
   @IBAction func hardReliefSwitcher(_ sender: UISwitch) {
      sender.isOn ? (user.hardRelief = true) : (user.hardRelief = false)
   }
   @IBAction func plantsSwitcher(_ sender: UISwitch) {
      sender.isOn ? (user.plants = true) : (user.plants = false)
   }
   
   // MARK: - Присвоение user.location текущего местоположения
   @IBAction func userLocationButton(_ sender: UIButton) {
      let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(user.latitude!),
                                            longitude: CLLocationDegrees(user.longitude!))
      reverseGeocodeCoordinate(position)
      // после нажатия кнопочки надо обновить поле текстфилда
      NotificationCenter.default.post(name: Notification.Name("userLocationButtonPressed"),
                                      object: user.location)
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
