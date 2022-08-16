

import UIKit

class SearchViewController: BaseViewContoller {
    
    //Outlet:
    @IBOutlet weak var searchBar: UISearchBar!{
        didSet{
            searchBar.searchTextField.textColor = .black
            searchBar.searchTextField.leftView?.tintColor = .gray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar?.searchTextField.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        collectionViewVerical.refreshControl = nil
    }
     func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }
    
}

extension SearchViewController: UISearchBarDelegate{
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text else {return}
        self.results = []

        ds.fetchPhotos(from: .search, with: ["query": text, "per_page": 30]) { photos, photosError in
            self.updateUI(with: photos, or: photosError)
        }
        
        //Dissmis keyboard when enter/search tapped:
        self.searchBar.endEditing(true)
        
    }
    
}
