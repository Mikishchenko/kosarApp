//
//  SplashViewController.swift
//  kosar01
//
//  Created by Владимир Микищенко on 27.02.2018.
//  Copyright © 2018 Vladimir Mikishchenko. All rights reserved.
//

import UIKit

class SplashViewController: UIViewController {

   @IBOutlet weak var splashScreenImage: UIImageView!
   @IBOutlet weak var splashButton: UIButton!
   
   // создаем два массива: названий сплэшэкранов и кнопок для перехода на следующий экран
   let arrayScreens = [ "aboutScreen2", "aboutScreen3" , "aboutScreen4" , "aboutScreen5"]
   let arrayButtons = [ "splashButton2" , "splashButton3" , "splashButton4" , "splashButton5" ]
 
   var index: (Int) = 0

   @IBAction func splashButtonPressed(_ sender: UIButton) {
   // при нажатии на кнопочки внизу сплэшэкрана отображается следующий экран и следующая кнопка из двух массивов
      if index < 4 { // всего экранов 5, первый в массив не включал. Проверка на извлечение существующего экрана
         splashScreenImage.image = UIImage(named: arrayScreens[index])
         splashButton.setBackgroundImage(UIImage(named: arrayButtons[index]), for: .normal)
         index += 1
      }
      return
   }
   
   override func viewDidLoad() {
        super.viewDidLoad()
      // отображение первого экрана и первой кнопки на сплэшах
      splashScreenImage.image = UIImage(named: "aboutScreen1")
      splashButton.setBackgroundImage(UIImage(named: "splashButton1"), for: .normal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(true)
      // включение NavigationBar на текущем ViewController, полупрозрачный, изменение цвета символов
      customeNavBar(viewController: self)
   }
}
