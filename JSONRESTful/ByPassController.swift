//
//  ByPassController.swift
//  JSONRESTful
//
//  Created by Ayrtoon Tintaya on 12/06/24.
//

import UIKit

class ByPassController: UINavigationController {

    var nombreUsuario: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSegue(withIdentifier: "segueBypass", sender: self)
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let usuarioTexto = nombreUsuario!
        print("GAA EN NAVIGATION:: \(usuarioTexto)")
        if segue.identifier == "segueBypass" {
            if let destinoVC = segue.destination as? ViewControllerBuscar{
                print("GAAA2222 en NAVIGATION: \(usuarioTexto)")
                destinoVC.nombreUsuario = usuarioTexto
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
