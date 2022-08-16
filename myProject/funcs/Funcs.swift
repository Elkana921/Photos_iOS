

import UIKit

//MARK: - Change Date format:
public func changeDateFormat(stringDate date: String, oldFormat format1: String, newForamt format2: String) -> String?{
    
    let formatter = DateFormatter()
    
    formatter.dateFormat =  format1
    let dateDate = formatter.date(from: date) //dateFromString
    
    formatter.dateFormat = format2
    let stringDate = formatter.string(from: dateDate ?? Date()) //stringFromDate
    
    print("oldFormat: \(date) | newFormat: \(String(describing: stringDate))")
    
    return stringDate
}

//MARK: - Add to Favorites
func addToFavorites(_ photoResult: Results) {
    
    let userDefaults = UserDefaults.standard
    
    if let jsonStringOfFavoritesArray = userDefaults.object(forKey: "favorites") as? String  {
        
        if let data = jsonStringOfFavoritesArray.data(using: .utf8) {
            
            var favorites = try? JSONDecoder().decode([Results].self, from: data)
            favorites?.append(photoResult)
            
            if let jJson = try? JSONEncoder().encode(favorites) {
                
                if let stringFromData = String(data: jJson, encoding: .utf8) {
                    userDefaults.set(stringFromData, forKey: "favorites")
                }
            }
        }
        
    }else {
        let newFavorites = [photoResult]
        
        print(newFavorites)
        print("Test Add tofavorites 1")
        
        if let jJson = try? JSONEncoder().encode(newFavorites) {
            print("Test Add tofavorites 2")
            
            if let stringFromData = String(data: jJson, encoding: .utf8) {
                userDefaults.set(stringFromData, forKey: "favorites")
                print("Test Add tofavorites 3")
            }
        }
    }
    
}

//MARK: - Remove from Favorites
func removeFromFavorites(_ photoResult: Results){
    
    let userDefaults = UserDefaults.standard
    
    if let jsonStringOfFavoritesArray = userDefaults.object(forKey: "favorites") as? String  {
        
        if let data = jsonStringOfFavoritesArray.data(using: .utf8) {
            var favorites = try? JSONDecoder().decode([Results].self, from: data)
            print("F count: \(String(describing: favorites?.count))")
            
            favorites?.removeAll(where: { existing in
                print("found")
                return existing.theId == photoResult.theId
            })
            print("F count: \(String(describing: favorites?.count))")

            if let jJson = try? JSONEncoder().encode(favorites) {
                
                if let stringFromData = String(data: jJson, encoding: .utf8) {
                    
                    userDefaults.set(stringFromData, forKey: "favorites")
                }
            }
        }
    }
    
}


//MARK: - Favorites Button:
func toggleFavorites(res: Results, likeBtn: UIButton? = nil) {
    
    let userDefaults = UserDefaults.standard
    let photoID = res.theId
    
    guard userDefaults.object(forKey: photoID) != nil else  {
        
        userDefaults.set(1, forKey: photoID)
        
        if let likeBtn = likeBtn {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        }
        addToFavorites(res)
        return
    }
    
    if ((userDefaults.object(forKey: photoID) as? Int) == 1) {
        
        userDefaults.set(0, forKey: photoID)
        
        if let likeBtn = likeBtn {
            likeBtn.setImage(UIImage(systemName: "heart"), for: .normal)
            print("User -dismiss- 💔 photo, photoID: \(photoID)")
        }
        removeFromFavorites(res)
        
    }else {
        userDefaults.set(1, forKey: photoID)
        
        if let likeBtn = likeBtn {
            likeBtn.setImage(UIImage(systemName: "heart.fill"), for: .normal)
            print("User -like- ♥️ photo, photoID: \(photoID)")
        }
        addToFavorites(res)
    }
    
    let ids = userDefaults.object(forKey: "favorites") as? String
    print("+++ All F IDS: \(ids ?? "null")")
    
}


