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
      let historyDate = Date()
      return [
         Contractor(photo: "Worker1", name: "Фёдор КОСОРЕЗОВ",
                    date: historyDate.from("15.03.2018")!, rating: "Rating 5", iD: 5),
         Contractor(photo: "Worker1", name: "Фёдор КОСОРЕЗОВ",
                    date: historyDate.from("01.03.2018")!, rating: "Rating 4", iD: 5),
         Contractor(photo: "Worker3", name: "Джамшут",
                    date: historyDate.from("10.02.2018")!, rating: "Rating 5", iD: 7),
         Contractor(photo: "Worker4", name: "Равшан",
                    date: historyDate.from("24.04.2018")!, rating: nil, iD: 8)
      ]
   }
   
   static func generateUserSettingsData() -> UserSettings {
      return
         UserSettings(geoposition: false, photos: false, camera: false,
                      phone: false, messages: false, microphone: false)
   }
   
   // MARK: All data about our Partners in start
   static func generatePartnersData() -> [userID:Partner] {
      return [
         1:Partner(type: .client, price: 500, name: "Максим РЯБУХИН", info: "Владелец ранчо ПОЗИТИВ", image: "Client1",
            rating: "Rating 4", location: "Московская область, Дмитровский район, деревня Никульское",
            electricity: true, equipment: true, transport: true, workArea: 6, plants: true, hardRelief: true,
            latitude: 55.756307, longitude: 37.614729),
         2:Partner(type: .client, price: 500, name: "Володя МИКИЩЕНКО", info: "тот еще удачник", image: "Client3",
            rating: "Rating 3", location: "Московская область, Чеховский район, СНТ Солнечное",
            electricity: true, equipment: true, transport: true, workArea: 8, plants: true, hardRelief: false,
            latitude: 55.756543, longitude: 37.613806),
         3:Partner(type: .client, price: 500, name: "Дима НОСОВИЦКИЙ", info: "владелец усадьбы", image: "Client4",
            rating: "Rating 5", location: "Ленинградская область, Всеволожский район, Лесколовское сельское поселение",
            electricity: true, equipment: true, transport: true, workArea: 4, plants: true, hardRelief: true,
            latitude: 55.754841, longitude: 37.620271),
         4:Partner(type: .client, price: 500, name: "Таня МИКИЩЕНКО", info: "наследная прынцесса", image: "Client2",
            rating: "Rating 5", location: "Московская область, Чеховский район, СНТ Солнечное",
            electricity: true, equipment: true, transport: true, workArea: 4, plants: true, hardRelief: true,
            latitude: 55.757711, longitude: 37.615705),
         5:Partner(type: .worker, price: 500, name: "Фёдор КОСОРЕЗОВ", info: "Косарь от бога",image: "Worker1",
            rating: "Rating 5", location: "Московская область, Дмитровский район",
            electricity: true, equipment: true, transport: true, workArea: nil, plants: nil, hardRelief: nil,
            latitude: 55.756307, longitude: 37.614729),
         6:Partner(type: .worker, price: 600, name: "Дядя Ваня", info: "Умелец на все руки", image: "Worker2",
            rating: "Rating 3", location: "Московская область, Чеховский район, СНТ Солнечное",
            electricity: false, equipment: true, transport: false, workArea: nil, plants: nil, hardRelief: nil,
            latitude: 55.756543, longitude: 37.613806),
         7:Partner(type: .worker, price: 450, name: "Джамшут", info: "всё могу, только дай", image: "Worker3",
            rating: "Rating 2", location: "Московская область, Дмитровский район, село Голиково",
            electricity: false, equipment: false, transport: false, workArea: nil, plants: nil, hardRelief: nil,
            latitude: 55.754841, longitude: 37.620271),
         8:Partner(type: .worker, price: 400, name: "Равшан", info: "всё могу начальника", image: "Worker4",
            rating: "Rating 3", location: "Московская область, Дмитровский район, село Голиково",
            electricity: false, equipment: false, transport: false, workArea: nil, plants: nil, hardRelief: nil,
            latitude: 55.757711, longitude: 37.615705)
      ]
   }
}
