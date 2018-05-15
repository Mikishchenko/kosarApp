//
//  CoreDataHandler.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 15.05.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import CoreData

class CoreDataHandler: NSObject {
   
   // MARK: - Получение текущего контекста
   private class func getContext() -> NSManagedObjectContext {
      let appDelegate = UIApplication.shared.delegate as! AppDelegate
      return appDelegate.persistentContainer.viewContext
   }
   
   // MARK: - Сохранение объекта в сущность Contractor
   class func saveObject(photo: String, date: Date, rating: String?, name: String, iD: UInt) -> Bool {
      let context = getContext()
      let entity = NSEntityDescription.entity(forEntityName: "Contractor", in: context)
      let manageObject = NSManagedObject(entity: entity!, insertInto: context)
      
      manageObject.setValue(photo, forKey: "photo")
      manageObject.setValue(date, forKey: "date")
      manageObject.setValue(rating, forKey: "rating")
      manageObject.setValue(name, forKey: "name")
      manageObject.setValue(iD, forKey: "iD")
      
      do {
         try context.save()
         return true
      } catch {
         return false
      }
   }
   
   // MARK: - Получение объекта
   class func fetchObject() -> [Contractor]? {
      let context = getContext()
      var contractor: [Contractor]? = nil
      do {
         contractor = try context.fetch(Contractor.fetchRequest())
         return contractor
      } catch {
         return contractor
      }
   }
   
   // MARK: - Удаление объекта
   class func deleteObject(contractor: Contractor) -> Bool {
      let context = getContext()
      context.delete(contractor)
      do {
         try context.save()
         return true
      } catch {
         return false
      }
   }
}
