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
   }
   
   // MARK: - Table view data source
   
   // количество записей в истории
   override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return userHistory.count
   }
   
   // формирование типовой записи
   override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = tableView.dequeueReusableCell(withIdentifier: "HistoryCell", for: indexPath) as! HistoryCell
      cell.contractor = userHistory[indexPath.row]
      return cell
   }
   
   //MARK: - Переполнение памяти
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
   }
}
