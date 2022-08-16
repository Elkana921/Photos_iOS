
import UIKit
import PKHUD
import CoreLocation
import MapKit

private let reuseIdentifier = "cellColleciton"
private let segueIdentifier = "mySegue"

class BaseViewContoller: UIViewController {
        
    //MARK: - Properties:
    var results:[Results] = []
    let ds = PhotosDS()
    weak var baseVCDelegate: BaseViewContollerDelegate?
    let refreshControl = UIRefreshControl()
    
    //MARK: - Outlets:
    @IBOutlet weak var collectionViewVerical: UICollectionView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet var sideBarButton: UIBarButtonItem!
    @IBOutlet var searchBarButton: UIBarButtonItem!
    @IBOutlet weak var sideBarView: UIView!
    @IBOutlet weak var logoView: UIView!{
        didSet{
            logoView.layer.cornerRadius = 10
            logoView.backgroundColor = .white
        }
    }
    @IBOutlet weak var widthConstrain: NSLayoutConstraint? {
        didSet{
            widthConstrain?.constant = 0
        }
    }
    
    //MARK: - Actions:
    @IBAction func searchBarButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "searchSegue", sender: sender)
    }
    
    @IBAction func sideBarButton(_ sender: UIBarButtonItem) {
        
        navigationItem.rightBarButtonItem = nil
        navigationItem.leftBarButtonItem = nil
        logoView.isHidden = true
        
        view.bringSubviewToFront(sideBarView)
        UIView.animate(withDuration: 0.4) {
            self.widthConstrain?.constant = 300
            self.blurView.isHidden = false
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func reloadNewData(){
        
        HUD.flash(.progress, onView: self.view, delay: 0.2)
        
        results = []
        
        ds.fetchPhotos(from: .random, with: ["id" : "H9F4Ptf4PRs", "count": 30]) { photos, error in
            self.updateUI(with: photos, or: error)
        }
        
        collectionViewVerical.reloadData()
        collectionViewVerical.refreshControl?.endRefreshing()
    }
    
    //MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(UIScreen.main.bounds.width)
        
        let nib = UINib(nibName: "PhotosCollectionViewCell", bundle: .main)
        collectionViewVerical?.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        refreshControl.addTarget(self, action: #selector(reloadNewData), for: UIControl.Event.valueChanged)
        collectionViewVerical.refreshControl = refreshControl
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touchLocation = touches.first?.location(in: self.view) else {return}
        if !(sideBarView?.frame.contains(touchLocation) ?? true){
            
            dismissSideBar()
        }
        
    }
    
    //MARK: - Funcs:
    func updateUI(with photos: [Results]?, or error: PhotosDSError?){
        
        let prettyJson = prettyJson(uglyJson: photos)
        
        if let photos = photos{
            
            self.results += photos
            self.collectionViewVerical?.reloadData()
            
            print("+++ The Photos:" ,prettyJson)
            
        }else if let error = error{
            
            print("--- The Errors:" ,error)
            
            showAlertWithAction(title: "⚠️", message: "An error has occured!\nTry Again latter!")
        }
    }
    
    func showAlertWithAction(title: String? = nil, message: String? = nil){
        
        let alertCntroller = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertCntroller.addAction(.init(title: "Dismiss", style: .default))
        
        present(alertCntroller, animated: true)
    }
    
    func prettyJson(uglyJson data: [Results]?) -> String{
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        guard let data = try? encoder.encode(data) else {
            return "Error in the data!!!"
        }
        
        let prettyJson = String(data: data, encoding: .utf8)
        
        return prettyJson ?? "--- Cant print pretty!!!"
    }
    
    public func dismissSideBar() {
        baseVCDelegate?.hideDialog()
        
        Q.ui.asyncAfter(deadline: .now() + 0.3) {
            self.logoView.isHidden = false
            self.navigationItem.rightBarButtonItem = self.sideBarButton
            self.navigationItem.leftBarButtonItem = self.searchBarButton
        }
        
        UIView.animate(withDuration: 0.4){
            self.widthConstrain?.constant = 0
            self.blurView.isHidden = true
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: - Manual Segue:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dest = segue.destination as? DetailsViewController, let indexPath  = sender as? IndexPath {
            
            let results = results[indexPath.item]
            
            dest.results = results
            dest.indexPath = indexPath
            dest.delegate = self
            
        }
        
        if let dest = segue.destination as? SideBarViewController  {
            print("SIDE BAR")
            baseVCDelegate = dest
        }
    }
    
}


//MARK: - UICollectionViewDataSource:
extension BaseViewContoller: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        
        if let myCell = cell as? PhotosCollectionViewCell{
            myCell.populate(with: results[indexPath.item])
        }
        
        return cell
    }
    
}


//MARK: - UICollectionViewDelegate:
extension BaseViewContoller: UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetails", sender: indexPath)
    }

}

//MARK: - Delegate:
extension BaseViewContoller: DetailsViewControllerDelegate{
    
    func likeButtonClicked(indexPath: IndexPath) {
        collectionViewVerical.reloadItems(at: [indexPath])
    }
}

protocol BaseViewContollerDelegate: AnyObject{
    func hideDialog()
}

//MARK: - Flow Layout:
extension BaseViewContoller: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width  = 175
        if UIScreen.main.bounds.width > 390  {
            width = 195
        } else if UIScreen.main.bounds.width > 380 {
            width = 180
        }
        return CGSize(width: width, height: 300)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: UIScreen.main.bounds.width > 420 ? 8 : 4, bottom: 8, right: UIScreen.main.bounds.width > 420 ? 8 : 4)
    }
    
}


