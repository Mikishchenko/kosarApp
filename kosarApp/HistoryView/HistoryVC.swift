//
//  HistoryController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 20.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class HistoryController: UIViewController {
   
   @IBOutlet weak var userAvatar: UIImageView!
   @IBOutlet weak var userName: UILabel!
   @IBOutlet weak var userInfo: UILabel!
   @IBOutlet weak var userRating: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      userInfoInHeader()

      //MARK: - Наблюдатель за окончанием редактирования текстфилда
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
   }
   
   //MARK: - Селектор к наблюдателю. Назначает полученные значения на лейблы в хедер
   @objc func textFieldTextDidEndEditing(ncParam: NSNotification) {
      userNameInfo(userName: userName, userInfo: userInfo)
   }

   // NavBar нужно именно здесь вызывать
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      customeNavBar(viewController: self)
   }

   // MARK: - Наполнение Header данными User
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

// MARK: Заполнение имени и краткой информации
public func userNameInfo(userName: UILabel, userInfo: UILabel) {
   userName.text = user.name ?? ""
   userInfo.text = user.info ?? ""
}




