//
//  SampleData.swift
//  TabBarApp
//
//  Created by Владимир Микищенко on 16.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import Foundation

final class SampleData {
   
   // MARK: All data for our User in start
   static func generateUserData() -> User {
      return
         User(type: .client, image: "User avatar")
   }
   
   static func generateUserHistoryData() -> [Contractor] {
      return [
         Contractor(photo: "Worker1", name: "Фёдор КОСОРЕЗОВ", date: "15.03.18", rating: "Rating 5"),
         Contractor(photo: "Worker1", name: "Фёдор КОСОРЕЗОВ", date: "01.03.18", rating: "Rating 4"),
         Contractor(photo: "Worker3", name: "Джамшут", date: "10.02.18", rating: "Rating 5")
      ]
   }
   
   static func generateUserSettingsData() -> UserSettings {
      return
         UserSettings(geoposition: false, photos: false, camera: false, phone: false, messages: false, microphone: false)
   }
   
   // MARK: All data about our Clients in start
   static func generateClientData() -> [Client] {
      return [
         Client(name: "Максим РЯБУХИН", info: "Владелец ранчо ПОЗИТИВ", image: "Client1", rating: "Rating 4", location: "Московская область, Дмитровский район, деревня Никульское", electricity: true, equipment: true, transport: true, workArea: 6, plants: true, hardRelief: true),
         Client(name: "Володя МИКИЩЕНКО", info: "тот еще удачник", image: "Client3", rating: "Rating 3", location: "Московская область, Чеховский район, СНТ Солнечное", electricity: true, equipment: true, transport: true, workArea: 8, plants: true, hardRelief: false),
         Client(name: "Дима НОСОВИЦКИЙ", info: "владелец усадьбы", image: "Client4", rating: "Rating 5", location: "Ленинградская область, Всеволожский район, Лесколовское сельское поселение", electricity: true, equipment: true, transport: true, workArea: 4, plants: true, hardRelief: true)
      ]
   }
   
   // MARK: All data about our Workers in start
   static func generateWorkerData() -> [Worker] {
      return [
         Worker(name: "Фёдор КОСОРЕЗОВ", info: "Косарь от бога",image: "Worker1", rating: "Rating 5",  location: "Московская область, Дмитровский район", electricity: true, equipment: true, transport: true),
         Worker(name: "Дядя Ваня", info: "Умелец на все руки", image: "Worker2", rating: "Rating 3", location: "Московская область, Чеховский район, СНТ Солнечное", electricity: false, equipment: true, transport: false),
         Worker(name: "Джамшут", info: "всё могу, только дай", image: "Worker3", rating: "Rating 2", location: "Московская область, Дмитровский район, село Голиково", electricity: false, equipment: false, transport: false)
      ]
   }
}
