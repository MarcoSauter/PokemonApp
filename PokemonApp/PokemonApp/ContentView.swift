//
//  ContentView.swift
//  PokemonList
//
//  Created by Marco Sauter on 16.08.24.
//
import SwiftUI
import Charts

struct ContentView: View {
    @State private var pokemonList: [Pokemon] = []
    @State private var selectedPokemon: Pokemon? = nil // State for the selected Pokémon
    @State private var isShowingDetail = false // State to control sheet presentation
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
                    ForEach(pokemonList, id: \.self) { pokemon in
                        
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
                            isShowingDetail = true
                        }
                    }
                }
                .padding()
            }
            .navigationTitle("Pokémon List")
            .task {
                if let fetchedPokemon = await pokemonService.fetchPokemonData(limit: 30) {
                    self.pokemonList = fetchedPokemon
                }
            }
            .sheet(item: $selectedPokemon) { pokemon in
                PokemonDetailView(pokemon: pokemon, color: pokemonService.convertTypeToColor(type: pokemon.pokemonInfo.types[0].type.name))
            }
        }
    }
}

struct PokemonDetailView: View {
    let pokemon: Pokemon
    let color: Color

    var body: some View {
        VStack(spacing: 20) {
            Text(pokemon.pokemonInfo.name.capitalized)
                .font(.largeTitle)
                .padding()
            
            AsyncImage(url: URL(string: pokemon.img)) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .frame(width: 200, height: 200)
            
            Text("Height: \(pokemon.pokemonInfo.height/10, specifier: "%.2f") m")
                .font(.title2)
            Text("Weight: \(pokemon.pokemonInfo.weight/10, specifier: "%.2f") kg")
                .font(.title2)
            
            Chart {
                ForEach(pokemon.pokemonInfo.stats, id: \.self) { stat in
                    BarMark(
                        x: .value("Value", stat.base_stat),
                        y: .value("Stats", stat.stat.name)
                    )
                    .cornerRadius(5)
                    .foregroundStyle(color)
                }
                
            }
            .background(Color.white)
            .chartXAxis(.hidden)
            .cornerRadius(10)
            .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
            
            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(color)
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

#Preview {
    ContentView()
}
