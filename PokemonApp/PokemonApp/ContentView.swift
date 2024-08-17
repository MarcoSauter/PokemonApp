//
//  ContentView.swift
//  PokemonList
//
//  Created by Marco Sauter on 16.08.24.
//
import SwiftUI

struct ContentView: View {
    @State private var pokemonList: [Pokemon] = []

    var body: some View {
        NavigationStack {
            List(pokemonList, id: \.self) { pokemon in
                VStack(alignment: .leading) {
                    Text(pokemon.pokemonInfo.name.capitalized)
                        .font(.headline)
                    Text("ID: \(pokemon.pokemonInfo.id)")
                        .font(.subheadline)
                    AsyncImage(url: URL(string: pokemon.img)) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 200, height: 200)
                }
            }
            .navigationTitle("Pokémon List")
            .task {
                let pokemonService = PokemonService()
                if let fetchedPokemon = await pokemonService.fetchPokemonData() {
                    self.pokemonList = fetchedPokemon
                }
            }
        }
    }
}


#Preview {
    ContentView()
}
