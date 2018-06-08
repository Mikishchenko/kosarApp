//
//  HistoryController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 20.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class HistoryController: UIViewController {
   
   @IBOutlet weak var avatarBackgroundImage: UIImageView!
   @IBOutlet weak var avatarImage: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var infoLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // MARK: - Наблюдатель за окончанием редактирования текстфилда
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing),
                                             name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
      guard userHistory?.isEmpty == false else {
         alertSimpleInfo(message: "В Вашей истории нет записей.\nСвяжитесь с кем-нибудь из контрагентов.",
                         currentVC: self)
         return
      }
      // MARK: - Проверка на отсутствие рейтинга у контракторов в истории
      for contractor in userHistory! {
         if contractor.rating == nil {
            alertWorkComplete(contractor: contractor)
         }
      }
   }
   
   // MARK: - Селектор к наблюдателю. Назначает полученные значения на лейблы в хедер
   @objc func textFieldTextDidEndEditing(ncParam: NSNotification) {
      userNameInfo(userName: nameLabel, userInfo: infoLabel)
   }
   
   // NavBar нужно именно здесь вызывать
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      customeNavBar(viewController: self)
      userInfoInHeader(background: avatarBackgroundImage, avatar: avatarImage,
                       name: nameLabel, info: infoLabel, rating: ratingImage)
   }
   
   // MARK: - Если у кого-то из контракторов отсутствует рейтинг, уточняем: Выполнена работа или нет?
   func alertWorkComplete(contractor: Contractor) {
      let alert = UIAlertController(title: "РАБОТА ВЫПОЛНЕНА?",
                                    message: "Контрагент: \(contractor.name ?? ""),\n дата: \(contractor.date?.to(format: "dd.MM.yyyy") ?? "")", preferredStyle: .alert)
      let yesAction = UIAlertAction(title: "ДА", style: .default) { (action) in
         self.alertSetRating(contractor: contractor)
      }
      let noAction = UIAlertAction(title: "НЕТ", style: .default)
      alert.addAction(yesAction)
      alert.addAction(noAction)
      self.present(alert, animated: true, completion: nil)
   }
   
   // MARK: - Если работа выполнена, нужно поставить оценку.
   func alertSetRating(contractor: Contractor) {
      let alert = UIAlertController(title: "ПОЖАЛУЙСТА ОЦЕНИТЕ КОНТРАГЕНТА",
                                    message: " \(contractor.name ?? ""), дата: \(contractor.date?.to(format: "dd.MM.yyyy") ?? "")", preferredStyle: .alert)
      // заполняем кнопки вариантами рейтинга
      for index in 1...5 {
         // присваиваем значение рейтинга в клоужере
         let alertAction = UIAlertAction(title: "", style: .default) { (action) in
            contractor.rating = "Rating \(index)"
            CoreDataHandler.refreshObjectsRating(iD: UInt(contractor.iD),
                                                 date: contractor.date!, rating: contractor.rating)
            // после выставления оценки изменится рейтинг в таблице с историей
            NotificationCenter.default.post(name: Notification.Name("isRated"), object: nil)
         }
         // заполняем кнопку изображением рейтинга, присвоить рейтинг можно нажав на него
         alertAction.setValue(UIImage(named: "Rating \(index)")?.withRenderingMode(UIImageRenderingMode.alwaysOriginal),
                              forKey: "image")
         alert.addAction(alertAction)
      }
      self.present(alert, animated: true, completion: nil)
   }
   
   // MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

// MARK: - Простое информационное сообщение
public func alertSimpleInfo(message: String, currentVC: UIViewController) {
   let alert = UIAlertController(title: "ИНФОРМАЦИЯ",
                                 message: message, preferredStyle: .alert)
   let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
   alert.addAction(action)
   currentVC.present(alert, animated: true, completion: nil)
}

// MARK: - Заполнение имени и краткой информации
public func userNameInfo(userName: UILabel, userInfo: UILabel) {
   userName.text = userDefaults.object(forKey: "name") as? String
   userInfo.text = userDefaults.object(forKey: "info") as? String
}
