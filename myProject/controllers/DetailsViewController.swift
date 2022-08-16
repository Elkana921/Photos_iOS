

import UIKit
import SDWebImage


class DetailsViewController: UIViewController{
    
    //Properties:
    var indexPath: IndexPath!
    var results: Results?
    let userDefaults = UserDefaults.standard
    weak var delegate: DetailsViewControllerDelegate!
    
    //Outlets:
    @IBOutlet weak var photoImageView: UIImageView!{
        didSet{
            photoImageView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var createdAtLable: UILabel!
    @IBOutlet weak var photoDescriptionLable: UILabel!
    @IBOutlet weak var altDescripitonLable: UILabel!
    @IBOutlet weak var likeBtn: UIButton!
    
    //Actions:
    @IBAction func likeButton(_ sender: UIButton) {
        
        guard let res = results else {return}
        toggleFavorites(res: res, likeBtn: likeBtn)
        
        delegate.likeButtonClicked(indexPath: indexPath)
    }
    
    //MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()

        let prettyJson = prettyJson(uglyJson: results)
        print("*** User click on the item:\n", prettyJson)
        
        if let results = results, let liked = userDefaults.object(forKey: results.theId) as? Int {
            if liked == 1 {
                self.likeBtn.setImage(UIImage(systemName: "heart.fill")!, for: .normal)
            }
        }
        
        guard let urlString = results?.urls?.regular else {return}
        photoImageView.loadImage(with: urlString)
       
        guard let date = results?.createdAt else {return}
        let stringDate = changeDateFormat(stringDate: date, oldFormat: "yyyy-MM-dd'T'HH:mm:ssZ", newForamt: "MMM d, yyyy")
        
        createdAtLable.text = stringDate
        photoDescriptionLable.text = results?.photoDescription?.capitalizingFirstLetter() ?? "(No Description!)"
        altDescripitonLable.text = results?.altDescription?.capitalizingFirstLetter() ?? "(No Alt Description!)"
        photoImageView.backgroundColor = results?.hexColor
        

    }
    
    //MARK: - Funcs:
    private func prettyJson(uglyJson data: Results?) -> String{

        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted

        guard let data = try? encoder.encode(data) else {
            return "Error in the data!!!"
        }

        let prettyJson = String(data: data, encoding: .utf8)

        return prettyJson ?? "--- Cant print pretty!!!"
    }
    
}

protocol DetailsViewControllerDelegate: AnyObject{
    func likeButtonClicked(indexPath: IndexPath)
}
