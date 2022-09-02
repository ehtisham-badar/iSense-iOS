//
//  SettingsViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 27/08/2022.
//

import UIKit

class SettingsViewController: UIViewController {

    //MARK: - IBOutlets
    
    @IBOutlet weak var secondsTF: UITextField!
    @IBOutlet weak var notificationOnOffImage: UIImageView!
    @IBOutlet weak var heightOfNotificationView: NSLayoutConstraint!
    
    //MARK: - Variables
    
    private var isNotificationOn: Bool = true
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureToDismissKeyboard()
        setData()
    }
    
    //MARK: - Private Functions
    
    private func setData(){
        notificationOnOffImage.image = UIImage.sensorOff
        guard let seconds = UserDefaults.standard.string(forKey: "seconds") else{
            return
        }
        secondsTF.text = seconds
    }
    
    func addGestureToDismissKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        if secondsTF.text != ""{ 
            UserDefaults.standard.set(secondsTF.text ?? "", forKey: "seconds")
        }
        view.endEditing(true)
    }
    
    //MARK: - IBActions
    
    @IBAction func didPressBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func getNotificationPressed(_ sender: Any) {
        notificationOnOffImage.image = (notificationOnOffImage.image == UIImage.sensorOn) ? UIImage.sensorOff : UIImage.sensorOn
        isNotificationOn = (notificationOnOffImage.image == UIImage.sensorOn) ? true : false
    }
}
extension SettingsViewController: UITextFieldDelegate{
    
}
