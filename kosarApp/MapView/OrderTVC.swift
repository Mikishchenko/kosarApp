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
   
   @IBOutlet weak var orderPrice: UITextField!
   @IBOutlet weak var orderWorkLocation: UITextField!
   @IBOutlet weak var orderWorkArea: UITextField!
   @IBOutlet weak var orderElectricitySwitch: UISwitch!
   @IBOutlet weak var orderHardReliefSwitch: UISwitch!
   @IBOutlet weak var orderPlantsSwitch: UISwitch!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // текстфилды
      var orderPriceString: String
      user.price != nil ? (orderPriceString = "\(user.price!)") : (orderPriceString = "")
      setTextFieldValueAndDelegate(textField: orderPrice, value: orderPriceString)
      setTextFieldValueAndDelegate(textField: orderWorkLocation, value: user.location)
      var orderWorkAreaString: String
      user.workArea != nil ? (orderWorkAreaString = "\(user.workArea!)") : (orderWorkAreaString = "")
      setTextFieldValueAndDelegate(textField: orderWorkArea, value: orderWorkAreaString)
      
      // переключатели (функция лежит в SettingsTableController)
      setSwitchPosition(switcher: orderElectricitySwitch, value: user.electricity)
      setSwitchPosition(switcher: orderHardReliefSwitch, value: user.hardRelief)
      setSwitchPosition(switcher: orderPlantsSwitch, value: user.plants)
      
      orderOfferAlertIsActive = true
//   }
//   
//   override func viewWillAppear(_ animated: Bool) {
//      super.viewWillAppear(true)
      // выставляем наблюдателя за нажатием userLocationButton
      NotificationCenter.default.addObserver(self, selector: #selector(self.updateTextfield(notification:)),
                                             name: Notification.Name("userLocationButtonPressed"),
                                             object: user.location)
   }
   // перезагрузка таблицы
   @objc func updateTextfield(notification: Notification){
      orderWorkLocation.text = user.location
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
      case orderPrice:
         order.price = UInt(orderPrice.text!)
         orderPrice.resignFirstResponder()
         return true
      case orderWorkLocation:
         order.workLocation = orderWorkLocation.text
         orderWorkLocation.resignFirstResponder()
         return true
      case orderWorkArea:
         order.workArea = UInt(orderWorkArea.text!)
         orderWorkArea.resignFirstResponder()
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
      order.price = UInt(orderPrice.text!)
      order.workLocation = orderWorkLocation.text
      order.workArea = UInt(orderWorkArea.text!)
      user.price = order.price
      user.location = order.workLocation
      user.workArea = order.workArea
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func orderElectricitySwitcher(_ sender: UISwitch) {
      sender.isOn ? (order.electricity = true) : (order.electricity = false)
      user.electricity = order.electricity
   }
   @IBAction func orderHardReliefSwitcher(_ sender: UISwitch) {
      sender.isOn ? (order.hardRelief = true) : (order.hardRelief = false)
      user.hardRelief = order.hardRelief
   }
   @IBAction func orderPlantsSwitcher(_ sender: UISwitch) {
      sender.isOn ? (order.plants = true) : (order.plants = false)
      user.plants = order.plants
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
   
   // MARK: - Подтверждение заявки
   @IBAction func orderConfirmButton(_ sender: UIButton) {
      newData() // дублируем присваивание на всякий пожарный
      //снимаем со всех текстфилдов первого ответчика, чтобы убрать клавиатуру
      orderPrice.resignFirstResponder()
      orderWorkLocation.resignFirstResponder()
      orderWorkArea.resignFirstResponder()
      
      guard order.price != nil else {
         warningAlert(emptyField: "Стоимость покоса", currentVC: self)
         return
      }
      guard order.workLocation != "" else {
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
