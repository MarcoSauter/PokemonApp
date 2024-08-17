//
//  Pokemon.swift
//  PokemonList
//
//  Created by Marco Sauter on 16.08.24.
//

import Foundation

public struct PokemonInfo: Hashable, Codable {
    var id: Int
    var name: String
}

public struct Pokemon: Hashable, Codable {
    var pokemonInfo: PokemonInfo
    var img: String
}

struct FoundPokemon: Hashable, Codable {
    var name: String
    var url: URL
}

struct FoundPokemonList: Codable {
    var results: [FoundPokemon]
}
