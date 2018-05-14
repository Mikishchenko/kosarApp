//
//  HistoryController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 20.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class HistoryController: UIViewController {
   
   @IBOutlet weak var avatarImage: UIImageView!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var infoLabel: UILabel!
   @IBOutlet weak var ratingImage: UIImageView!
   
   override func viewDidLoad() {
      super.viewDidLoad()
      userInfoInHeader()
      
      // MARK: - Наблюдатель за окончанием редактирования текстфилда
      NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: nil)
      guard userHistory.isEmpty == false else {
         return
      }
      // MARK: - Проверка на отсутствие рейтинга у контракторов в истории
      for contractor in userHistory {
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
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      customeNavBar(viewController: self)
   }
   
   // MARK: - Наполнение Header данными User
   func userInfoInHeader() {
      avatarImage.image = UIImage(named: "User avatar")
      userNameInfo(userName: nameLabel, userInfo: infoLabel)
      ratingImage.image = UIImage(named: "Rating 4")
   }
   
   // MARK: - Если у кого-то из контракторов отсутствует рейтинг, уточняем: Выполнена работа или нет?
   func alertWorkComplete(contractor: Contractor) {
      let alert = UIAlertController(title: "Контрагент: \(contractor.name), дата: \(contractor.date.to(format: "dd.MM.yyyy"))", message: "Работа выполнена?", preferredStyle: .alert)
      let yesAction = UIAlertAction(title: "ДА", style: .default) { (action) in
         self.alertSetRating(contractor: contractor)
      }
      let noAction = UIAlertAction(title: "НЕТ", style: .default) { (action) in
         print("Работа не выполнена")
      }
      alert.addAction(yesAction)
      alert.addAction(noAction)
      self.present(alert, animated: true, completion: nil)
   }
   
   // MARK: - Если работа выполнена, нужно поставить оценку.
   func alertSetRating(contractor: Contractor) {
      let alert = UIAlertController(title: "ПОЖАЛУЙСТА ОЦЕНИТЕ КОНТРАГЕНТА",
                                    message: " \(contractor.name), дата: \(contractor.date.to(format: "dd.MM.yyyy"))", preferredStyle: .alert)
      let alertAction1 = UIAlertAction(title: "", style: .default) { (action) in
         self.setRating(contractor: contractor, rating: "Rating 1")
      }
      let alertAction2 = UIAlertAction(title: "", style: .default) { (action) in
         self.setRating(contractor: contractor, rating: "Rating 2")
      }
      let alertAction3 = UIAlertAction(title: "", style: .default) { (action) in
         self.setRating(contractor: contractor, rating: "Rating 3")
      }
      let alertAction4 = UIAlertAction(title: "", style: .default) { (action) in
         self.setRating(contractor: contractor, rating: "Rating 4")
      }
      let alertAction5 = UIAlertAction(title: "", style: .default) { (action) in
         self.setRating(contractor: contractor, rating: "Rating 5")
      }
      setAlertActionImage(alertAction1, ratingImage: "Rating 1")
      setAlertActionImage(alertAction2, ratingImage: "Rating 2")
      setAlertActionImage(alertAction3, ratingImage: "Rating 3")
      setAlertActionImage(alertAction4, ratingImage: "Rating 4")
      setAlertActionImage(alertAction5, ratingImage: "Rating 5")
      
      alert.addAction(alertAction1)
      alert.addAction(alertAction2)
      alert.addAction(alertAction3)
      alert.addAction(alertAction4)
      alert.addAction(alertAction5)
      
      self.present(alert, animated: true, completion: nil)
   }
   
   // MARK: - Присвоение рейтинга и установка наблюдателя
   fileprivate func setRating(contractor: Contractor, rating: String) {
      contractor.rating = rating
      // после выставления оценки изменится рейтинг в таблице с историей
      NotificationCenter.default.post(name: Notification.Name("isRated"), object: nil)
   }
   
   // MARK: - Вставка картинки рейтинга в alertAction
   fileprivate func setAlertActionImage(_ alertAction: UIAlertAction, ratingImage: String) {
      alertAction.setValue(UIImage(named: ratingImage)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal),
                           forKey: "image")
   }
   
   // MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}

// MARK: Заполнение имени и краткой информации
public func userNameInfo(userName: UILabel, userInfo: UILabel) {
   userName.text = userDefaults.object(forKey: "name") as? String //user.name ?? ""
   userInfo.text = userDefaults.object(forKey: "info") as? String //user.info ?? ""
}
