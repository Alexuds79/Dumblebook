//
//  ShieldsViewController.swift
//  DumbleBook
//
//  Created by Alejandro Mateos on 24/12/2019.
//  Copyright © 2019 Alejandro Mateos. All rights reserved.
//

import UIKit

class ShieldsViewController: UIViewController {

    var houseName : String = ""
    var house = House.sharedInstance
    
    var firstViewH = true
    var firstViewR = true
    var firstViewS = true
    
    @IBOutlet weak var shieldImage: UIImageView!
    @IBOutlet weak var studentsNumberLabel: UILabel!
    
    
    //MARK: - Código ejecutado tras la carga de la ventana
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.2863, green: 0, blue: 0, alpha: 1.0)
        
        //Si es la primera vez que aparece la ventana, se asigna a houseName el nombre Gryffindor porque es la primera que se ve
        if houseName == ""{
            houseName = "Gryffindor"
        }
    }
    
    //MARK: - Código ejecutado cada vez que aparece la ventana
    /** Se da valor a la imagen del escudo correspondiente y a la etiqueta de número de alumnos **/
    override func viewWillAppear(_ animated: Bool) {
        shieldImage.image = UIImage(named: houseName + ".png")
        studentsNumberLabel.text = String(house.studentsCount(houseName: houseName)) + " Students"
        studentsNumberLabel.textColor = UIColor.white
    }
    
    
    //MARK: - Método gestor del 'control segmentado' que permite cambiar entre casas
    @IBAction func houseSelection(_ sender: UISegmentedControl) {
        houseName = sender.titleForSegment(at: sender.selectedSegmentIndex)!
        
        shieldImage.image = UIImage(named: houseName + ".png")
        studentsNumberLabel.text = String(house.studentsCount(houseName: houseName)) + " Students"
        studentsNumberLabel.textColor = UIColor.white
    }
    
}
