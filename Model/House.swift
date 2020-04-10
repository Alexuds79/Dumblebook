//
//  House.swift
//  DumbleBook
//
//  Created by Alejandro Mateos on 22/12/2019.
//  Copyright © 2019 Alejandro Mateos. All rights reserved.
//

import Foundation
import UIKit
import Firebase


//MARK: - Clase útil para la creación, edición y consulta de las respectivas casas
class House{
    var houseName : String = ""
    
    //Registros de cada casa por separado
    var gryffindorStudents: [Student] = []
    var hufflepuffStudents: [Student] = []
    var ravenclawStudents: [Student] = []
    var slytherinStudents: [Student] = []
    
    //Vector que guarda todos los nuevos estudiantes
    var allNewStudents: [Student] = []
    
    //Vector que guarda los estudiantes iniciales/preestablecidos
    var initialStudents: [Student] = []
    
    private var newStudent = Student()
    static let sharedInstance = House()
    
    //Lectura de la base de datos en cloud en la primera ejecución
    private init(){
        self.readStudentsFromFirebase(collectionName: "InitialStudents")
        self.readStudentsFromFirebase(collectionName: "NewStudents")
        self.readInitialStudentsFromFirebaseCollectionToVector()
    }
    
    func initHouses(){
    }
    
    //MARK: - Devuelve el número de estudiantes de la casa indicada
    func studentsCount(houseName :String) -> Int{
        switch(houseName){
            case "Gryffindor": return gryffindorStudents.count
            case "Hufflepuff": return hufflepuffStudents.count
            case "Ravenclaw": return ravenclawStudents.count
            case "Slytherin": return slytherinStudents.count
            default: return 0
        }
    }
    
    
    //MARK: - Adición de un estudiante a la casa indicada
    func addStudent(student :Student, houseName :String, index : Int){
        switch(houseName){
            case "Gryffindor": self.gryffindorStudents.insert(student, at: index)
            case "Hufflepuff": self.hufflepuffStudents.insert(student, at: index)
            case "Ravenclaw": self.ravenclawStudents.insert(student, at: index)
            case "Slytherin": self.slytherinStudents.insert(student, at: index)
            default: return
        }
        
        allNewStudents.append(student)
    }
    
    
    //MARK: - Edición de estudiantes
    func editStudent(student :Student, houseName :String, newName: String, newSurname :String) -> String{
        var studentFullName : String = ""
        
        switch(houseName){
            case "Gryffindor":
                for s in gryffindorStudents{
                    if s.name == student.name && s.surname == student.surname{
                        s.name = newName
                        s.surname = newSurname
                        s.shortName = newSurname + ", " + String(newName.first!) + "."
                        s.imageName = newName.replacingOccurrences(of: " ", with: "") + newSurname.replacingOccurrences(of: " ", with: "") + ".jpg"
                        
                        s.userName = newName.replacingOccurrences(of: " ", with: "") + newSurname.replacingOccurrences(of: " ", with: "")
                        s.passWord = houseName + newSurname.replacingOccurrences(of: " ", with: "")
                        
                        studentFullName = s.name + " " + s.surname
                        
                        if let index = allNewStudents.firstIndex(where: {$0.name == student.name && $0.surname == student.surname}){
                            allNewStudents[index].name = student.name
                            allNewStudents[index].surname = student.surname
                            allNewStudents[index].shortName = student.shortName
                        }
                        
                        break;
                    }
                }
            
            case "Hufflepuff":
                for s in hufflepuffStudents{
                    if s.name == student.name && s.surname == student.surname{
                        s.name = newName
                        s.surname = newSurname
                        s.shortName = newSurname + ", " + String(newName.first!) + "."
                        s.imageName = newName.replacingOccurrences(of: " ", with: "") + newSurname.replacingOccurrences(of: " ", with: "") + ".jpg"
                        
                        s.userName = newName.replacingOccurrences(of: " ", with: "") + newSurname.replacingOccurrences(of: " ", with: "")
                        s.passWord = houseName + newSurname.replacingOccurrences(of: " ", with: "")
                        
                        studentFullName = s.name + " " + s.surname
                        
                        if let index = allNewStudents.firstIndex(where: {$0.name == student.name && $0.surname == student.surname}){
                            allNewStudents[index].name = student.name
                            allNewStudents[index].surname = student.surname
                            allNewStudents[index].shortName = student.shortName
                        }
                        break;
                    }
                }
            
            case "Ravenclaw":
                for s in ravenclawStudents{
                    if s.name == student.name && s.surname == student.surname{
                        s.name = newName
                        s.surname = newSurname
                        s.shortName = newSurname + ", " + String(newName.first!) + "."
                        s.imageName = newName.replacingOccurrences(of: " ", with: "") + newSurname.replacingOccurrences(of: " ", with: "") + ".jpg"
                        
                        s.userName = newName.replacingOccurrences(of: " ", with: "") + newSurname.replacingOccurrences(of: " ", with: "")
                        s.passWord = houseName + newSurname.replacingOccurrences(of: " ", with: "")
                        
                        studentFullName = s.name + " " + s.surname
                        
                        if let index = allNewStudents.firstIndex(where: {$0.name == student.name && $0.surname == student.surname}){
                            allNewStudents[index].name = student.name
                            allNewStudents[index].surname = student.surname
                            allNewStudents[index].shortName = student.shortName
                        }
                        break;
                    }
                }
            
            case "Slytherin":
                for s in slytherinStudents{
                    if s.name == student.name && s.surname == student.surname{
                        s.name = newName
                        s.surname = newSurname
                        s.shortName = newSurname + ", " + String(newName.first!) + "."
                        s.imageName = newName.replacingOccurrences(of: " ", with: "") + newSurname.replacingOccurrences(of: " ", with: "") + ".jpg"
                        
                        s.userName = newName.replacingOccurrences(of: " ", with: "") + newSurname.replacingOccurrences(of: " ", with: "")
                        s.passWord = houseName + newSurname.replacingOccurrences(of: " ", with: "")
                        
                        studentFullName = s.name + " " + s.surname
                        
                        if let index = allNewStudents.firstIndex(where: {$0.name == student.name && $0.surname == student.surname}){
                            allNewStudents[index].name = student.name
                            allNewStudents[index].surname = student.surname
                            allNewStudents[index].shortName = student.shortName
                        }
                        break;
                    }
                }
            
            default: break
        }
        
        return studentFullName
    }
    
    
    //MARK: - Actualización del fichero de estudiantes
    
