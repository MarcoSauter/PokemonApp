//
//  PokemonService.swift
//  PokemonList
//
//  Created by Marco Sauter on 16.08.24.
//

import Foundation

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
                let pokemon = Pokemon(pokemonInfo: pokemonInfo, img: "https://img.pokemondb.net/artwork/\(pokemonInfo.name).jpg")
                pokemonList.append(pokemon)
            }
            return pokemonList
        } catch {
            print("caught: \(error)")
        }
        return nil
    }
}
