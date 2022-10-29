//
//  RenamePopupViewController.swift
//  iSense
//
//  Created by Abdullah on 21/10/2022.
//

import UIKit

protocol RemoveEditDelegate {
    func updateDone(name: String?)
}

class RenamePopupViewController: UIViewController {
    
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var deleteView: UIView!
    
    var delegate: RemoveEditDelegate!
    var index: Int!
    var data = [[String:Any]]()
    var isFromRename: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGesture()
        if !isFromRename{
            data = UserDefaults.standard.object(forKey: "data") as? [[String:Any]] ?? [[String:Any]]()

            name.text = data[index]["name"] as? String ?? ""
        }else{
            var arrayDictionary = UserDefaults.standard.array(forKey: "data") ?? []
            name.text = "Pre-Set \(arrayDictionary.count)"
        }
        
        deleteView.isHidden = isFromRename ? true : false
    }
    
    @IBAction func crossBtnPressed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    @IBAction func editButton(){
        if(!(name.text!.isEmpty)){
            if !isFromRename{
                data[index]["name"] = name.text
                UserDefaults.standard.set(data, forKey: "data")
            }
            
            
            delegate.updateDone(name: name.text)
            
            self.dismiss(animated: true)
        }else{
            let controller = UIAlertController(title: "Error", message: "Name cannot be empty", preferredStyle: .alert)
            controller.addAction(UIAlertAction(title: "Ok", style: .default))
            
            self.present(controller, animated: true)
        }        
    }
    
    @IBAction func deleteButton(){
        
        let controller = UIAlertController(title: "Confirmation", message: "Are you sure you want to delete the settings?", preferredStyle: .alert)
        controller.addAction(UIAlertAction(title: "Yes", style: .destructive,handler: { [self] _ in
            data.remove(at: index)
            
            UserDefaults.standard.set(data, forKey: "data")
            
            UserDefaults.standard.set(0, forKey: "pre-selected")
            
            delegate.updateDone(name: nil)
            
            self.dismiss(animated: true)
        }))
        
        controller.addAction(UIAlertAction(title: "No", style: .cancel))
        
        self.present(controller, animated: true)
    }
    
    func addGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        self.blurView.addGestureRecognizer(tap)
    }
    @objc func dismissView(){
        self.dismiss(animated: true)
    }
}
