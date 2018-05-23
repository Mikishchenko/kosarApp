//
//  ProfileController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 15.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class ProfileController: UIViewController {
   
   @IBOutlet weak var blurEffect: UIVisualEffectView!
   @IBOutlet weak var avatarBackgroundImage: UIImageView!
   @IBOutlet weak var avatarImage: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var infoLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.blurEffect.isHidden = true

      userInfoInHeader(background: avatarBackgroundImage, avatar: avatarImage,
                       name: nameLabel, info: infoLabel, rating: ratingImage)
      
      // наблюдатель за окончанием редактирования текстфилда
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing),
                                             name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
      // наблюдатель за окончанием смены аватара
      NotificationCenter.default.addObserver(self, selector: #selector(blurEffectOff),
                                             name: NSNotification.Name(rawValue: "popOverVCWillDismissed"), object: nil)
   }
   
   // селектор к наблюдателю. Назначает полученные значения на лейблы в хедер
   @objc func textFieldTextDidEndEditing(ncParam: NSNotification) {
      userNameInfo(userName: nameLabel, userInfo: infoLabel)
   }
   
   // селектор к наблюдателю. Выключает эффект размытия
   @objc func blurEffectOff(ncParam: NSNotification) {
      blurEffectOnOff()
      userInfoInHeader(background: avatarBackgroundImage, avatar: avatarImage,
                       name: nameLabel, info: infoLabel, rating: ratingImage)

   }
   
   // NavBar нужно именно здесь вызывать
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      customeNavBar(viewController: self)
      userInfoInHeader(background: avatarBackgroundImage, avatar: avatarImage,
                       name: nameLabel, info: infoLabel, rating: ratingImage)
   }
   
   @IBAction func avatarButtonPressed(_ sender: UIButton) {
      blurEffectOnOff()
      alertYesNo(message: "Хотите сменить аватар?")
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
   
   // MARK: - Вопрос с ответами: Да или Нет?
   public func alertYesNo(message: String) {
      let alert = UIAlertController(title: "ВНИМАНИЕ!", message: message, preferredStyle: .alert)
      let yesAction = UIAlertAction(title: "ДА", style: .default) { (action) in
         popoverVC(currentVC: self, identifierPopoverVC: "AvatarTVC", heightPopoverVC: 320)
      }
      let noAction = UIAlertAction(title: "НЕТ", style: .default) { (action) in
         self.blurEffectOnOff()
      }
      alert.addAction(yesAction)
      alert.addAction(noAction)
      self.present(alert, animated: true, completion: nil)
   }
   
   // MARK: - Включение-выключение эффекта размытости (blurEffect)
   public func blurEffectOnOff() {
      self.blurEffect.isHidden = !blurEffect.isHidden
   }
}

// MARK: - Наполнение Header данными
public func userInfoInHeader(background: UIImageView, avatar: UIImageView,
                             name: UILabel, info: UILabel, rating: UIImageView) {
   background.image = UIImage(named: "avatarBackground")
   imageFromUserDefaults(avatar, key: "image", defaultImageName: "avatarDefault")
   userNameInfo(userName: name, userInfo: info)
   imageFromUserDefaults(rating, key: "rating", defaultImageName: "Rating 0")
}

// MARK: - Заполнение картинок из userDefaults
public func imageFromUserDefaults(_ headersField: UIImageView, key: String, defaultImageName: String) {
   if let object = userDefaults.object(forKey: key) {
      headersField.image = UIImage(named: (object as? String)!)
   } else {
      headersField.image = UIImage(named: defaultImageName)
   }
}

// MARK: - Для корректной отработки всплывающих окон, иначе они растягиваются на весь экран
extension ProfileController: UIPopoverPresentationControllerDelegate {
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
}
