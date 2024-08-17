//
//  PokemonDetailView.swift
//  PokemonApp
//
//  Created by Marco Sauter on 17.08.24.
//

import Foundation
import SwiftUI
import Charts

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
