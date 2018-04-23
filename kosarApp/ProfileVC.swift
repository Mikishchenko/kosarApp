//
//  ProfileController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 15.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
   
   @IBOutlet weak var userAvatar: UIImageView!
   @IBOutlet weak var userName: UILabel!
   @IBOutlet weak var userInfo: UILabel!
   @IBOutlet weak var userRating: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // наблюдатель за окончанием редактирования текстфилда
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
   }
   
   // селектор к наблюдателю. Назначает полученные значения на лейблы в хедер
   @objc func textFieldTextDidEndEditing(ncParam: NSNotification) {
      userNameInfo(userName: userName, userInfo: userInfo)
   }
   
   // мне показалось, что здесь обновление данных надо вызывать. Надо будет еще по-эксперементировать
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      userInfoInHeader()
   }
   
   // NavBar нужно именно здесь вызывать
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      customeNavBar(viewController: self)
   }
   
   // MARK: - Наполнение Header данными
   func userInfoInHeader() {
      userAvatar.image = UIImage(named: "User avatar")
      userNameInfo(userName: userName, userInfo: userInfo)
      userRating.image = UIImage(named: "Rating 4")
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}
