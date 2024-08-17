//
//  PokemonService.swift
//  PokemonList
//
//  Created by Marco Sauter on 16.08.24.
//

import Foundation
import SwiftUI

public class PokemonService {
    func fetchPokemonData(limit: Int = 10) async -> [Pokemon]? {
        guard let url = URL(string: "https://pokeapi.co/api/v2/pokemon/?limit=\(limit)/") else {
                print("This URL is not working!")
                return nil
        }
                
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            var pokemonList = [Pokemon]()
                    
            let decodedResponse = try JSONDecoder().decode(FoundPokemonList.self, from: data)
            for pokemon in decodedResponse.results {
                let (data, _) = try await URLSession.shared.data(from: pokemon.url)
                let pokemonInfo = try JSONDecoder().decode(PokemonInfo.self, from: data)
                let pokemon = Pokemon(pokemonInfo: pokemonInfo, img: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(pokemonInfo.id).png")
                pokemonList.append(pokemon)
            }
            return pokemonList
        } catch {
            print("caught: \(error)")
        }
        return nil
    }
    
    func convertTypeToColor(type: String) -> Color {
        switch type {
        case "normal":
            return Color.gray
        case "fire":
            return Color.red
        case "water":
            return Color.blue
        case "electric":
            return Color.yellow
        case "grass":
            return Color.green
        case "ice":
            return Color.cyan
        case "fighting":
            return Color.orange
        case "poison":
            return Color.purple
        case "ground":
            return Color.brown
        case "flying":
            return Color.indigo
        case "psychic":
            return Color.pink
        case "bug":
            return Color.init(red: 139/255, green: 191/255, blue: 63/255) // custom greenish color for bug
        case "rock":
            return Color.init(red: 184/255, green: 158/255, blue: 82/255) // brownish rock color
        case "ghost":
            return Color.init(red: 112/255, green: 88/255, blue: 152/255) // ghostly purple
        case "dragon":
            return Color.init(red: 112/255, green: 56/255, blue: 248/255) // strong purple for dragon
        case "dark":
            return Color.black
        case "steel":
            return Color.init(red: 183/255, green: 183/255, blue: 206/255) // steel gray
        case "fairy":
            return Color.init(red: 240/255, green: 182/255, blue: 188/255) // soft pink for fairy
        default:
            return Color.gray // Default color if type is unknown
        }
    }
}
