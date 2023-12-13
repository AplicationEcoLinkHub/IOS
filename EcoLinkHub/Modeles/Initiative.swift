//
//  Initiative.swift
//  EcoLinkHub
//
//  Created by Zeynab Mounkaila on 29/11/2023.
//

import Foundation

struct Initiative: Codable {
    var id: Int?  
    var titre: String
    var description: String
    var numero: Int
    var heure: String
    var image: String
    var localisation: String
}

