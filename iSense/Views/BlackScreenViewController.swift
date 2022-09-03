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
    
    func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.view.addGestureRecognizer(tap)
    }
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
}
