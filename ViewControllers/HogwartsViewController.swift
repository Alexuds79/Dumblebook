//
//  MasterViewController.swift
//  DumbleBook
//
//  Created by Alejandro Mateos on 20/12/2019.
//  Copyright © 2019 Alejandro Mateos. All rights reserved.
//
//

import UIKit

//MARK: - Extendemos el tipo de dato UIImage para definir la propiedad squareImageMask, que nos ubica la imagen dentro de un cuadrado bien definido
extension UIImage {
    var squareImageMask: UIImage {
        //Se define un cuadrado que tendrá por tamaño de lado el valor de la menor dimensión (ancho o alto) de la imagen procesada
        let square = size.width < size.height ? CGSize(width: size.width, height: size.width) : CGSize(width: size.height, height: size.height)
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        
        //La imagen rellena el espacio sin deformarse (aspect fill)
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.image = self
        UIGraphicsBeginImageContext(imageView.bounds.size)
        
        //Comprobamos si existe contexto gráfico. En caso de error se asigna la imagen por defecto
        if let _ = UIGraphicsGetCurrentContext(), let _ = UIGraphicsGetImageFromCurrentImageContext(){
            imageView.layer.render(in: UIGraphicsGetCurrentContext()!)
            let result = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
            return result
        }
        else{
            return UIImage(named: "DefaultProfilePic.jpg")!.squareImageMask
        }
    }
}

class HogwartsViewController: UITableViewController {

    //MARK: - Declaración de los atributos de clase
    var detailViewController: DetailViewController? = nil
    var house = House.sharedInstance
    
    var houseName : String = ""
    var newImage : UIImage = UIImage()
    var imageEdited : Bool = false
    var newStudentFullName : String = ""
    
    var studentsReadFromFile = false

    
    
