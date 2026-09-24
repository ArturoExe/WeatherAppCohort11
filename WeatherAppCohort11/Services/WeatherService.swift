//
//  WeatherService.swift
//  WeatherAppCohort11
//
//  Created by Arturo Martinez on 9/23/26.
//

import Foundation

class WeatherService{
    
    // STEP 1.- THE USER SENDS THE NAME OF THE PLACE
    // SETP 2.- WE SEND THE PLACE TO API WE GET BACK  COORDENATES
    // STEP 3.- WE SEND THOSE COORDENATES TO API, WE GET THE WEATHER BACK
    
    //MARK: ERROR MENU ADD MORE IF YOU CAN THINK OF OTHER THINGS THAT CAN BREAK THE APP :C
    enum NetworkError:Error{
        case badStatusCode(Int)
        case invalidResponse
        case invalidURL
        case noResults
    }
    
    
    //MARK: HELPER FUNCTION
    private func performGetRequest(url:URL) async throws -> Data {
        
        // STEP 1: Create a URLSession (the tool that makes network requests)
        let session:URLSession = URLSession.shared
        
        // STEP 2: Send a GET request to the URL and wait for the server to respond
        // - "try" because networking can fail
        // - "await" because it takes time

        let result: (Data,URLResponse) = try await session.data(from: url)
        
        // STEP 3: Split the result into:
        // - data: the actual content (usually JSON)
        // - response: information about the request (status code, headers, etc.)
        let data:Data = result.0
        let response:URLResponse = result.1
        
        // STEP 4: We want an HTTP response so we can read the status code (200, 404, 500...)
        // If this is not an HTTP response, something is wrong.
        
        if let httpResponse = response as? HTTPURLResponse {
                
            let statusCode:Int = httpResponse.statusCode
            
            // Forgot to remove the "=" remember that we only want codes from 200 and 299 if we add "=" that means that it also includes the "ENDS" of the range
            
            // if oout code is 199 and under and 300 above throw and error
            // if it is 200-299 continue
            
        
            if statusCode < 200 || statusCode > 299{
                
                throw NetworkError.badStatusCode(statusCode)
            }
            
            return data
        }
        
        throw NetworkError.invalidResponse
        
    }
    
    private func fetchCoordinates(forCity city:String) async throws -> GeocodingPlace{
        
        var urlComponents: URLComponents? = URLComponents(string: "https://geocoding-api.open-meteo.com/v1/search")

        // Invalid URL IS NIL
        if urlComponents == nil {
            throw NetworkError.invalidURL
        }

        // ADDING PARAMETERS TO OUR URL
        urlComponents?.queryItems = [
            URLQueryItem(name: "name", value: city),
            URLQueryItem(name: "count", value: "1"),
            URLQueryItem(name: "language", value: "en"),
            URLQueryItem(name: "format", value: "json")
        ]

        // Our Actual URL with the PARAMETERS
        let url: URL? = urlComponents?.url

        
        if url == nil {
            throw NetworkError.invalidURL
        }
        
        // Fetch Information based on the prev URL
        let data: Data = try await performGetRequest(url: url!)

        let decoder: JSONDecoder = JSONDecoder()
        let response: GeocodingResponse = try decoder.decode(GeocodingResponse.self, from: data)

        if let results: [GeocodingPlace] = response.results {
            if let firstResult: GeocodingPlace = results.first {
                return firstResult
            }
        }

        throw NetworkError.noResults
        
    }
    
    
   private func fetchWeather(latitude:Double,longitude:Double) async throws -> CurrentWeather{
        
        var urlComponents: URLComponents? = URLComponents(string: "https://api.open-meteo.com/v1/forecast")

        if urlComponents == nil{ throw NetworkError.invalidURL}
        
        // latitude,longitude,current_weather=true, timezone="auto"
        urlComponents?.queryItems = [
            URLQueryItem(name: "latitude", value: String(latitude)),
            URLQueryItem(name: "longitude", value: String(longitude)),
            URLQueryItem(name: "current_weather", value: "true"),
            URLQueryItem(name: "timezone", value: "auto")
        ]

        // NOW my url contains all the parameters
        let url:URL? = urlComponents?.url
    
        if url ==  nil { throw NetworkError.invalidURL}
    
        let data = try await performGetRequest(url: url!)
    
        let decoder:JSONDecoder = JSONDecoder()
        
        let response:ForecastReponse = try decoder.decode(ForecastReponse.self, from: data)
        
        return response.current_weather
        
    }
    
    
    func fetchAPI(forCity city:String) async throws -> (cityName:String,weather:CurrentWeather) {
        
        let geoCoord:GeocodingPlace = try await fetchCoordinates(forCity: city)
        let geoWeather:CurrentWeather = try await fetchWeather(latitude: geoCoord.latitude, longitude: geoCoord.longitude)
        
        return (geoCoord.name,geoWeather)
    }
    
    
    
    
    
}
