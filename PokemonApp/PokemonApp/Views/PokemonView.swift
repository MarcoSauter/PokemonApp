//
//  ContentView.swift
//  PokemonList
//
//  Created by Marco Sauter on 16.08.24.
//
import SwiftUI

struct PokemonView: View {
    @State private var pokemonList: [Pokemon] = []
    @State private var selectedPokemon: Pokemon? = nil // State for the selected Pokémon
    @State private var searchTerm = ""
    @State private var searchResults: [Pokemon] = []
    
    var listPokemon: [Pokemon] {
        if searchTerm.isEmpty {
            return pokemonList
        }
        else {
            return searchResults
        }
    }
    let pokemonService = PokemonService()
    
    // Define a grid layout with two columns
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) { // Create a grid with 2 columns
                    ForEach((listPokemon), id: \.self) { pokemon in
                        
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
                            .frame(width: 100, height: 100)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(pokemonService.convertTypeToColor(type: pokemon.pokemonInfo.types[0].type.name))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .onTapGesture {
                            selectedPokemon = pokemon
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Pokémon List")
            .animation(.default, value: searchTerm)
            .task {
                if let fetchedPokemon = await pokemonService.fetchPokemonData(limit: 50) {
                    self.pokemonList = fetchedPokemon
                }
            }
            .sheet(item: $selectedPokemon) { pokemon in
                PokemonDetailView(pokemon: pokemon, color: pokemonService.convertTypeToColor(type: pokemon.pokemonInfo.types[0].type.name))
            }
        }
        .searchable(text: $searchTerm, placement: .navigationBarDrawer(displayMode: .always))
        .onChange(of: searchTerm) {
            searchResults = pokemonList.filter({ pokemon in
                pokemon.pokemonInfo.name.lowercased().contains(searchTerm.lowercased()) || pokemon.pokemonInfo.types[0].type.name.lowercased().contains(searchTerm.lowercased())
            })
        }
    }
}

#Preview {
    PokemonView()
}
