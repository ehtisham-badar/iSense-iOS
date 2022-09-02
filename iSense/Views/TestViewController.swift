//
//  TestViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 27/08/2022.
//

import UIKit

class TestViewController: BaseViewController {

    //MARK: - IBOutlets
    
    
    //MARK: - Variables
    
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    //MARK: - Private Functions
    
    
    //MARK: - IBActions
    
    @IBAction func didPressBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
