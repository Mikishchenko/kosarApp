//
//  User.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 15.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import Foundation

protocol UsersProtocol {
   // MARK: Properties
   var type: Type {get set}
   var price: UInt? {get set}
   var name: String? {get set}
   var info: String? {get set}
   var image: String? {get set}
   var rating: String? {get set}
   var location: String? {get set}
   var electricity: Bool? {get set}
   var equipment: Bool? {get set}
   var transport: Bool? {get set}
   var workArea: UInt? {get set}
   var plants: Bool? {get set}
   var hardRelief: Bool? {get set}
   var latitude: Double? {get set}
   var longitude: Double? {get set}
}

enum Type {
   case client // Заказчик
   case worker // Исполнитель
}

class User: UsersProtocol {
   // MARK: Properties for USER
   var type: Type
   var price: UInt?
   var name: String?
   var info: String?
   var image: String?
   var rating: String?
   var location: String?
   var electricity: Bool?
   var equipment: Bool?
   var transport: Bool?
   var workArea: UInt?
   var plants: Bool?
   var hardRelief: Bool?
   var latitude: Double?
   var longitude: Double?
   // Initializer for USER
   init(type: Type, image: String) {
      self.type = type
      self.image = image
   }
}

typealias userID = UInt

class Partner: UsersProtocol {
   // MARK: Properties for PARTNER
   var type: Type
   var price: UInt?
   var name: String?
   var info: String?
   var image: String?
   var rating: String?
   var location: String?
   var electricity: Bool?
   var equipment: Bool?
   var transport: Bool?
   var workArea: UInt?
   var plants: Bool?
   var hardRelief: Bool?
   var latitude: Double?
   var longitude: Double?
   var distance: Double?
   // MARK: Initialization for PARTNER
   init(type: Type, price: UInt?, name: String?, info: String?, image: String, rating: String?, location: String?, electricity: Bool?, equipment: Bool?, transport: Bool?, workArea: UInt?, plants: Bool?, hardRelief: Bool?, latitude: Double?, longitude: Double?, distance: Double?) {
      self.type = type
      self.price = price
      self.name = name
      self.info = info
      self.image = image
      self.rating = rating
      self.location = location
      self.electricity = electricity
      self.equipment = equipment
      self.transport = transport
      self.workArea = workArea
      self.plants = plants
      self.hardRelief = hardRelief
      self.latitude = latitude
      self.longitude = longitude
      self.distance = distance
   }
}

//class UserSettings {
//   // MARK: Properties for UserSettings
//   var geoposition: Bool
//   var photos: Bool
//   var camera: Bool
//   var phone: Bool
//   var messages: Bool
//   var microphone: Bool
//   // Initializer for UserSettings
//   init(geoposition: Bool, photos: Bool, camera: Bool, phone: Bool,  messages: Bool, microphone: Bool) {
//      self.photos = photos
//      self.geoposition = geoposition
//      self.photos = photos
//      self.camera = camera
//      self.phone = phone
//      self.messages = messages
//      self.microphone = microphone
//   }
//}

//class Contractor {
//   // MARK: Properties for UserHistory
//   var photo: String
//   var name: String
//   var date: Date
//   var rating: String?
//   var iD: userID
//   // Initializer for UserHistory
//   init(photo: String, name: String, date: Date, rating: String?, iD: userID) {
//      self.photo = photo
//      self.name = name
//      self.date = date
//      self.rating = rating
//      self.iD = iD
//   }
//}

//class Order {
//   var price: UInt?
//   var location: String?
//   var workArea: UInt?
//   var electricity: Bool?
//   var hardRelief: Bool?
//   var plants: Bool?
//
//}

//class Offer {
//   var price: UInt?
//   var location: String?
//   var info: String?
//   var equipment: Bool?
//   var electricity: Bool?
//   var transport: Bool?
//}

// MARK: - Расширяем функционал типа Date, может конвертироваться в String и обратно
extension Date {
   // форматируем стороку в дату
   func from(_ value: String) -> Date? {
      let dateFormatter = DateFormatter()
      dateFormatter.dateFormat = "dd.MM.yyyy"
      if let newDate = dateFormatter.date(from: value) {
         return newDate
      } else { return nil }
   }
   
   // форматируем дату в строку формата "dd.mm.yyyy"
   func to(format:String) -> String {
      let formatter = DateFormatter()
      formatter.dateFormat = format
      let dateResult = formatter.string(from: self)
      return dateResult
   }
}
