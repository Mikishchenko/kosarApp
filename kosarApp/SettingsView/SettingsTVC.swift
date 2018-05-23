//
//  SettingsTableController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 17.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class SettingsTableController: UITableViewController {
   
   // MARK: - Объекты, которые мы будем отображать
   @IBOutlet weak var geopositionSwitch: UISwitch!
   @IBOutlet weak var photosSwitch: UISwitch!
   @IBOutlet weak var cameraSwitch: UISwitch!
   @IBOutlet weak var phoneSwitch: UISwitch!
   @IBOutlet weak var messagesSwitch: UISwitch!
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
      setSwitchPosition(switcher: photosSwitch, key: "photos")
      setSwitchPosition(switcher: cameraSwitch, key: "camera")
      setSwitchPosition(switcher: phoneSwitch, key: "phone")
      setSwitchPosition(switcher: messagesSwitch, key: "messages")
      setSwitchPosition(switcher: microphoneSwitch, key: "microphone")
   }
   
   // MARK: - Присваивание новых значений при переключении переключателей
   @IBAction func geoposition(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "geoposition")
   }
   @IBAction func photos(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "photos")
   }
   @IBAction func camera(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "camera")
   }
   @IBAction func phone(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "phone")
   }
   @IBAction func messages(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "messages")
   }
   @IBAction func microphone(_ sender: UISwitch) {
      userDefaults.set(sender.isOn, forKey: "microphone")
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
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

//MARK: - Показывает текущее значение переключателя
public func setSwitchPosition(switcher: UISwitch, key: String) {
   if let object = userDefaults.object(forKey: key) as? Bool {
      switcher.setOn(object, animated: false)
   } else {
      switcher.setOn(false, animated: false)
   }
}
