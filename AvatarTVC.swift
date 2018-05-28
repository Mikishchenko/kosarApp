//
//  AvatarTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 16.05.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class AvatarTableViewController: UITableViewController {
   
   let avatarsArray = SampleData.generateAvatars()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.becomeFirstResponder()
   }
   
   @IBAction func saveChoiceButton(_ sender: UIButton) {
      userDefaults.set(user.image, forKey: "image")
      self.resignFirstResponder()
      dismiss(animated: true, completion: nil)
      // назначения уведомления об окончании выбра аватара
      NotificationCenter.default.post(name: Notification.Name("popOverVCWillDismissed"), object: nil)
   }
   // MARK: - Отмена выбора изображения
   @IBAction func cancelChoiceButton(_ sender: UIButton) {
      self.resignFirstResponder()
      dismiss(animated: true, completion: nil)
      // назначения уведомления об окончании выбра аватара
      NotificationCenter.default.post(name: Notification.Name("popOverVCWillDismissed"), object: nil)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
   // MARK: - Отображение в ячеейке AvatarTVCell коллекции картинок из ячейки AvatarCVCell
   override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,
                           forRowAt indexPath: IndexPath) {
      if let tableViewCell = cell as? AvatarTableViewCell {
         tableViewCell.setCollectionViewDelegate(delegate: self, forRow: indexPath.row)
      }
   }
}

extension AvatarTableViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
   // MARK: - Определяется количество объектов в коллекции
   func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return avatarsArray.count
   }
   // MARK: - Определяем, что будем показывать в повторяющейся ячейке AvatarCVCell
   func collectionView(_ collectionView: UICollectionView,
                       cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCVCell",
                                                       for: indexPath) as? AvatarCollectionViewCell {
         let imageName = avatarsArray[indexPath.row]
         cell.avatarImage.image = UIImage(named: "\(imageName)")
         return cell
      }
      return UICollectionViewCell()
   }
   // MARK: - Определяем, что происходит при выборе нового аватара.
   func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
      if collectionView.dequeueReusableCell(withReuseIdentifier: "AvatarCVCell",
                                            for: indexPath) is AvatarCollectionViewCell {
         user.image = avatarsArray[indexPath.row]
      }
   }
}
