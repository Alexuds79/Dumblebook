//
//  DetailViewController.swift
//  DumbleBook
//
//  Created by Alejandro Mateos on 20/12/2019.
//  Copyright © 2019 Alejandro Mateos. All rights reserved.
//
// Brief: Controlador de la vista de detalle.

import UIKit

class DetailViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    //MARK: - Declaración de objetos
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var SurnameTextField: UITextField!
    @IBOutlet weak var StudentImage: UIImageView!
    @IBOutlet weak var SaveButton: UIBarButtonItem!
    
    
    //MARK: - Atributos de clase
    var house = House.sharedInstance
    var detailItem : String?
    var name : String = ""
    var surname : String = ""
    var oldName : String = ""
    var oldSurname : String = ""
    var row : Int = -1
    var houseName : String = ""
    
    var tapGestureRecognizer = UIGestureRecognizer()
    let imagePicker : UIImagePickerController = UIImagePickerController()

    
    //MARK: - Código que se ejecuta una vez que se produce la carga de la ventana
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(red: 0.2863, green: 0, blue: 0, alpha: 1.0)
        
        //Dibujado de la imagen del estudiante
        if let StudentImage = StudentImage{
            let imageName = name.replacingOccurrences(of: " ", with: "") + surname.replacingOccurrences(of: " ", with: "") + ".jpg"
            
            var image = UIImage(named: imageName)
            
            if row >= 0{
                switch(houseName){
                    case "Gryffindor":
                        if let sImage = house.gryffindorStudents[row].newImage{
                            image = sImage
                        }
                    
                    case "Hufflepuff":
                        if let sImage = house.hufflepuffStudents[row].newImage{
                            image = sImage
                        }
                    
                    case "Ravenclaw":
                        if let sImage = house.ravenclawStudents[row].newImage{
                            image = sImage
                        }
                    
                    case "Slytherin":
                        if let sImage = house.slytherinStudents[row].newImage{
                            image = sImage
                        }
                    
                    default: break
                }
            }
            
            //Si existe imagen nueva del estudiante en la 'memoria' de la aplicación, se reasigna
            if let _ = UserDefaults.standard.object(forKey: name + " " + surname){
                let data = UserDefaults.standard.object(forKey: name + " " + surname) as! NSData
                image = UIImage(data: data as Data)!
            }
            
            StudentImage.image = image?.squareImageMask
        }
        
        
        //Valores para los cuadros de texto
        if let NameTextField = NameTextField, let SurnameTextField = SurnameTextField {
            NameTextField.text = name
            SurnameTextField.text = surname
        }
        
        
        //Se capturan las acciones del usuario sobre el textField a través de delegados
        NameTextField.delegate = self
        SurnameTextField.delegate = self
        
        oldName = name
        oldSurname = surname
        
        //ImageView tap: acción a realizar si el usuario hace click sobre la imagen
        imagePicker.delegate = self
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        StudentImage.isUserInteractionEnabled = true
        StudentImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    //MARK: - Método delegado del textField
    func textFieldDidChangeSelection(_ textField: UITextField) {
        name = NameTextField.text!
        surname = SurnameTextField.text!
        
        //Si no se escribe texto en cualquiera de los textField, se impide guardar
        if name.count == 0 || surname.count == 0{
            SaveButton.isEnabled = false
        }
        else{
            SaveButton.isEnabled = true
        }
    }
    
    
    
    //MARK: - Método asociado al click sobre la imgen
    /** Si existe cámara, se usa esta. En caso contrario se permite acceder a la galería para tomar una imagen guardada **/
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        //Cámara...
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            if UIImagePickerController.availableCaptureModes(for: .front) != nil{
                imagePicker.allowsEditing = false
                imagePicker.sourceType = .camera
                imagePicker.cameraCaptureMode = .photo
                
                present(imagePicker, animated: true, completion: nil)
            }
        }
        
        //Librería (cámara no disponible)
        else if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .photoLibrary
            
            present(imagePicker, animated: true, completion: nil)
        }
    }
    
    /** Función controladora del imagePicker **/
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage : UIImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            StudentImage.image = selectedImage
            
            if(imagePicker.sourceType == .camera){
                UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil) //Guardando la foto en la librería...
            }
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
}


