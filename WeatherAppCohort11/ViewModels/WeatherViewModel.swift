//
//  WeatherViewModel.swift
//  WeatherAppCohort11
//
//  Created by Arturo Martinez on 9/23/26.
//

import Foundation
import Combine

@MainActor
class WeatherViewModel:ObservableObject{

    @Published var searchText:String = ""
    @Published var cityName:String = ""
    @Published var tempText:String = ""
    @Published var windText:String = ""
    @Published var timeText:String = ""
    
    
    @Published var isLoading:Bool = false
    @Published var errorMessage:String = ""
    
    
    private let API:WeatherService = WeatherService()
        
    func searchWeather() async {
        
        self.isLoading = true
        self.errorMessage = ""
        
        let trimmedText = self.searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            self.errorMessage = "Please type a city name"
            self.isLoading = false
            return
        }
        
        do{
            let result = try await API.fetchAPI(forCity: trimmedText)
            
            self.cityName = result.cityName
            self.tempText = "Temp: \(result.weather.temperature)"
            self.isLoading = false
            
            
        }catch{
            self.errorMessage = "Something went wrong..."
            self.isLoading = false
        }

        
    }
    
    
}
