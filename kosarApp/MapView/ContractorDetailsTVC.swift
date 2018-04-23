//
//  ContractorDetailsTVC.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 17.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class ContractorDetailsTVC: UITableViewController {

   @IBOutlet weak var contractorPrice: UILabel!
   @IBOutlet weak var contractorName: UILabel!
   @IBOutlet weak var contractorRating: UIImageView!
   @IBOutlet weak var contractorDistance: UILabel!
   @IBOutlet weak var contractorInfo: UILabel!
   @IBOutlet weak var contractorConditions: UILabel!
   
   override func viewDidLoad() {
        super.viewDidLoad()

    }

   //MARK: - Кнопки
   @IBAction func messageButton(_ sender: UIButton) {
      print("Пользователь пытается отправить сообщение Контрагету")
   }
   
   @IBAction func callButton(_ sender: UIButton) {
      print("Пользователь пытается дозвониться до Контрагета")
   }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

