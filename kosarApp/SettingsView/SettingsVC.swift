//
//  SettingsController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 16.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
   
   @IBOutlet weak var avatarBackgroundImage: UIImageView!
   @IBOutlet weak var avatarImage: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var infoLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // наблюдатель за окончанием редактирования текстфилда
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
   }
   
   // селектор к наблюдателю. Назначает полученные значения на лейблы в хедер
   @objc func textFieldTextDidEndEditing(ncParam: NSNotification) {
      userNameInfo(userName: nameLabel, userInfo: infoLabel)
   }

   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      customeNavBar(viewController: self)
      userInfoInHeader(background: avatarBackgroundImage, avatar: avatarImage,
                       name: nameLabel, info: infoLabel, rating: ratingImage)
   }
   
   // MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}







