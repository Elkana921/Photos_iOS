

import UIKit

class SideBarViewController: UIViewController {
   
    //MARK: - Outlets:
    @IBOutlet weak var aboutView: UIView!{
        didSet{
            aboutView.layer.cornerRadius = 10
        }
    }
    @IBOutlet weak var viewHeightConstraint: NSLayoutConstraint!{
        didSet{
            viewHeightConstraint.constant = 0
        }
    }
    @IBOutlet weak var viewWidthConstraint: NSLayoutConstraint!{
        didSet{
            viewWidthConstraint.constant = 0
        }
    }
    @IBOutlet weak var aboutOutlet: UIButton!
    
    //MARK: - Actions:
    @IBAction func favoritesButton(_ sender: UIButton) {
        
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as? UITabBarController else {
            print("--- Nav to Favorites Fails :(")
            return
        }
        
        vc.modalPresentationStyle = .fullScreen
        vc.selectedIndex = 1
        present(vc, animated: false, completion: nil)
        
    }
    
    @IBAction func aboutButton(_ sender: UIButton) {
        showAndHideAboutView()
    }
    
    //MARK: - Funcs:
    func showAndHideAboutView(){
        
        if self.viewHeightConstraint?.constant == 0 && self.viewWidthConstraint?.constant == 0{
            
            UIView.animate(withDuration: 0.4) {
                self.viewHeightConstraint?.constant = 100
                self.viewWidthConstraint?.constant = 200
            }
            
        }else{
            UIView.animate(withDuration: 0.4) {
                self.viewHeightConstraint?.constant = 0
                self.viewWidthConstraint?.constant = 0
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        hideAboutView()
    }
    
    func hideAboutView(){
        if self.viewHeightConstraint?.constant == 100 && self.viewWidthConstraint?.constant == 200 {
            UIView.animate(withDuration: 0.4) {
                self.viewHeightConstraint?.constant = 0
                self.viewWidthConstraint?.constant = 0
            }
        }
    }
    
    //MARK: - LifeCycle:
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        
        print("UpdateConstraiants")
        hideAboutView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        guard let touchLocation = touches.first?.location(in: self.view) else {return}
        
        if !(aboutView?.frame.contains(touchLocation) ?? true){
            hideAboutView()
        }
    }
    
}

//MARK: - Delegate:
extension SideBarViewController: BaseViewContollerDelegate{
    func hideDialog() {
        hideAboutView()
    }
}