    func updateFileOfStudents(filename :String, data :[Student]){
        let jsonEncoder = JSONEncoder()
        jsonEncoder.outputFormatting = .prettyPrinted
        
        do{
            let data = try jsonEncoder.encode(data)
            
            // Write the json-encoded list to disk
            let path = getDocumentsDirectory().appendingPathComponent(filename)
            try data.write(to: path)
            
            print("Students updated at file in: \(path)")
            
        } catch{
            print("Failed to encode the students: \(error.localizedDescription)")
        }
    }
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    
    
    //MARK: - Métodos gestores de la base de datos en Cloud (Firebase)
    
    /** Lectura inicial de estudiantes **/
    func readStudentsFromFirebase(collectionName :String){
        let db = Firestore.firestore()
        let collection = db.collection(collectionName)
        
        //Obtención de los registros existentes en la colección indicada
        collection.getDocuments() { (snap, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            
            else {
                //Para cada documento (registro), se recogen los datos de cada estudiante
                for document in snap!.documents {
                    let data = document.data()
                    let s = Student(name: data["name"] as! String, surname: data["surname"] as! String, houseName: data["houseName"] as! String)
                    
                    if collectionName == "NewStudents"{
                        s.imageName = "DefaultProfilePic.jpg"
                        s.newImage = UIImage(named: s.imageName)
                        
                        if let img = s.newImage{
                            let imageData :NSData = img.pngData()! as NSData
                            UserDefaults.standard.set(imageData, forKey: s.userName) //Para el chat: el alumno tiene guardada su imagen por defecto, en lugar de nada
                        }
                    }
                    
                    //Para cada estudiante leído, se añade a su casa
                    switch s.houseName{
                        case "Gryffindor": self.gryffindorStudents.append(s)
                        case "Hufflepuff": self.hufflepuffStudents.append(s)
                        case "Ravenclaw": self.ravenclawStudents.append(s)
                        case "Slytherin": self.slytherinStudents.append(s)
                        default: break
                    }
                }
                
                //Una vez finalizada la lectura, se comunica a la vista máster quede actualizar los registros de la tabla, mediante notificación
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UpdateTable"), object: nil)
            }
        }
    }
    
    
    /** Los estudiantes se escriben en el vector initialStudents **/
    func readInitialStudentsFromFirebaseCollectionToVector(){
        let db = Firestore.firestore()
        let collection = db.collection("InitialStudents")
        
        collection.getDocuments() { (snap, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            
            else {
                for document in snap!.documents {
                    let data = document.data()
                    let s = Student(name: data["name"] as! String, surname: data["surname"] as! String, houseName: data["houseName"] as! String)
                    
                    self.initialStudents.append(s)
                }
            }
        }
    }
    
    
    /** Escritura de estudiantes en la base de datos de Firebase **/
    func addStudentToFirebase(collectionName: String, name: String, surname :String, houseName :String){
        let db = Firestore.firestore()
        let collection = db.collection(collectionName)
        
        collection.addDocument(data: ["name": name, "surname": surname, "houseName": houseName]){ (err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
    
    /** Borrado de estudiantes en Firebase **/
    func removeStudentFromFirebase(collectionName :String, name :String, surname :String){
        let db = Firestore.firestore()
        let collection = db.collection(collectionName)
        
        collection.getDocuments() { (snap, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            }
            
            else {
                for document in snap!.documents {
                    let data = document.data()
                    let student = Student(name: data["name"] as! String, surname: data["surname"] as! String, houseName: data["houseName"] as! String)
                    
                    if student.name == name && student.surname == surname{
                        collection.document(document.documentID).delete()
                        return
                    }
                }
            }
        }
    }
}
