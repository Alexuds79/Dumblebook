//
//  AddStudentViewController.swift
//  DumbleBook
//
//  Created by Alejandro Mateos on 22/12/2019.
//  Copyright © 2019 Alejandro Mateos. All rights reserved.
//

import UIKit

class AddStudentViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var SurnameTextField: UITextField!
    
    var name : String?
    var surname : String?
    
    //MARK: - Código ejecutado tras la carga de la ventana
    override func viewDidLoad() {
        super.viewDidLoad()

        NameTextField.text = name
        SurnameTextField.text = surname

        //Se captura la interacción del usuario mediante delegados
        NameTextField.delegate = self
        SurnameTextField.delegate = self
    }
    
    //MARK: - Método delegado de los textField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        name = NameTextField.text
        surname = SurnameTextField.text
    }
}
