//
//  ContactorInfoTableViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 17.04.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class ContactorInfoTableViewController: UITableViewController {

   @IBOutlet weak var contractorPrice: UILabel!
   @IBOutlet weak var contractorDistance: UILabel!
   @IBOutlet weak var contractorName: UILabel!
   @IBOutlet weak var contractorRating: UIImageView!
   @IBOutlet weak var contractorConditions: UILabel!
   
    override func viewDidLoad() {
        super.viewDidLoad()

    }
  
   // MARK: - Кнопки
   @IBAction func detailsButton(_ sender: UIButton) {
      popoverVC(currentVC: self, identifierPopoverVC: "ContractorDetailsTVC", heightPopoverVC: 236)
   }
   @IBAction func callButton(_ sender: UIButton) {
      print("Пользователь пытается дозвониться до Контрагета")
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

// это расширение необходимо для корректной отработки всплывающих окон, иначе они растягиваются на весь экран
extension ContactorInfoTableViewController: UIPopoverPresentationControllerDelegate {
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
}
