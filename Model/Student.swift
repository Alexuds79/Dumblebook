//
//  Student.swift
//  DumbleBook
//
//  Created by Alejandro Mateos on 22/12/2019.
//  Copyright © 2019 Alejandro Mateos. All rights reserved.
//

import Foundation
import UIKit


// MARK: - Clase útil para la creación de nuevos estudiantes
/** Uso de Codable para la gestión de persistencia **/

class Student : Codable{
    var name : String = ""
    var surname : String = ""
    var houseName: String = ""
    var shortName: String = ""
    var userName: String = ""
    var passWord : String = ""
    var imageName: String = ""
    
    var newImage: UIImage? = nil
    
    init(){
    }
    
    
    //MARK: -Método inicializador de estudiantes (a partir del nombre, apellido y casa se genera valor automático para el resto de parámetros)
    /**
     * name: Harry James
     * surname: Potter
     * houseName: Gryffindor
     *
     * shortName: Potter, H.
     * userName: HarryJamesPotter
     * passWord: GryffindorPotter
     * imageName: HarryJamesPotter.jpg
     */
    init(name: String, surname: String, houseName: String){
        self.name = name
        self.surname = surname
        self.houseName = houseName
        self.shortName = surname + ", " + String(name.first!) + "."
        
        self.userName = name.replacingOccurrences(of: " ", with: "") + surname.replacingOccurrences(of: " ", with: "")
        self.passWord = houseName + surname.replacingOccurrences(of: " ", with: "")
        self.imageName = name.replacingOccurrences(of: " ", with: "") + surname.replacingOccurrences(of: " ", with: "") + ".jpg"
        
        //Si la imagen fue cambiada, se recoge de la 'memoria' de aplicación
        if let _ = UserDefaults.standard.object(forKey: name+surname){
            let data = UserDefaults.standard.object(forKey: name+surname) as! NSData
            self.newImage = UIImage(data: data as Data)
        }
        else{
            self.newImage = nil
        }

    }
    
    
    //MARK: - Uso de Codable para guardar información en el archivo JSON de estudiantes
    enum CodingKeys: String, CodingKey{
        case name
        case surname
        case houseName
        case shortName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        try container.encode(name, forKey: .name)
        try container.encode(surname, forKey: .surname)
        try container.encode(houseName, forKey: .houseName)
        try container.encode(shortName, forKey: .shortName)
    }
}
