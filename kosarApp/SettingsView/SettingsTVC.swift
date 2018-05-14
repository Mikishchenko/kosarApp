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
   @IBOutlet weak var resetUserDefaultsData: UIButton!
   
   // MARK: - Отображение:
   override func viewDidLoad() {
      super.viewDidLoad()
      resetUserDefaultsData.layer.cornerRadius = 12
      // MARK: - Текущие значения настроек
      setSwitchPosition(switcher: geopositionSwitch, key: "geoposition")
      setSwitchPosition(switcher: photosSwitch, key: "photos")
      setSwitchPosition(switcher: cameraSwitch, key: "camera")
      setSwitchPosition(switcher: phoneSwitch, key: "phone")
      setSwitchPosition(switcher: messagesSwitch, key: "messages")
      setSwitchPosition(switcher: microphoneSwitch, key: "microphone")
   }
   
   // MARK: - Присваивание новых значений при переключении переключателей
   @IBAction func geoposition(_ sender: UISwitch) {
      settings.geoposition = sender.isOn
      userDefaults.set(settings.geoposition, forKey: "geoposition")
//      sender.isOn ? (settings.geoposition = true) : (settings.geoposition = false)
   }
   @IBAction func photos(_ sender: UISwitch) {
      settings.photos = sender.isOn
      userDefaults.set(settings.photos, forKey: "photos")
//      sender.isOn ? (settings.photos = true) : (settings.photos = false)
   }
   @IBAction func camera(_ sender: UISwitch) {
      settings.camera = sender.isOn
      userDefaults.set(settings.camera, forKey: "camera")
//      sender.isOn ? (settings.camera = true) : (settings.camera = false)
   }
   @IBAction func phone(_ sender: UISwitch) {
      settings.phone = sender.isOn
      userDefaults.set(settings.phone, forKey: "phone")
//      sender.isOn ? (settings.phone = true) : (settings.phone = false)
   }
   @IBAction func messages(_ sender: UISwitch) {
      settings.messages = sender.isOn
      userDefaults.set(settings.messages, forKey: "messages")
//      sender.isOn ? (settings.messages = true) : (settings.messages = false)
   }
   @IBAction func microphone(_ sender: UISwitch) {
      settings.microphone = sender.isOn
      userDefaults.set(settings.microphone, forKey: "microphone")
//      sender.isOn ? (settings.microphone = true) : (settings.microphone = false)
   }
   
   @IBAction func resetUserDefaultsData(_ sender: UIButton) {
      let defaults = UserDefaults.standard
      let dictionary = defaults.dictionaryRepresentation()
      dictionary.keys.forEach { key in
         defaults.removeObject(forKey: key)
      }
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

//MARK: - Показывает текущее значение переключателя
public func setSwitchPosition(switcher: UISwitch, key: String) {
   if let object = userDefaults.object(forKey: key) as? Bool {
      switcher.setOn(object, animated: false)
   }
//   value == true ? switcher.setOn(true, animated: false) : switcher.setOn(false, animated: false)
}
