

import UIKit

struct PhotosDS{
    
    //MARK: - Properties:
    private static let baseURL = "https://api.unsplash.com"
    private static let apiKey = "qBu91ChK-PQ0yxZDTI5dEt8q5vWV6pq_pjp3uyDn3Tw"
    
    enum EndPoint: String, CaseIterable{
        case list = "/photos"
        case search = "/search/photos"
        case random = "/photos/random"
    }
    
    //MARK: - Build Url Components:
    private func buildUrlComponents(from endpoint: EndPoint, with params: [String: Any]) -> URLComponents?{
        
        var urlComponents = URLComponents(string: PhotosDS.baseURL)
        urlComponents?.path = endpoint.rawValue
        
        var params = params
        params["client_id"] = PhotosDS.apiKey
        
        var queryItem:[URLQueryItem] = []
        for (key, value) in params{
            queryItem.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        urlComponents?.queryItems = queryItem
        
        return urlComponents
    }
    
    //MARK: - FetchPhotos:
    func fetchPhotos(from endpoint: EndPoint, with params: [String: Any], callback: @escaping PhotosDSDelegate){
        
        let urlComponents = buildUrlComponents(from: endpoint, with: params)
        print("*** The full URL:" ,urlComponents ?? "--- Error at the urlComponents")
        
        guard let url = urlComponents?.url else {
            callback(nil, .invalidUrl(url: urlComponents))
            print("--- Illegal URL!!! :(")
            return
        }
        
        //MARK: - Request:
        var request = URLRequest(url: url)
        request.addValue(PhotosDS.apiKey, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        //MARK: - URLSession:
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            //data:
            guard let data = data else {
                Q.ui.async {
                    callback(nil, .noData)
                }
                return
            }
            
            //response:
            if let response = response as? HTTPURLResponse{
                if !(200...299).contains(response.statusCode){
                    Q.ui.async {
                        callback(nil, .statusError(code: response.statusCode))
                    }
                }
            }
            
            //error:
            guard error == nil else {
                Q.ui.async {
                    callback(nil, .connectionFaild(error: error))
                }
                return
            }

            //MARK: - Decoder:
            let decoder = JSONDecoder()
            
            do{
                if endpoint.rawValue == EndPoint.list.rawValue || endpoint.rawValue == EndPoint.search.rawValue{
                    
                    let result = try decoder.decode(PhotosResponse.self, from: data)
                    
                    Q.ui.async {
                        callback(result.results, nil)
                    }
                    
                }else if endpoint.rawValue == EndPoint.random.rawValue{
                    
                    let result = try decoder.decode(ResultsResponse.self, from: data)
                    
                    Q.ui.async {
                        callback(result, nil)
                    }
                }
                
            }catch let decoderError{
                Q.ui.async {
                    callback(nil, .jsonDecodingFaild(cause: decoderError))
                }
            }
        }
        
        task.resume()
    }
}

typealias PhotosDSDelegate = (_ photos: [Results]?, _ error: PhotosDSError?) -> Void

enum PhotosDSError: Error{
    case invalidUrl(url: URLComponents?)
    case jsonDecodingFaild(cause: Error)
    case connectionFaild(error: Error?)
    case statusError(code: Int)
    case noData
}




