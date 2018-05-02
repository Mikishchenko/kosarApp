//
//  OrderTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 09.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

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
      order.price != nil ? (orderPriceString = "\(order.price!)") : (orderPriceString = "")
      setTextFieldValueAndDelegate(textField: orderPrice, value: orderPriceString)
      setTextFieldValueAndDelegate(textField: orderWorkLocation, value: order.workLocation)
      var orderWorkAreaString: String
      order.workArea != nil ? (orderWorkAreaString = "\(order.workArea!)") : (orderWorkAreaString = "")
      setTextFieldValueAndDelegate(textField: orderWorkArea, value: orderWorkAreaString)
      
      // переключатели (функция лежит в SettingsTableController)
      setSwitchPosition(switcher: orderElectricitySwitch, value: order.electricity)
      setSwitchPosition(switcher: orderHardReliefSwitch, value: order.hardRelief)
      setSwitchPosition(switcher: orderPlantsSwitch, value: order.plants)
      
      orderAlertIsActive = true
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
         order.price = Int(orderPrice.text!)
         orderPrice.resignFirstResponder()
         return true
      case orderWorkLocation:
         order.workLocation = orderWorkLocation.text
         orderWorkLocation.resignFirstResponder()
         return true
      case orderWorkArea:
         order.workArea = Int(orderWorkArea.text!)
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
      order.price = Int(orderPrice.text!)
      order.workLocation = orderWorkLocation.text
      order.workArea = Int(orderWorkArea.text!)
   }
   
   // MARK: - Присваивание новых значений при изменении положений переключателей
   @IBAction func orderElectricitySwitcher(_ sender: UISwitch) {
      sender.isOn ? (order.electricity = true) : (order.electricity = false)
   }
   @IBAction func orderHardReliefSwitcher(_ sender: UISwitch) {
      sender.isOn ? (order.hardRelief = true) : (order.hardRelief = false)
   }
   @IBAction func orderPlantsSwitcher(_ sender: UISwitch) {
      sender.isOn ? (order.plants = true) : (order.plants = false)
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
