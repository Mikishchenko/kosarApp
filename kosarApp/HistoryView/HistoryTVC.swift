//
//  HistoryTableViewController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 16.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

// MARK: - Установка первоначальных данных истории
var userHistory: [Contractor]? = []

class HistoryTableController: UITableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // получаем объекты в виде массива из Core Data
      userHistory = CoreDataHandler.fetchObject()
      self.clearsSelectionOnViewWillAppear = false
      // выставляем наблюдателя за изменением рейтинга
      NotificationCenter.default.addObserver(self, selector: #selector(self.updateRating(notification:)),
                                             name: Notification.Name("isRated"), object: nil)
   }
   // перезагрузка таблицы
   @objc func updateRating(notification: Notification){
      userHistory = CoreDataHandler.fetchObject()
      self.tableView.reloadData()
   }
   
   // tableView data source
   // MARK: - Устанавливает количество записей в истории
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      guard userHistory?.isEmpty == false  else { return 0 }
      return userHistory!.count
   }
   
   // MARK: - Формирование типовой записи истории
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // сортируем массив контракторов по дате
      userHistory = userHistory?.sorted {( $0.date! > $1.date! )}
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
      cell.contractor = userHistory?[indexPath.row]
      return cell
   }
   
   // tableView delegate
   // MARK: - Позволяет удалять записи из истории смахиванием влево
   override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
      if editingStyle == .delete {
         if CoreDataHandler.deleteObject(contractor: userHistory![indexPath.row]) {
            userHistory!.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
         }
      }
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}
