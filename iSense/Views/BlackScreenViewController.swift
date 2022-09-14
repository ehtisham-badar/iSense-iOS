//
//  BlackScreenViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 03/09/2022.
//

import UIKit

class BlackScreenViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name("check"), object: nil, queue: .main) { noti in
            print("hrllo d")
        }
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool { return true }

    //MARK: - Load View
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    
    func addGesture(){
        let tap = UISwipeGestureRecognizer(target: self, action: #selector(dismissView))
        tap.numberOfTouchesRequired = 3
        tap.direction = .down
        self.view.addGestureRecognizer(tap)
    }
    
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
//        NotificationCenter.default.post(name: Notification.Name("stopSensor"), object: nil)
        
    }
}
