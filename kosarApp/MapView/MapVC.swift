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

class MapViewController: UIViewController {
   
   let locationManager = CLLocationManager()
   
   @IBOutlet weak var clientButton: UIButton!
   @IBOutlet weak var workerButton: UIButton!
   @IBOutlet weak var aboutButton: UIButton!
   @IBOutlet weak var mapView: GMSMapView!
   // создание отдельной кнопки ИНФО
   var oneInfoButton = UIButton()
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      // сглаживание углов у кнопок
      clientButton.layer.cornerRadius = 12
      workerButton.layer.cornerRadius = 12
      aboutButton.layer.cornerRadius = 12
      
      // работа с картой
      mapView.delegate = self as? GMSMapViewDelegate
      locationManager.delegate = self
      locationManager.requestWhenInUseAuthorization()
      mapView.isMyLocationEnabled = true
      mapView.settings.myLocationButton = true

      // The myLocation attribute of the mapView may be null
      if let mylocation = mapView.myLocation {
         print("User's location: \(mylocation)")
      } else {
         print("User's location is unknown")
      }
      
      let position = CLLocationCoordinate2D(latitude: 55.755761, longitude: 37.617813)
      let user = GMSMarker(position: position)
      user.title = "USER"
      user.icon = UIImage(named: "userAvatar")
      user.map = mapView
      
      //      let mapInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 160.0, right: 0.0)
      //      mapView.padding = mapInsets
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
      clientButton.isHidden = true
      workerButton.isHidden = true
      aboutButton.isHidden = true
      customeNavBar(viewController: self)
      //      mapView.padding = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
      
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
   }
   
   // MARK: - Кнопки
   @objc func oneInfoButtonPressed(_ sender: UIButton) {
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC",
                heightPopoverVC: orderIsActive || offerIsActive ? 214 : 170)
   }
   
   @IBAction func contractorButton(_ sender: UIBarButtonItem) {
//      self.mapView.settings.myLocationButton = false
      popoverVC(currentVC: self, identifierPopoverVC: "ContractorInfoTVC", heightPopoverVC: 132)
   }
   
   @IBAction func clientButton(_ sender: UIButton) {
      typeChoice()
      user.type = .client
//      self.mapView.settings.myLocationButton = false
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC", heightPopoverVC: orderIsActive ? 214 : 170)
   }
   
   @IBAction func workerButton(_ sender: UIButton) {
      typeChoice()
      user.type = .worker
//      self.mapView.settings.myLocationButton = false
      popoverVC(currentVC: self, identifierPopoverVC: "InfoTVC", heightPopoverVC: offerIsActive ? 214 : 170)
   }
   
   override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
   }
}

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

// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate {
   // вызывается, когда пользователь предоставляет или не предоставляет вам право определения его местоположение.
   private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
      // если разрешение дано
      guard status == .authorizedWhenInUse else { return }
      // обновление местоположения
      print("Расширение работает")
      locationManager.startUpdatingLocation()
   }
   
   // выполняется, когда location manager получает новые данные о местоположении.
   private func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let location = locations.first else { return }
      mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
      locationManager.stopUpdatingLocation()
   }
}
