//
//  ViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 03.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

// MARK: - Глобальные переменные
var typeChoiceIsDone = false
var orderOfferIsActive = false
var infoAlertIsActive = false
var orderOfferAlertIsActive = false
var searchArea: Double = 10.0
var zoomLevel: Float = 11.0
var partnerID: userID?

// MARK: - Данные о ближайших партнерах из SampleData
let partners = SampleData.generatePartnersData()

class MapViewController: UIViewController, GMSMapViewDelegate {
   
   @IBOutlet var buttonItems: [UIButton]!
   @IBOutlet weak var mapView: GMSMapView!
   
   var locationManager = CLLocationManager()
   // создание отдельной кнопки ИНФО
   var oneInfoButton = UIButton()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      // сглаживание углов у кнопок
      buttonItems.forEach { (button) in
         button.layer.cornerRadius = 12
      }
      // старт отслеживания геопозиции пользователя, объявление делегатов и MyLocationButton
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      locationManager.delegate = self
      mapView.delegate = self
      mapView.isMyLocationEnabled = true
      mapView.settings.setAllGesturesEnabled(true)
   }
   
   // Handle incoming location events.
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location: CLLocation = locations.last!
      print("Location: \(location)")
      // сохранения координат пользователя
      user.latitude = location.coordinate.latitude
      user.longitude = location.coordinate.longitude
      // настройка камеры для отображения карты
      setCameraPosition(latitude: user.latitude,
                        longitude: user.longitude, zoom: zoomLevel)
      mapView.clear()
      // отображение Пользователя на карте
      setMapMarker(markerKey: 0, markerIcon: "userAvatar",
                   latitude: user.latitude!, longitude: user.longitude!)
   }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      // чтобы кнопки не появлялись после совершения выбора типа пользователя
      typeChoiceIsDone ? (typeChoice()) : (self.navigationController?.navigationBar.isHidden = true)
   }
   
   override func viewDidAppear(_ animated: Bool) {
      super.viewDidAppear(true)
      // выключение NavigationBar на текущем ViewController до совершения выбора типа
      typeChoiceIsDone ? (typeChoice()) : (self.navigationController?.navigationBar.isHidden = true)
   }
   
   // MARK: - Изменение представления после выбора типа пользователя
   func typeChoice () {
      typeChoiceIsDone = true
      buttonItems.forEach { (button) in
         button.isHidden = true
      }
      customeNavBar(viewController: self)
      
      // про кнопку ИНФО
      oneInfoButton = UIButton(type: .roundedRect)
      oneInfoButton.frame = CGRect(x: 10, y: self.view.bounds.maxY - 67,
                                   width: self.view.bounds.width - 20, height: 44)
      oneInfoButton.backgroundColor = #colorLiteral(red: 0.5411764706, green: 0.7058823529, blue: 0.2745098039, alpha: 1)
      oneInfoButton.layer.cornerRadius = 12
      oneInfoButton.setTitle("Информация", for: .normal)
      oneInfoButton.setTitleColor(UIColor.white, for: .normal)
      oneInfoButton.titleLabel?.font = UIFont?(.systemFont(ofSize: 18))
      oneInfoButton.addTarget(self, action: #selector(oneInfoButtonPressed(_:)), for: .touchUpInside)
      guard infoAlertIsActive == false || orderOfferAlertIsActive == false else { return }
      self.view.addSubview(oneInfoButton)
      // отображение остальных объектов на карте
      for partner in partners {
         let partnerType: Type = ((user.type == .client) ? .worker : .client)
         guard partner.value.type == partnerType else { continue }
         // установка дистанции у партнера
         let userPosition = CLLocationCoordinate2D(latitude: user.latitude!, longitude: user.longitude!)
         let partnerPosition = CLLocationCoordinate2D(latitude: partner.value.latitude!,
                                                      longitude: partner.value.longitude!)
         partner.value.distance = Double(round(10*GMSGeometryDistance(userPosition, partnerPosition)/1000)/10)
         // проверка, не привышает ли дистанция до партнера зоны поиска
         guard partner.value.distance! <= searchArea else { continue }
         setMapMarker(markerKey: partner.key, markerIcon: partner.value.image!,
                      latitude: partner.value.latitude!, longitude: partner.value.longitude!)
      }
   }
   
   // MARK: - Отображение объекта на карте
   fileprivate func setMapMarker(markerKey: userID, markerIcon: String, latitude: Double, longitude: Double) {
      let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                            longitude: CLLocationDegrees(longitude))
      let marker = GMSMarker(position: position)
      marker.userData = String(markerKey)
      marker.icon = UIImage(named: String(markerIcon))
      marker.map = mapView
   }
   
   // MARK: - При нажатии на любой объект на карте выводится на экран всплывающее окно
   func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      for partner in partners{
         let partnerType: Type = ((user.type == .client) ? .worker : .client)
         guard partner.value.type == partnerType else { continue }
         switch marker.userData as! String {
         case String(partner.key):
            partnerID = partner.key
         case "0":
            popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC",
                      heightPopoverVC: (searchArea < 30) || orderOfferIsActive ? 214 : 170)
            return false
         default:
            continue
         }
      }
      popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
      return false
   }
   
   // MARK: - Настройка камеры, для отображения карты
   fileprivate func setCameraPosition(latitude: Double?, longitude: Double?, zoom: Float) {
      let camera = GMSCameraPosition.camera(withLatitude: latitude!,
                                            longitude: longitude!, zoom: zoom)
      if mapView.isHidden {
         mapView.isHidden = false
         mapView.camera = camera
      } else {
         mapView.animate(to: camera)
      }
   }
   
   // MARK: - Кнопки
   @objc func oneInfoButtonPressed(_ sender: UIButton) {
      typeChoice()
      setCameraPosition(latitude: user.latitude, longitude: user.longitude, zoom: zoomLevel)
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC",
                heightPopoverVC: (searchArea < 30) || orderOfferIsActive ? 214 : 170)
   }
   
   @IBAction func clientButton(_ sender: UIButton) {
      user.type = .client
      typeChoice()
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC",
                heightPopoverVC: (searchArea < 30) || orderOfferIsActive ? 214 : 170)
   }
   
   @IBAction func workerButton(_ sender: UIButton) {
      user.type = .worker
      typeChoice()
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC",
                heightPopoverVC: (searchArea < 30) || orderOfferIsActive ? 214 : 170)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}

