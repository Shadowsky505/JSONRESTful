import UIKit

class ViewController: UIViewController {
    //MARK: OUTLETS
    
    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtContasena: UITextField!
    
    var users = [Users]()
    
    
    
    @IBAction func logear(_ sender: Any) {
        let ruta = "http://localhost:3000/usuarios?"
        let usuario = txtUsuario.text!
        let contrasena = txtContasena.text!
        let url = ruta + "nombre=\(usuario)&clave=\(contrasena)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        print("URL DEL SERVIDOR: \(crearURL)")
        validarUsuario(ruta: crearURL) {
            if self.users.count <= 0 {
                print("Nombre de Usuario o Contraseña Incorrecto")
            } else {
                print("logeo Existoso")
                
                self.performSegue(withIdentifier: "segueLogeo", sender: self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func validarUsuario(ruta:String, completed: @escaping ()->()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil {
                do {
                    self.users = try JSONDecoder().decode([Users].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                } catch {
                    print("ERROR EN EL JSON: \(error)")
                }
            }
        }.resume()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let usuarioTexto = txtUsuario.text!
        print("GAA:: \(usuarioTexto)")
        
            if let destinoVC = segue.destination as? ByPassController{
                print("GAAA2222: \(usuarioTexto)")
                destinoVC.nombreUsuario = usuarioTexto
            
        }
    }
}
