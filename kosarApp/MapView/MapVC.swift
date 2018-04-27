//
//  ViewController.swift
//  kosarApp
//
//  Created by Владимир Микищенко on 03.03.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit
import GoogleMaps

var typeChoiceIsDone = false
var orderIsActive = false
var offerIsActive = false
var infoAlertIsActive = false
var orderAlertIsActive = false
var offerAlertIsActive = false

class MapViewController: UIViewController, GMSMapViewDelegate {
   
   @IBOutlet var buttonItems: [UIButton]!
   @IBOutlet weak var mapView: GMSMapView!
   
   var locationManager = CLLocationManager()
   var zoomLevel: Float = 15.0
   let workers = SampleData.generateWorkerData()
   let clients = SampleData.generateClientData()
   // создание отдельной кнопки ИНФО
   var oneInfoButton = UIButton()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // сглаживание углов у кнопок
      buttonItems.forEach { (button) in
         button.layer.cornerRadius = 12
      }
      // работа с картой
      locationManager.requestWhenInUseAuthorization()
      locationManager.startUpdatingLocation()
      locationManager.delegate = self
      mapView.delegate = self
      mapView.isMyLocationEnabled = true
      mapView.settings.myLocationButton = true
   }
   
   // Handle incoming location events.
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      let location: CLLocation = locations.last!
      print("Location: \(location)")
      
      let camera = GMSCameraPosition.camera(withLatitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude,
                                            zoom: zoomLevel)
      if mapView.isHidden {
         mapView.isHidden = false
         mapView.camera = camera
      } else {
         mapView.animate(to: camera)
      }
      // отображение Пользователя на карте
      let position = CLLocationCoordinate2D(latitude: location.coordinate.latitude,
                                            longitude: location.coordinate.longitude)
      let user = GMSMarker(position: position)
      user.icon = UIImage(named: "userAvatar")
      user.map = mapView
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
      guard infoAlertIsActive == false || orderAlertIsActive == false || offerAlertIsActive == false
         else { return }
      self.view.addSubview(oneInfoButton)
      // отображение остальных объектов на карте
      if user.type == .client {
         for worker in workers {
            setMapObject(imageName: worker.image!, latitude: worker.latitude!, longitude: worker.longitude!)
         }
      } else {
         for client in clients {
            setMapObject(imageName: client.image!, latitude: client.latitude!, longitude: client.longitude!)
         }
      }
   }
   
   // MARK: - Отображение объекта на карте
   fileprivate func setMapObject(imageName: String, latitude: Float, longitude: Float) {
      let position = CLLocationCoordinate2D(latitude: CLLocationDegrees(latitude),
                                            longitude: CLLocationDegrees(longitude))
      let mapObject = GMSMarker(position: position)
      mapObject.icon = UIImage(named: String(imageName))
      mapObject.map = mapView
   }

   // MARK: - При нажатии на любой объект на карте
   func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
      switch marker.icon {
      case UIImage(named: "Worker1"):
         popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
      case UIImage(named: "Worker2"):
         popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
      case UIImage(named: "Worker3"):
         popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
      case UIImage(named: "Worker4"):
         popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
      case UIImage(named: "Client1"):
         popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
      case UIImage(named: "Client2"):
         popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
      case UIImage(named: "Client3"):
         popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
      case UIImage(named: "Client4"):
         popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
     default:
         popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC",
                   heightPopoverVC: orderIsActive || offerIsActive ? 214 : 170)
      }
      return false
   }

   // MARK: - Кнопки
   @objc func oneInfoButtonPressed(_ sender: UIButton) {
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC",
                heightPopoverVC: orderIsActive || offerIsActive ? 214 : 170)
   }
   
   @IBAction func clientButton(_ sender: UIButton) {
      typeChoice()
      user.type = .client
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC", heightPopoverVC: orderIsActive ? 214 : 170)
   }
   
   @IBAction func workerButton(_ sender: UIButton) {
      typeChoice()
      user.type = .worker
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC", heightPopoverVC: offerIsActive ? 214 : 170)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
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
