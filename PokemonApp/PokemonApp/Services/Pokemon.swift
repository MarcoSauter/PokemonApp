//
//  Pokemon.swift
//  PokemonList
//
//  Created by Marco Sauter on 16.08.24.
//

import Foundation

struct PokemonType: Hashable, Codable {
    var name: String
    var url: String
}

struct PokemonTypeEntry: Hashable, Codable {
    var type: PokemonType
}

struct PokemonStat: Hashable, Codable {
    var name: String
}

struct PokemonStatEntry: Hashable, Codable {
    var base_stat: Int
    var stat: PokemonStat
}

public struct PokemonInfo: Hashable, Codable {
    var id: Int
    var name: String
    var weight: Double
    var height: Double
    var types: [PokemonTypeEntry]
    var stats: [PokemonStatEntry]
}


public struct Pokemon: Hashable, Codable, Identifiable {
    public var id = UUID()
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
