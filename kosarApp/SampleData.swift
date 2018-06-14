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
         User(type: .client, image: "avatarDefault")
   }
   
   static func generateAvatars() -> [String] {
      return [
         "01", "02", "03", "04", "05", "06", "07", "08", "09", "10",
         "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
         "21", "22", "23", "24", "25", "26", "27", "28", "29", "30",
         "31", "32", "33", "34", "35", "36", "37", "38", "39", "40",
         "41", "42", "43", "44", "45", "46", "47", "48", "49", "50",
         "51", "52", "53", "54", "55", "56", "57", "58", "59", "60",
         "61", "62", "63", "64", "65", "66", "67", "68", "69", "70",
         "71", "72", "73", "74", "75", "76", "77", "78"
      ]
   }
   
//   static func generateUserHistoryData() -> [Contractor] {
//      let historyDate = Date()
//      return [
//         Contractor(photo: "Worker1", name: "Фёдор КОСОРЕЗОВ",
//                    date: historyDate.from("15.03.2018")!, rating: "Rating 5", iD: 5),
//         Contractor(photo: "Worker1", name: "Фёдор КОСОРЕЗОВ",
//                    date: historyDate.from("01.03.2018")!, rating: "Rating 4", iD: 5),
//         Contractor(photo: "Worker3", name: "Джамшут",
//                    date: historyDate.from("10.02.2018")!, rating: "Rating 5", iD: 7),
//         Contractor(photo: "Worker4", name: "Равшан",
//                    date: historyDate.from("24.04.2018")!, rating: nil, iD: 8)
//      ]
//   }

   // MARK: All data about our Partners in start
   static func generatePartnersData() -> [userID:Partner] {
      return [
         1:Partner(type: .client, price: 500, name: "Максим РЯБУХИН", info: "Владелец ранчо ПОЗИТИВ", image: "45",
                   rating: "Rating 4", location: "Московская область, Дмитровский район, деревня Никульское",
                   electricity: true, equipment: true, transport: true, workArea: 6, plants: true, hardRelief: true,
                   latitude: 55.796307, longitude: 37.684729, phoneNumber: "+70123456789", distance: 0.0),
         2:Partner(type: .client, price: 400, name: "Володя МИКИЩЕНКО", info: "тот еще удачник", image: "49",
                   rating: "Rating 3", location: "Московская область, Чеховский район, СНТ Солнечное",
                   electricity: true, equipment: true, transport: true, workArea: 8, plants: true, hardRelief: false,
                   latitude: 55.726543, longitude: 37.583806, phoneNumber: "+70123456789", distance: 0.0),
         3:Partner(type: .client, price: 500, name: "Дима НОСОВИЦКИЙ", info: "владелец усадьбы", image: "23",
                   rating: "Rating 5", location: "Ленинградская область, Всеволожский район, Лесколовское сельское поселение",
                   electricity: true, equipment: true, transport: true, workArea: 4, plants: true, hardRelief: true,
                   latitude: 55.784841, longitude: 37.600271, phoneNumber: "+70123456789", distance: 0.0),
         4:Partner(type: .client, price: 500, name: "Таня МИКИЩЕНКО", info: "наследная прынцесса", image: "48",
                   rating: "Rating 5", location: "Московская область, Чеховский район, СНТ Солнечное",
                   electricity: true, equipment: true, transport: true, workArea: 4, plants: true, hardRelief: true,
                   latitude: 55.797711, longitude: 37.605705, phoneNumber: "+70123456789", distance: 0.0),
         5:Partner(type: .worker, price: 500, name: "Фёдор КОСОРЕЗОВ", info: "Косарь от бога",image: "04",
                   rating: "Rating 5", location: "Московская область, Дмитровский район",
                   electricity: true, equipment: true, transport: true, workArea: nil, plants: nil, hardRelief: nil,
                   latitude: 55.696307, longitude: 37.554729, phoneNumber: "+70123456789", distance: 0.0),
         6:Partner(type: .worker, price: 600, name: "Дядя Ваня", info: "Умелец на все руки", image: "03",
                   rating: "Rating 3", location: "Московская область, Чеховский район, СНТ Солнечное",
                   electricity: false, equipment: true, transport: false, workArea: nil, plants: nil, hardRelief: nil,
                   latitude: 55.816543, longitude: 37.583806, phoneNumber: "+70123456789", distance: 0.0),
         7:Partner(type: .worker, price: 450, name: "Джамшут", info: "всё могу, только дай", image: "05",
                   rating: "Rating 2", location: "Московская область, Дмитровский район, село Голиково",
                   electricity: false, equipment: false, transport: false, workArea: nil, plants: nil, hardRelief: nil,
                   latitude: 55.804841, longitude: 37.620271, phoneNumber: "+70123456789", distance: 0.0),
         8:Partner(type: .worker, price: 460, name: "Равшан", info: "всё могу начальника", image: "01",
                   rating: "Rating 3", location: "Московская область, Дмитровский район, село Голиково",
                   electricity: false, equipment: false, transport: false, workArea: nil, plants: nil, hardRelief: nil,
                   latitude: 55.707711, longitude: 37.515705, phoneNumber: "+70123456789", distance: 0.0),
         9:Partner(type: .worker, price: 550, name: "Йода", info: "всё могу начальника", image: "02",
                   rating: "Rating 3", location: "Московская область, Дмитровский район, село Голиково",
                   electricity: false, equipment: false, transport: false, workArea: nil, plants: nil, hardRelief: nil,
                   latitude: 55.842086, longitude: 37.615705, phoneNumber: "+70123456789", distance: 0.0),
         10:Partner(type: .client, price: 480, name: "Энакен Скайуокер", info: "Красная Армия всех сильней", image: "23",
                    rating: "Rating 5", location: "Московская область, Дмитровский район, село Голиково",
                    electricity: true, equipment: true, transport: false, workArea: 3, plants: true, hardRelief: true,
                    latitude: 55.665786, longitude: 37.615705, phoneNumber: "+70123456789", distance: 0.0),
         11:Partner(type: .worker, price: 550, name: "Оби Ван Кэноби", info: "всё могу начальника", image: "35",
                   rating: "Rating 3", location: "Московская область, Дмитровский район, село Голиково",
                   electricity: false, equipment: false, transport: false, workArea: nil, plants: nil, hardRelief: nil,
                   latitude: 55.700000, longitude: 37.465705, phoneNumber: "+70123456789", distance: 0.0),
         12:Partner(type: .client, price: 500, name: "Падме Амидала", info: "наследная прынцесса", image: "48",
                   rating: "Rating 5", location: "Московская область, Чеховский район, СНТ Солнечное",
                   electricity: true, equipment: true, transport: true, workArea: 4, plants: true, hardRelief: true,
                   latitude: 55.757711, longitude: 37.489391, phoneNumber: "+70123456789", distance: 0.0),
         13:Partner(type: .worker, price: 500, name: "Чубака", info: "Косарь от бога",image: "20",
                   rating: "Rating 5", location: "Московская область, Дмитровский район",
                   electricity: true, equipment: true, transport: true, workArea: nil, plants: nil, hardRelief: nil,
                   latitude: 55.756307, longitude: 37.7400, phoneNumber: "+70123456789", distance: 0.0)
      ]
   }
}
