//
//  HistoryTableViewController.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 16.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

// MARK: - Установка первоначальных данных истории
var userHistory = SampleData.generateUserHistoryData()

class HistoryTableController: UITableViewController {
   
   override func viewDidLoad() {
      super.viewDidLoad()
      self.clearsSelectionOnViewWillAppear = false
      // выставляем наблюдателя за изменением рейтинга
      NotificationCenter.default.addObserver(self, selector: #selector(self.updateRating(notification:)),
                                             name: Notification.Name("isRated"), object: nil)
   }
   // перезагрузка таблицы
   @objc func updateRating(notification: Notification){
      self.tableView.reloadData()
   }
   
   // MARK: - Table view data source
   
   // количество записей в истории
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return userHistory.count
   }
   
   // формирование типовой записи
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      // сортируем массив контракторов по дате
      var sortedUserHistory = userHistory.sorted {( $0.date > $1.date)}
      
      let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
      cell.contractor = sortedUserHistory[indexPath.row]
      return cell
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}
