//
//  DumbleChatView.swift
//  DumbleBook
//
//  Created by Alejandro Mateos on 27/12/2019.
//  Copyright © 2019 Alejandro Mateos. All rights reserved.
//

import SwiftUI
import Firebase
import Combine

class DumbleChat: UIHostingController<DumbleChatView> {

    required init?(coder: NSCoder) {
        super.init(coder: coder, rootView: DumbleChatView());
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = .black
    }
}


//MARK: - Creación del chat mediante SwiftUI
struct DumbleChatView: View {
    
    @State var name = ""
    @State var password = ""
    var house = House.sharedInstance
    
    var body: some View {
        NavigationView{
            
            //Capa vertical. Superposición de un color de fondo y una pila vertical
            ZStack{
                
                Color.init(.sRGB, red: 0.3569, green: 0.0902, blue: 0.0902, opacity: 1.0)
                
                //Pila vertical. Imagen de título + sección de login
                VStack{
                    Image("DumbleChatGold").resizable().scaledToFit().frame(width: 250.0, height: 50.0, alignment: .top)
                
                    //Pila vertical. Sección de login
                    VStack{
                        
                        //Imagen de usuario
                        self.getImage(userName: name).resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .padding(.top, 12)
                            .animation(.none)
                        
                        //Pila vertical. Fields para el usuario y contraseña
                        VStack{
                            TextField("Username", text: $name).textFieldStyle(RoundedBorderTextFieldStyle())
                            SecureField("Password", text: $password).textFieldStyle(RoundedBorderTextFieldStyle())
                        }.padding()
                            
                            
                        if self.name != "" && self.password != ""{
                            
                            //Usuario correcto
                            if checkLogin(username: self.name, password: self.password){
                                
                                //Enlace mediante botón a la pantalla de chat (definida en MsgPage)
                                NavigationLink(destination: MsgPage(name: self.name)){
                                    HStack{
                                        Text("Join")
                                        Image(systemName: "arrow.right.circle.fill").resizable().frame(width: 20, height: 20)
                                    }
                                }.frame(width: 100, height: 54)
                                    .background(Color.init(.sRGB, red: 0.8314, green: 0.6863, blue: 0.2157, opacity: 1.0))
                                    .foregroundColor(Color.white)
                                    .cornerRadius(27)
                                    .padding(.bottom, 15)
                            }
                            
                            //El usuario no existe
                            else{
                                Text("User does not exist or password is incorrect.")
                                    .foregroundColor(Color.red)
                                    .font(.system(size: 12))
                                    .padding()
                            }
                        }
                            
                    }.background(Color.white).cornerRadius(20).padding()
                }
            }.edgesIgnoringSafeArea(.all)
        }.animation(.default)
    }
    
    
    /** Método de obtención de la imagen de usuario **/
    func getImage(userName: String) -> Image{
        let house = House.sharedInstance
        var studentFound = false
        
        if let _ = UserDefaults.standard.object(forKey: userName){
            let data = UserDefaults.standard.object(forKey: userName) as! NSData
            return Image(uiImage: UIImage(data: data as Data)!)
        }
        
        else{
            if(userName == "AlbusDumbledore"){
                return Image("AlbusDumbledore")
            }
            
            for s in house.gryffindorStudents{
                if s.userName == userName{
                    studentFound = true
                    break
                }
            }
            
            for s in house.hufflepuffStudents{
                if s.userName == userName{
                    studentFound = true
                    break
                }
            }
            
            for s in house.ravenclawStudents{
                if s.userName == userName{
                    studentFound = true
                    break
                }
            }
            
            for s in house.slytherinStudents{
                if s.userName == userName{
                    studentFound = true
                    break
                }
            }
            
            if studentFound{
                return Image(self.name)
            }
            
            else{
                return Image("DefaultProfilePic")
            }
        }
    }
    
    
    /** Comprobación de usuarios **/
    func checkLogin (username: String, password: String) -> Bool{
        
        if self.name == "AlbusDumbledore" && self.password == "HogwartsDumbledore"{
            return true
        }
        
        for s in house.gryffindorStudents{
            
            if s.userName == self.name && s.passWord == self.password{
                return true
            }
        }
        
        for s in house.hufflepuffStudents{
            if s.userName == self.name && s.passWord == self.password{
                return true
            }
        }
        
        for s in house.ravenclawStudents{
            if s.userName == self.name && s.passWord == self.password{
                return true
            }
        }
        
        for s in house.slytherinStudents{
            if s.userName == self.name && s.passWord == self.password{
                return true
            }
        }
        
        return false
    }
}


