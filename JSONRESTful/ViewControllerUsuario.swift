import UIKit

class ViewControllerUsuario: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    @IBOutlet weak var txtContrasena: UITextField!
    
    var nombreUsuario2: String?
    var usuario: Users? // Variable para almacenar los datos del usuario

    override func viewDidLoad() {
        super.viewDidLoad()
        if let nombre = nombreUsuario2 {
            print("USUARIO EN USUARIO:  \(nombre)")
            fetchUserData(for: nombre)
        }
    }
    
    @IBAction func btnActualizarDatos(_ sender: Any) {
        guard let usuario = usuario else {
            print("No se ha obtenido información del usuario")
            return
        }
        
        let nuevaContraseña = txtContrasena.text ?? ""
        
        // Actualizar los datos del usuario
        let nuevosDatos: [String: Any] = ["id": usuario.id,
                                          "nombre": usuario.nombre,
                                          "clave": nuevaContraseña,
                                          "email": usuario.email]
        
        metodoPUT(ruta: "http://localhost:3000/usuarios/\(usuario.id)", datos: nuevosDatos)
    }
    
    // Función para realizar la solicitud a la API y obtener los datos del usuario
    func fetchUserData(for nombre: String) {
        let urlString = "http://localhost:3000/usuarios?nombre=\(nombre)" // URL de tu API con el nombre como parámetro de consulta
        guard let url = URL(string: urlString) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                print("Error fetching data: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                // Parsear el JSON
                let users = try JSONDecoder().decode([Users].self, from: data)
                if let user = users.first(where: { $0.nombre == nombre }) {
                    self.usuario = user // Guardar los datos del usuario
                    DispatchQueue.main.async {
                        self.updateUI(with: user)
                    }
                } else {
                    print("User not found")
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
    
    // Función para actualizar la interfaz de usuario con los datos recibidos
    func updateUI(with user: Users) {
        txtUsuario.text = user.nombre
        txtEmail.text = user.email
        txtContrasena.text = user.clave
    }
    
    // Función para realizar una solicitud PUT al servidor
    func metodoPUT(ruta: String, datos: [String:Any]) {
        let url : URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        
        let params = datos
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("Error al serializar datos: \(error)")
        }
        
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: request) { data, response, error in
            if let data = data {
                do {
                    let dict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    print("Respuesta del servidor: \(dict ?? [:])")
                } catch {
                    print("Error al parsear respuesta del servidor: \(error)")
                }
            } else if let error = error {
                print("Error de red: \(error)")
            }
        }
        task.resume()
    }
}
