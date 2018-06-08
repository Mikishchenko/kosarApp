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
   class func saveObject(photo: String, date: Date, rating: String?, name: String, iD: UInt) {
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
         return
      } catch {
         print("Сохранить объект не удалось")
         return
      }
   }
   
   // MARK: - Получение всех объектов сущности
   class func fetchObject() -> [Contractor]? {
      let context = getContext()
      var objects: [Contractor]? = nil
      do {
         objects = try context.fetch(Contractor.fetchRequest())
         return objects
      } catch {
         print("Получить объекты не удалось")
         return objects
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
         print("Удалить объект не удалось")
         return false
      }
   }
   
   // MARK: - Обновление значения рейтинга у объекта
   class func refreshObjectsRating(iD: UInt, date: Date, rating: String?) {
      let context = getContext()
      var objects: [Contractor]? = nil
      do {
         objects = try context.fetch(Contractor.fetchRequest())
         guard (objects?.count)! > 0 else { return }
         for object in objects! {
            if object.iD == iD && object.date == date {
               object.setValue(object.rating, forKey: "rating")
            }
         }
         try context.save()
         return
      } catch {
         print("Обновить рейтинг объекта не удалось")
         return
      }
   }
}