    //MARK: - Este código debe ejecutarse una vez que se ha producido la carga de la ventana
    /**Simplemente se registra un observador que recoge una notificación sobre si han llegado los datos del servidor para actualizar la tabla de alumnos, se recoge el nombre de la casa y se configuran las vistas**/
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(self.updateTable(aNotification:)),
        name: NSNotification.Name(rawValue: "UpdateTable"),
        object: nil)

        houseName = self.navigationItem.title!
        
        self.configureViews()
    }
    
    @objc private func updateTable(aNotification :NSNotification){
        self.tableView.reloadData()
    }
    
    
    func configureViews(){
        //Color de fondo
        self.view.backgroundColor = UIColor(red: 0.2863, green: 0, blue: 0, alpha: 1.0)
        
        //Tipo de la barra superior (la ponemos de tipo black para que los iconos de notificacion salgan blancos)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.tintColor = .white
        
        //Configuracion de la ventana de 'Más'
        tabBarController?.moreNavigationController.navigationBar.barStyle = .black
        tabBarController?.moreNavigationController.navigationBar.isTranslucent = false
        tabBarController?.moreNavigationController.topViewController?.view.backgroundColor = UIColor(red: 0.2863, green: 0, blue: 0, alpha: 1.0)
        tabBarController?.moreNavigationController.navigationBar.barTintColor = UIColor(red: 0.698, green: 0.1804, blue: 0.1804, alpha: 1.0)
        tabBarController?.moreNavigationController.navigationBar.tintColor = UIColor.white
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        tabBarController?.moreNavigationController.navigationBar.titleTextAttributes = textAttributes
        
        if let moreTableView = tabBarController?.moreNavigationController.topViewController?.view as? UITableView {
            moreTableView.tintColor = UIColor.black
        }
        
        //Botón para eliminar un estudiante
        navigationItem.leftBarButtonItem = editButtonItem
        editButtonItem.title = "Edit"
        editButtonItem.tintColor = UIColor.white
        
        //Split View Controller
        if let split = splitViewController {
            let controllers = split.viewControllers
            detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
    
    //MARK: - Limpiar el señalado del último elemento que se ha seleccionado cada vez que aparece la vista
    override func viewWillAppear(_ animated: Bool) {
        clearsSelectionOnViewWillAppear = splitViewController!.isCollapsed
        super.viewWillAppear(animated)
    }
    

    //MARK: - Método de inserción de nuevos objetos en la tabla de alumnos
    @objc func insertNewCell() {
        let indexPath = IndexPath(row: 0, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
    }
    

    // MARK: - Sobreescritura del segue a la vista de detalle
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
                
                //Recogemos el nombre y apellidos del alumno elegido
                var name : String = ""
                var surname : String = ""
                switch(houseName){
                    case "Gryffindor": name = house.gryffindorStudents[indexPath.row].name; surname = house.gryffindorStudents[indexPath.row].surname
                    case "Hufflepuff": name = house.hufflepuffStudents[indexPath.row].name; surname = house.hufflepuffStudents[indexPath.row].surname
                    case "Ravenclaw": name = house.ravenclawStudents[indexPath.row].name; surname = house.ravenclawStudents[indexPath.row].surname
                    case "Slytherin": name = house.slytherinStudents[indexPath.row].name; surname = house.slytherinStudents[indexPath.row].surname
                    default: return
                }
                
                //Creamos un nuevo controlador, le proporcionamos los datos y reasignamos el detailViewController
                let controller = (segue.destination as! UINavigationController).topViewController as! DetailViewController
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
                
                controller.name = name
                controller.surname = surname
                controller.row = indexPath.row
                controller.houseName = houseName
                
                detailViewController = controller
            }
        }
    }

    
    
    // MARK: - Conjunto de métodos que gestionan el visionado de la lista de alumnos en el menú Master
    
    /** Solo se considera una sección **/
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    /** Se devuelve el número de estuduantes de la casa para calcular el número de filas de la tabla **/
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return house.studentsCount(houseName: houseName)
    }
    
    /** Método de gestión del visionado de la tabla de alumnos **/
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Se obtiene la celda
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        //Se obtiene la información útil del alumno que ocupa la fila en cuestión
        var student : String = ""
        var imageName : String = ""
        var auxFullName : String = ""
        var name = ""
        var surname = ""
        
        switch(houseName){
            case "Gryffindor":
                student = house.gryffindorStudents[indexPath.row].shortName
                imageName = house.gryffindorStudents[indexPath.row].imageName
                
                name = house.gryffindorStudents[indexPath.row].name
                surname = house.gryffindorStudents[indexPath.row].surname
                auxFullName = name + " " + surname
            
            case "Hufflepuff":
                student = house.hufflepuffStudents[indexPath.row].shortName
                imageName = house.hufflepuffStudents[indexPath.row].imageName
                
                name = house.hufflepuffStudents[indexPath.row].name
                surname = house.hufflepuffStudents[indexPath.row].surname
                auxFullName = name + " " + surname
            
            case "Ravenclaw":
                student = house.ravenclawStudents[indexPath.row].shortName
                imageName = house.ravenclawStudents[indexPath.row].imageName
                
                name = house.ravenclawStudents[indexPath.row].name
                surname = house.ravenclawStudents[indexPath.row].surname
                auxFullName = name + " " + surname
            
            case "Slytherin":
                student = house.slytherinStudents[indexPath.row].shortName
                imageName = house.slytherinStudents[indexPath.row].imageName
                
                name = house.slytherinStudents[indexPath.row].name
                surname = house.slytherinStudents[indexPath.row].surname
                auxFullName = name + " " + surname
            
            default: break
        }
        
        //Configuración de la celda
        cell.textLabel!.text = student
        cell.detailTextLabel?.text = "Student"
        
        
        //Estableciendo la imagen en la celda
        var image = UIImage()
        
        //1. Si la imagen no ha sido editada, se mantiene la que el alumno tenga previamente registrada
        if imageEdited == false{
            if let img = UIImage(named: imageName){
                image = img
            }
        }
            
        //2. La imagen ha sido editada para el alumno que se debe procesar, luego se asigna la nueva
        else if newStudentFullName == auxFullName{
            switch(houseName){
                case "Gryffindor": house.gryffindorStudents[indexPath.row].newImage = newImage
                case "Hufflepuff": house.hufflepuffStudents[indexPath.row].newImage = newImage
                case "Ravenclaw": house.ravenclawStudents[indexPath.row].newImage = newImage
                case "Slytherin": house.slytherinStudents[indexPath.row].newImage = newImage
                default: break;
            }
            
            image = newImage
            
        }
            
        //3. La celda que se está consultando no corresponde al alumno que debemos procesar. Salimos
        else{
            return cell
        }
        
        //4. Uso de userDefaults para recoger la nueva imagen asociada a la clave del alumno (en caso de no haber sido modificada, no se hace nada)
        //Esto permite a la aplicación 'recordar' la última imagen activa entre sesiones
        if let _ = UserDefaults.standard.object(forKey: auxFullName){
            let data = UserDefaults.standard.object(forKey: auxFullName) as! NSData
            image = UIImage(data: data as Data)!
        }
        
        //5. Se asigna la imagen correspondiente
        cell.imageView?.image = image.squareImageMask
        
        return cell
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // MARK: - Funcionalidad para el borrado de usuarios (se eliminan tanto de la tabla máster como de la lógica de la aplicación)
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        var student = Student()
        
        if editingStyle == .delete {
            
            //Obtenemos el alumno a eliminar en una variable temporal y lo borramos de la base de datos
            switch(houseName){
                case "Gryffindor": student = house.gryffindorStudents[indexPath.row]; house.gryffindorStudents.remove(at: indexPath.row)
                case "Hufflepuff": student = house.hufflepuffStudents[indexPath.row]; house.hufflepuffStudents.remove(at: indexPath.row)
                case "Ravenclaw": student = house.ravenclawStudents[indexPath.row]; house.ravenclawStudents.remove(at: indexPath.row)
                case "Slytherin":  student = house.slytherinStudents[indexPath.row]; house.slytherinStudents.remove(at: indexPath.row)
                default: break
            }
            
            //Se borra la fila de la tabla
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            //Actualización del archivo Json de nuevos estudiantes, si se ha borrado uno nuevo
            if let index = house.allNewStudents.firstIndex(where: {$0.name == student.name && $0.surname == student.surname}){
                house.allNewStudents.remove(at: index)
                house.updateFileOfStudents(filename: "NewStudents.json", data: house.allNewStudents)
            }
            
            //El estudiante se borra también de la base de datos en cloud
            house.removeStudentFromFirebase(collectionName: "NewStudents", name: student.name, surname: student.surname)
            house.removeStudentFromFirebase(collectionName: "InitialStudents", name: student.name, surname: student.surname)
        }
    }
    
    
    //MARK: - Métodos de regreso a la vista máster
    
    /** Regreso desde la ventana de adición de estudiantes, guardando cambios **/
    @IBAction func unwindToHogwartsViewControllerSavingChanges (_ segue :UIStoryboardSegue){
        var studentName : String = ""
        var studentSurname : String = ""
        
        //Si los campos de dejan vacíos, se ponen valores por defecto
        if let sourceViewController = segue.source as? AddStudentViewController {
            studentName = sourceViewController.name ?? "noName"
            studentSurname = sourceViewController.surname ?? "noSurname"
        }
        
        let student = Student(name: studentName, surname: studentSurname, houseName: houseName)
        
        //Por defecto, se considera que para el nuevo estudiante añadido, se añade una imagen predefinida (se permitirá cambiarla en detalle)
        student.imageName = "DefaultProfilePic.jpg"
        newImage = UIImage(named: "DefaultProfilePic.jpg")!
        imageEdited = false
        
        //El estudiante se inscribe en la casa
        house.addStudent(student: student, houseName: houseName, index: 0)
        
        //Se le proporciona su imagen por defecto
        switch(houseName){
            case "Gryffindor": house.gryffindorStudents[0].newImage = UIImage(named: "DefaultProfilePic.jpg")
            case "Hufflepuff": house.hufflepuffStudents[0].newImage = UIImage(named: "DefaultProfilePic.jpg")
            case "Ravenclaw": house.ravenclawStudents[0].newImage = UIImage(named: "DefaultProfilePic.jpg")
            case "Slytherin": house.slytherinStudents[0].newImage = UIImage(named: "DefaultProfilePic.jpg")
            default: break
        }
        
        //Inserción de nueva celda para alojar el estudiante en la vista máster
        self.insertNewCell()
        
        //Se actualizan los registros en el fichero local y en cloud
        house.updateFileOfStudents(filename: "NewStudents.json", data: house.allNewStudents)
        house.addStudentToFirebase(collectionName: "NewStudents", name: studentName, surname: studentSurname, houseName: houseName)
    }
    
    
    /** Regreso desde la vista de adición de estudiantes, cancelando el guardado. Como es lógico, no se hace nada **/
    @IBAction func unwindToHogwartsViewControllerCancel (_ segue :UIStoryboardSegue){
        //nothing to do here...
    }
    
    /** Regreso desde la vista de detalle, con guardado de cambios **/
    @IBAction func unwindToHogwartsViewControllerFromEditing (_ segue :UIStoryboardSegue){
        var studentName : String = ""
        var studentSurname : String = ""
        var oldName : String = ""
        var oldSurname : String = ""
        var isInitialStudent = false
        
        //Obtenemos los nuevos valores asignados al estudiante
        if let sourceViewController = segue.source as? DetailViewController {
            studentName = sourceViewController.name
            studentSurname = sourceViewController.surname
            
            oldName = sourceViewController.oldName
            oldSurname = sourceViewController.oldSurname
            
            imageEdited = true
            
            if let _ = sourceViewController.StudentImage.image{
                newImage = sourceViewController.StudentImage.image!
            }
            else{
                newImage = UIImage(named: "DefaultProfilePic.jpg")!
            }
        }
        
        //El estudiante editado pertenece a la lista de estudiantes predefinidos...
        for s in house.initialStudents{
            
            if s.name == oldName && s.surname == oldSurname{
                house.initialStudents.removeAll(where: {$0.name == s.name && $0.surname == s.surname})
                house.initialStudents.append(Student(name: studentName, surname: studentSurname, houseName: houseName))
                
                isInitialStudent = true
                house.removeStudentFromFirebase(collectionName: "InitialStudents", name: oldName, surname: oldSurname)
                house.addStudentToFirebase(collectionName: "InitialStudents", name: studentName, surname: studentSurname, houseName: houseName)
                break
            }
        }
        
        //Recogemos el estudiante 'viejo' y cambiamos sus registros por los nuevos
        let oldStudent = Student(name: oldName, surname: oldSurname, houseName: houseName)
        newStudentFullName = house.editStudent(student: oldStudent, houseName: houseName, newName: studentName, newSurname: studentSurname)
        
        
        //El estudiante editado pertenece a la lista de estudiantes nuevos...
        if !isInitialStudent{
            house.removeStudentFromFirebase(collectionName: "NewStudents", name: oldName, surname: oldSurname)
            house.addStudentToFirebase(collectionName: "NewStudents", name: studentName, surname: studentSurname, houseName: houseName)
            house.updateFileOfStudents(filename: "NewStudents.json", data: house.allNewStudents)
        }
        
        //Uso de userDefaults para guardar la nueva imagen del estudiante en la 'memoria' de la aplicación
        let imageData :NSData = newImage.pngData()! as NSData
        UserDefaults.standard.set(imageData, forKey: newStudentFullName)
        UserDefaults.standard.set(imageData, forKey: newStudentFullName.replacingOccurrences(of: " ", with: "")) //for the chat login
        
        //Actualización de la tabla máster
        self.tableView.reloadData()
        
    }
    
    
}

