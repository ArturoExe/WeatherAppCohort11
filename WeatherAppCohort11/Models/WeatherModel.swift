//
//  WeatherModel.swift
//  WeatherAppCohort11
//
//  Created by Arturo Martinez on 9/23/26.
//

import Foundation

//How Many Models Do we need here?
 
// GOLDEN RULE FOR JSON MODELING
// Each OBJECT -> {} needs its MODEL -> class:Codable


// STEP #1 CITY TO COORDENATES
class GeocodingResponse:Codable{
    
    let results:[GeocodingPlace]?
  
}

class GeocodingPlace:Codable{
    
       let name: String
       let latitude, longitude: Double
    
}

// STEP 2 COORDENATE TO WEATHER

// TIME, TEMPERATURE,WEATHERCODE,WINDSPEED

class ForecastReponse:Codable{
    
    let current_weather:CurrentWeather
    
}


class CurrentWeather:Codable{
    
    let time:String
    let temperature:Double
    let weathercode:Int
    let windspeed:Double
}
