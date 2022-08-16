

import UIKit

class FavoritesViewController: BaseViewContoller {
    
    //Properties:
    var favoritesList:[Results] = []
    let userDefaults = UserDefaults.standard
    var res: Results?
    
    //Outlets:
    @IBOutlet weak var likeListCollectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl.addTarget(self, action: #selector(loadFavorites), for: UIControl.Event.valueChanged)
        collectionViewVerical.refreshControl = refreshControl
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFavorites()
    }
   
    @objc func loadFavorites () {
        
        if let jsonStringOfFavoritesArray = userDefaults.object(forKey: "favorites") as? String { // " [ {photoUrl,name:... } ]"
            if let data = jsonStringOfFavoritesArray.data(using: .utf8) {
                if let favorites = try? JSONDecoder().decode([Results].self, from: data) {
                    favoritesList = favorites
                    collectionViewVerical.reloadData()
                }
            }
        }else {
            print("favoriters is null")
        }
        
        collectionViewVerical.refreshControl?.endRefreshing()
    }
    
}

//UICollectionViewDataSource:
extension FavoritesViewController{
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoritesList.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellColleciton", for: indexPath)
        
        if let myCell = cell as? PhotosCollectionViewCell{
            myCell.populate(with: favoritesList[indexPath.item])
            
        }
        
        return cell
    }
    
}


