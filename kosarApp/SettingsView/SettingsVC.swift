//
//  SettingsController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 16.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class SettingsController: UIViewController {
   
   @IBOutlet weak var userAvatar: UIImageView!
   @IBOutlet weak var userName: UILabel!
   @IBOutlet weak var userInfo: UILabel!
   @IBOutlet weak var userRating: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      userInfoInHeader()

      // наблюдатель за окончанием редактирования текстфилда
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
   }
   
   // селектор к наблюдателю. Назначает полученные значения на лейблы в хедер
   @objc func textFieldTextDidEndEditing(ncParam: NSNotification) {
      userNameInfo(userName: userName, userInfo: userInfo)
   }

   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      customeNavBar(viewController: self)
   }
   // MARK: - наполнение Header данными User
   func userInfoInHeader() {
      userAvatar.image = UIImage(named: "User avatar")
      userNameInfo(userName: userName, userInfo: userInfo)
      userRating.image = UIImage(named: "Rating 4")
   }
   
   // MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}







