//
//  ViewControllerUsuario.swift
//  JSONRESTful
//
//  Created by Ayrtoon Tintaya on 12/06/24.
//

import UIKit

class ViewControllerUsuario: UIViewController {

    @IBOutlet weak var txtUsuario: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    
    var usuario: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let usuario = usuario {
            txtUsuario.text = usuario.nombre
            txtEmail.text = usuario.email
        }
    }
    
    @IBAction func guardarCambios(_ sender: Any) {
        guard let user = usuario else { return }
        user.nombre = txtUsuario.text ?? ""
        user.email = txtEmail.text ?? ""
        
        let url = URL(string: "http://localhost:3000/usuarios/\(user.id)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["nombre": user.nombre, "email": user.email]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Error en la actualización: \(error)")
                return
            }
            DispatchQueue.main.async {
                self.navigationController?.popViewController(animated: true)
            }
        }.resume()
    }
}