struct DumbleChatView_Previews: PreviewProvider {
    static var previews: some View {
        DumbleChatView()
    }
}


//MARK: - Ventana de mensajes
struct MsgPage : View{
    var name = ""
    @ObservedObject var msg = observer()
    @State var typedMsg = ""
    
    var body : some View{
        
        ZStack{
            
            Color.init(.sRGB, red: 0.8314, green: 0.6863, blue: 0.2157, opacity: 1.0)
            
            //Pila vertical. Lista de mensajes y recuadro de escritura de nuevo mensaje
            VStack{
                    //Lista de mensajes
                    List(msg.messages){ i in
                        
                        if i.name == self.name{
                            MsgRow(msg: i.msg, myMsg: true, user: i.name)
                        }
                        else{
                            MsgRow(msg: i.msg, myMsg: false, user: i.name)
                        }
                        
                    }.navigationBarTitle("DumbleChat", displayMode: .inline)
                
                
                    //Cuadro de escritura de mensajes
                    HStack{
                        TextField("Message", text: $typedMsg).textFieldStyle(RoundedBorderTextFieldStyle())
                        
                        Button(action:{
                            self.msg.addMessage(msg: self.typedMsg, user: self.name)
                            self.typedMsg = ""
                        }) {
                            Text("Send").foregroundColor(Color.white)
                                        .padding(8)
                                        .background(Color.init(.sRGB, red: 0.8078, green: 0.2078, blue: 0.2078, opacity: 1.0))
                                        .cornerRadius(6)
                        }
                    }.padding()
            }
        }
    }
}


//MARK: - Clase observadora para la gestión de mensajes en tiempo real
class observer :ObservableObject{
    @Published var messages = [datatype]()
    
    //Obtención de los mensajes almacenados en cloud
    init(){
        let db = Firestore.firestore()
        db.collection("messages").addSnapshotListener{ (snap, err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            
            for i in snap!.documentChanges{
                if i.type == .added{
                    let name = i.document.get("name") as! String
                    let msg = i.document.get("msg") as! String
                    let id = i.document.documentID
                    
                    //Variable de tipo mensaje a la que se añade cada mensaje leido
                    self.messages.append(datatype(id: id, name: name, msg: msg))
                }
            }
        }
    }
    
    
    //Adición de mensajes a la colección
    func addMessage(msg :String, user: String){
        let db = Firestore.firestore()
        db.collection("messages").addDocument(data: ["msg": msg, "name": user]){ (err) in
            
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
        }
    }
}
  

//MARK: - Estrcutura que define los parámetros de un mensaje
struct datatype : Identifiable{
    var id :String
    var name :String
    var msg :String
}


//MARK: - Estructura que define los parámetros de cada cuadro de un mensaje enviado
struct MsgRow : View{
    
    var msg = ""
    var myMsg = false
    var user = ""
    
    var body : some View{
        
        HStack{
            //El mensaje lo he escrito yo...
            if myMsg{
                Spacer() //Para que mis mensajes salgan a la derecha
                Text(msg).padding(8).background(Color.init(.sRGB, red: 0.8078, green: 0.2078, blue: 0.2078, opacity: 1.0))
                        .cornerRadius(6)
                        .foregroundColor(Color.white)
            }
                
            //El mensaje no es mío...
            else{
                HStack{
                    //Se obtiene la imgen del usuario emisor
                    self.getImage(userName: user).resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                    .padding(.top)
                    
                    //Se crea un recuadro con el nombre de usuario y el mensaje posteado
                    VStack(alignment: .leading){
                        Text(user).font(.system(size: 10))
                        Text(msg)
                    }.padding(8).background(Color.gray).cornerRadius(6).foregroundColor(Color.white)
                    
                    Spacer() //Para que el mensaje aparezca al lado izquierdo
                }
            }
        }
    }
    
    
    /** Método de obtención de las imágenes de usuarios **/
    func getImage(userName: String) -> Image{
        if let _ = UserDefaults.standard.object(forKey: userName){
            let data = UserDefaults.standard.object(forKey: userName) as! NSData
            return Image(uiImage: UIImage(data: data as Data)!)
        }
        
        else{
            return Image(self.user)
        }
    }
}
