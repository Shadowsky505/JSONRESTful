//
//  ViewControllerAgregar.swift
//  JSONRESTful
//
//  Created by Ayrtoon Tintaya on 12/06/24.
//

import UIKit

class ViewControllerAgregar: UIViewController {

    
    @IBOutlet weak var txtNombre: UITextField!
    @IBOutlet weak var txtGenero: UITextField!
    @IBOutlet weak var txtDuracion: UITextField!
    
    @IBOutlet weak var botonGuardar: UIButton!
    @IBOutlet weak var botonActualizar: UIButton!
    
    
    var pelicula:Peliculas?
    
    @IBAction func btnActualizar(_ sender: Any) {
        let nombre = txtNombre.text!
        let genero = txtGenero.text!
        let duracion = txtDuracion.text!
        let datos = ["usuarioId":2, "nombre": "\(nombre)", "genero": "\(genero)", "duracion": "\(duracion)"] as Dictionary<String, Any>
        let ruta  = "http://localhost:3000/peliculas/\(pelicula!.id)"
        metodoPUT(ruta: ruta, datos: datos)
        navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func btnGuardar(_ sender: Any) {
        let nombre = txtNombre.text!
        let genero = txtGenero.text!
        let duracion = txtDuracion.text!
        let datos = ["usuarioId":2, "nombre": "\(nombre)", "genero": "\(genero)", "duracion": "\(duracion)"] as Dictionary<String, Any>
        let ruta  = "http://localhost:3000/peliculas"
        metodoPOST(ruta: ruta, datos: datos)
        navigationController?.popViewController(animated: true)
        
    }
    
    func metodoPOST(ruta:String,datos:[String:Any]){
        let url : URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "POST"
        
        let params = datos
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("FALLO EN AGREGAR")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request) { data, response, error in
            if (data != nil){
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print("DICCIONARIO AGREGADOR: \(dict)")
                } catch {
                    print("ERROR AL GENERAR DICCIONARIO: \(error)")
                }
            }
        }
        task.resume()
        
    }
    
    func metodoPUT(ruta:String, datos: [String:Any]) {
        let url : URL = URL(string: ruta)!
        var request = URLRequest(url: url)
        let session = URLSession.shared
        request.httpMethod = "PUT"
        
        let params = datos
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: JSONSerialization.WritingOptions.prettyPrinted)
        } catch {
            print("FALLO EN AGREGAR")
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request) { data, response, error in
            if (data != nil){
                do {
                    let dict = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableLeaves)
                    print("DICCIONARIO AGREGADOR: \(dict) ERROR: \(error)")
                } catch {
                    print("ERROR AL GENERAR DICCIONARIO: \(error)")
                }
            }
        }
        task.resume()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if pelicula == nil {
            botonGuardar.isEnabled = true
            botonActualizar.isEnabled = false
        } else {
            botonGuardar.isEnabled = false
            botonActualizar.isEnabled = true
            txtNombre.text = pelicula!.nombre
            txtGenero.text = pelicula!.genero
            txtDuracion.text = pelicula!.duracion
        }
    }
    


}
