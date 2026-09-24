//
//  WeatherView.swift
//  WeatherAppCohort11
//
//  Created by Arturo Martinez on 9/23/26.
//

import SwiftUI
import Combine

struct WeatherView:View {
    
   @StateObject var viewModel:WeatherViewModel = WeatherViewModel()
    
    
    var body: some View {
        NavigationStack{
            VStack{
                TextField("Enter a city ", text: $viewModel.searchText)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.words)
                
                
                Button("Get Weather") {
                    Task{
                        
                        await viewModel.searchWeather()
                        
                    }
                }
                .buttonStyle(.borderedProminent)
                
                if viewModel.isLoading {
                    ProgressView("Loading…")
                }
                
                if !viewModel.errorMessage.isEmpty {
                    Text(viewModel.errorMessage)
                        .foregroundStyle(.red)
                }
                if !viewModel.cityName.isEmpty {
                    VStack(alignment: .leading, spacing: 8) {
                        Text(viewModel.cityName)
                            .font(.title2)
                            .bold()
                        
                        Text(viewModel.tempText)
                   
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding()
                    .background(.thinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
            }
        }
       
        
    }
}

#Preview{
    WeatherView()
}
