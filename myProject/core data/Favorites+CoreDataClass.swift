

import UIKit
import CoreData

@objc(Favorites)
public class Favorites: NSManagedObject {
    
    convenience init(photoID: String){
        self.init(context: CoreDataManager.shared.context)
        
        self.photoID = photoID
    }
    
    public override var description: String{
        return "\(String(describing: photoID))"
    }
    
}
