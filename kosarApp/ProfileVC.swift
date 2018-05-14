//
//  ProfileController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 15.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
   
   @IBOutlet weak var avatarImage: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var infoLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      userInfoInHeader()
      // наблюдатель за окончанием редактирования текстфилда
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
   }
   
   // селектор к наблюдателю. Назначает полученные значения на лейблы в хедер
   @objc func textFieldTextDidEndEditing(ncParam: NSNotification) {
      userNameInfo(userName: nameLabel, userInfo: infoLabel)
   }
   
   // мне показалось, что здесь обновление данных надо вызывать. Надо будет еще по-эксперементировать
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
   }
   
   // NavBar нужно именно здесь вызывать
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      customeNavBar(viewController: self)
   }
   
   // MARK: - Наполнение Header данными
   func userInfoInHeader() {
      avatarImage.image = UIImage(named: "User avatar")
      userNameInfo(userName: nameLabel, userInfo: infoLabel)
      ratingImage.image = UIImage(named: "Rating 4")
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}
