

import UIKit

class HomeViewController: BaseViewContoller{
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        ds.fetchPhotos(from: .random, with: ["id" : "H9F4Ptf4PRs", "count": 30]) { photos, error in
            self.updateUI(with: photos, or: error)
        }
        
    }

}
