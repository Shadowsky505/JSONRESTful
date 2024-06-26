import UIKit

class ViewControllerBuscar: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peliculas.count
    }
    
    var nombreUsuario:String?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "\(peliculas[indexPath.row].nombre)"
        cell.detailTextLabel?.text = "Genero:\(peliculas[indexPath.row].genero)Duracion:\(peliculas[indexPath.row].duracion)"
        return cell
    }
    
    @IBAction func btnUsuario(_ sender: Any) {
        performSegue(withIdentifier: "segueUsuario", sender: self)
    }
    
    
    
    var peliculas = [Peliculas]()

    @IBOutlet weak var tablaPeliculas: UITableView!
    @IBOutlet weak var txtBuscar: UITextField!
    var usuario: Users?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tablaPeliculas.delegate = self
        tablaPeliculas.dataSource = self
        
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tablaPeliculas.reloadData()
        }
        
        print("LLEG ESTO SIIIIII: \(nombreUsuario!)")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func btnBuscar(_ sender: Any) {
        let ruta = "http://localhost:3000/peliculas?"
        let nombre = txtBuscar.text!
        let url = ruta + "nombre_like=\(nombre)"
        let crearURL = url.replacingOccurrences(of: " ", with: "%20")
        
        if nombre.isEmpty{
            let ruta = "http://localhost:3000/peliculas/"
            self.cargarPeliculas(ruta: ruta) {
                self.tablaPeliculas.reloadData()
            }
            }else{
                cargarPeliculas(ruta: crearURL) {
                    if self.peliculas.count <= 0{
                        self.mostrarAlerta(titulo: "Error", mensaje: "No se encontraron coincidencias para: \(nombre)", accion: "cancel")
                    }else{
                        self.tablaPeliculas.reloadData()
                    }
                }
            }
    }
    
    func cargarPeliculas(ruta:String, completed: @escaping () -> ()){
        let url = URL(string: ruta)
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            if error == nil{
                do{
                    self.peliculas = try JSONDecoder().decode([Peliculas].self, from: data!)
                    DispatchQueue.main.async {
                        completed()
                    }
                }catch{
                    print("Error en JSON")
                }
            }
        }.resume()
    }
    
    func mostrarAlerta(titulo: String, mensaje: String, accion: String) {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        let btnOK = UIAlertAction(title: accion, style: .default, handler: nil)
        alerta.addAction(btnOK)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func btnSalir(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        let ruta = "http://localhost:3000/peliculas/"
        cargarPeliculas(ruta: ruta) {
            self.tablaPeliculas.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pelicula = peliculas[indexPath.row]
        performSegue(withIdentifier: "segueEditar", sender: pelicula)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let textoID = nombreUsuario!
        if segue.identifier == "segueEditar"{
            let siguienteVC = segue.destination as! ViewControllerAgregar
            siguienteVC.pelicula = sender as? Peliculas
        } else if segue.identifier == "segueUsuario" {
            let usuarioVC = segue.destination as! ViewControllerUsuario
            usuarioVC.nombreUsuario2 = textoID
        }
    }
    
    func metodoDELETE(ruta: String, completed: @escaping () -> ()) {
        let url = URL(string: ruta)!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if error == nil {
                DispatchQueue.main.async {
                    completed()
                }
            } else {
                print("Error en DELETE")
            }
        }
        task.resume()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let pelicula = peliculas[indexPath.row]
            let alerta = UIAlertController(title: "Confirmar eliminación", message: "¿Deseas eliminar la película \(pelicula.nombre)?", preferredStyle: .alert)
            
            let btnSi = UIAlertAction(title: "SI", style: .destructive) { action in
                let ruta = "http://localhost:3000/peliculas/\(pelicula.id)"
                self.metodoDELETE(ruta: ruta) {
                    self.peliculas.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
            let btnNo = UIAlertAction(title: "NO", style: .cancel, handler: nil)
            
            alerta.addAction(btnSi)
            alerta.addAction(btnNo)
            
            present(alerta, animated: true, completion: nil)
        }
    }

}
