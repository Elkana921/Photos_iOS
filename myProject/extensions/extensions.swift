

import UIKit

//MARK: - Parse HEX Color (from JSON) to => UIColor

//For Decodable:
extension UIColor{
    
    convenience init(hexString: String){
        
        var colorString = hexString.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if colorString.hasPrefix("#"){
            colorString.remove(at: colorString.startIndex)
        }
        
        if colorString.count != 6{
            self.init()
            return
        }
        
        let rgbValue = Int(colorString, radix: 16) ?? 0
        
        let red = CGFloat((rgbValue & 0xff0000) >> 16) / 255.0 //0xff0000 = 0b11111111_00000000_00000000
        let green = CGFloat((rgbValue & 0x00ff00) >> 8) / 255.0
        let blue = CGFloat(rgbValue & 0x0000ff) / 255.0
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}

//For Encodable:
extension UIColor{
    
    var rgbHexString: String{
        
        //At red case...
        var r:CGFloat = 0 //debug 1
        var g:CGFloat = 0 //debug 0
        var b:CGFloat = 0 //debug 0
        var a:CGFloat = 0 //debug 1
        
        getRed(&r, green: &g, blue: &b, alpha: &a)
        
        var rgb = 0 //0x00_00_00
        
        rgb = rgb | Int(r * 255) << 16
        rgb = rgb | Int(g * 255) << 8
        rgb = rgb | Int(b * 255)
        
        return "#\(String(rgb, radix: 16, uppercase: true))" //#ff0000
    }
}

//MARK: - Load ImageView from urlString:
extension UIImageView{
    
    func loadImage(with urlString: String?){
        
        if let image = urlString,
           let url = URL(string: image){
            
            URLSession.shared.dataTask(with: url) { data, _, error in
                
                if let data = data, error == nil{
                    
                    Q.ui.async {
                        let image = UIImage(data: data)
                        self.image = image
                    }
                    
                }
                
            }.resume()
            
        }else{
            self.image = UIImage(systemName: "photo")
        }
    }
}

//MARK: - Capitalize the first letter of a String
extension String{
    func capitalizingFirstLetter() -> String{
        return prefix(1).capitalized + dropFirst()
    }
    
    mutating func capitalizingFirstLetter(){
        self = self.capitalizingFirstLetter()
    }
}
