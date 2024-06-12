//
//  Peliculas.swift
//  JSONRESTful
//
//  Created by Ayrtoon Tintaya on 12/06/24.
//

import Foundation

struct Peliculas:Decodable{
    let usuarioId:Int
    let id:Int
    let nombre:String
    let genero:String
    let duracion:String
}
