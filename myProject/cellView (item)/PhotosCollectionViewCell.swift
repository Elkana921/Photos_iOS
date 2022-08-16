

import UIKit
import SDWebImage


class PhotosCollectionViewCell: UICollectionViewCell {
    
    //Properties:
    var results:Results?
    var likeButtom: UIImageView?
    public let userDefaults = UserDefaults.standard
    
    //Outlets:
    @IBOutlet weak var photoImageView1: UIImageView!{
        didSet{
            photoImageView1.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var cellView: UIView!{
        didSet{
            cellView.layer.cornerRadius = 10
        }
    }
    @IBOutlet var likeBtn: UIButton!
    
    //Actions:
    @IBAction func likeButton(_ sender: AnyObject) {
        
        guard let res = results else {return}
        toggleFavorites(res: res, likeBtn: likeBtn)
    }
    
    //Funcs:
    func populate(with results: Results){
        
        self.likeBtn.setImage(UIImage(systemName: "heart")!, for: .normal)
        self.results = results
        
        if let liked = userDefaults.object(forKey: results.theId) as? Int {
            if liked == 1 {
                self.likeBtn.setImage(UIImage(systemName: "heart.fill")!, for: .normal)
            }
        }
        
        cellView.backgroundColor = results.hexColor
        
        //TODO: From Stirng URL Image => to UIImage ✅
        guard let urlString = results.urls?.thumbPhoto else {return}
        photoImageView1.loadImage(with: urlString)
        
        /*
//        +++ An option to used with SDWebImage Library:
        
        guard let urlString = results.urls?.thumbPhoto,
              let url = URL(string: urlString) else {return}
        photoImageView1.sd_setImage(with: url)
        
         */
        
    }
    
}
