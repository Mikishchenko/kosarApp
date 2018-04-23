//
//  SettingsTableController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 17.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

// MARK: - Установка первоначальных настроек
var settings = SampleData.generateUserSettingsData()

class SettingsTableController: UITableViewController {
   
   // MARK: - Объекты, которые мы будем отображать
   @IBOutlet weak var geopositionSwitch: UISwitch!
   @IBOutlet weak var photosSwitch: UISwitch!
   @IBOutlet weak var cameraSwitch: UISwitch!
   @IBOutlet weak var phoneSwitch: UISwitch!
   @IBOutlet weak var messagesSwitch: UISwitch!
   @IBOutlet weak var microphoneSwitch: UISwitch!
   
   // MARK: - Отображение:
   override func viewDidLoad() {
      super.viewDidLoad()

      // MARK: - Текущие значения настроек
      setSwitchPosition(switcher: geopositionSwitch, value: settings.geoposition)
      setSwitchPosition(switcher: photosSwitch, value: settings.photos)
      setSwitchPosition(switcher: cameraSwitch, value: settings.camera)
      setSwitchPosition(switcher: phoneSwitch, value: settings.phone)
      setSwitchPosition(switcher: messagesSwitch, value: settings.messages)
      setSwitchPosition(switcher: microphoneSwitch, value: settings.microphone)
   }
   
   // MARK: - Присваивание новых значений при переключении переключателей
   @IBAction func geoposition(_ sender: UISwitch) {
      sender.isOn ? (settings.geoposition = true) : (settings.geoposition = false)
   }
   @IBAction func photos(_ sender: UISwitch) {
      sender.isOn ? (settings.photos = true) : (settings.photos = false)
   }
   @IBAction func camera(_ sender: UISwitch) {
      sender.isOn ? (settings.camera = true) : (settings.camera = false)
   }
   @IBAction func phone(_ sender: UISwitch) {
      sender.isOn ? (settings.phone = true) : (settings.phone = false)
   }
   @IBAction func messages(_ sender: UISwitch) {
      sender.isOn ? (settings.messages = true) : (settings.messages = false)
   }
   @IBAction func microphone(_ sender: UISwitch) {
      sender.isOn ? (settings.microphone = true) : (settings.microphone = false)
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

//MARK: - Показывает текущее значение переключателя
public func setSwitchPosition(switcher: UISwitch, value: Bool?) {
   value == true ? switcher.setOn(true, animated: false) : switcher.setOn(false, animated: false)
}