// MARK: - Геокодирование (получение адреса по имеющимся координатам)
public func reverseGeocodeCoordinate(_ coordinate: CLLocationCoordinate2D) {
   let geocoder = GMSGeocoder()
   geocoder.reverseGeocodeCoordinate(coordinate) { response, error in
      guard let address = response?.firstResult() , let lines = address.lines else {
         return
      }
      user.location = lines.joined()
      print(user.location!)
   }
}

// MARK: - Пользовательский navBar полупрозрачный и с темными Items
public func customeNavBar(viewController: UIViewController) {
   let navigationBar = viewController.navigationController?.navigationBar
   navigationBar?.isHidden = false
   navigationBar?.alpha = 0.7
   navigationBar?.isTranslucent = true
   navigationBar?.tintColor = #colorLiteral(red: 0.02745098039, green: 0.1647058824, blue: 0.0862745098, alpha: 1)
}

// MARK: - Всплывающее окно
public func popoverVC(currentVC: UIViewController, identifierPopoverVC: String, heightPopoverVC: CGFloat) {
   guard let popoverTVC = currentVC.storyboard?.instantiateViewController(withIdentifier: identifierPopoverVC)
      else { return }
   // выбор типа контроллера
   popoverTVC.modalPresentationStyle = .popover
   let popoverTableVC = popoverTVC.popoverPresentationController
   // назначение делегатом
   popoverTableVC?.delegate = currentVC as? UIPopoverPresentationControllerDelegate
   // отключение стрелочки у popoverController
   popoverTableVC?.sourceView = currentVC.view
   popoverTableVC?.permittedArrowDirections = UIPopoverArrowDirection(rawValue: 0)
   // начальная точка popoverController (левая нижняя)
   popoverTableVC?.sourceRect = CGRect(x: 10, y: currentVC.view.bounds.maxY, width: 0, height: 0)
   // размеры popoverController
   popoverTVC.preferredContentSize = CGSize(width: currentVC.view.bounds.width, height: heightPopoverVC)
   // презентация контроллера
   currentVC.present(popoverTVC, animated: true)
}

// MARK: - Для корректной отработки всплывающих окон, иначе они растягиваются на весь экран
extension MapViewController: UIPopoverPresentationControllerDelegate {
   func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
      return .none
   }
}

// Delegates to handle events for the location manager.
extension MapViewController: CLLocationManagerDelegate {
   
   // Handle authorization for the location manager.
   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      switch status {
      case .restricted:
         print("Location access was restricted.")
      case .denied:
         print("User denied access to location.")
         // Display the map using the default location.
         mapView.isHidden = false
      case .notDetermined:
         print("Location status not determined.")
      case .authorizedAlways: fallthrough
      case .authorizedWhenInUse:
         print("Location status is OK.")
      }
   }
   
   // Handle location manager errors.
   func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
      locationManager.stopUpdatingLocation()
      print("Error: \(error)")
   }
}
