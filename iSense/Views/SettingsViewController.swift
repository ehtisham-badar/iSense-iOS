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
    @IBOutlet weak var movementSensorImage: UIImageView!
    @IBOutlet weak var magnetSensorImage: UIImageView!
    @IBOutlet weak var tiltInitialValueTF: UITextField!
    @IBOutlet weak var tiltFinalValueTF: UITextField!
    @IBOutlet weak var magnetInitialValueTF: UITextField!
    @IBOutlet weak var magnetFinalValueTF: UITextField!
    @IBOutlet weak var rangeConfirmTF: UITextField!
    @IBOutlet weak var waitTF: UITextField!
    @IBOutlet weak var notificationTF: UITextField!
    
    //MARK: - Variables
    
    private var isNotificationOn: Bool = true
    private var isMovementOn: Bool = true
    private var isMagnetOn: Bool = true
    
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureToDismissKeyboard()
        setData()
        secondsTF.setPlaceholder()
        tiltInitialValueTF.setPlaceholder()
        tiltFinalValueTF.setPlaceholder()
        magnetInitialValueTF.setPlaceholder()
        magnetFinalValueTF.setPlaceholder()
        rangeConfirmTF.setPlaceholder()
        waitTF.setPlaceholder()
        notificationTF.setPlaceholder()
    }
    
    //MARK: - Private Functions
    
    private func setData(){
        notificationOnOffImage.image = UIImage.sensorOff
        movementSensorImage.image = UIImage.sensorOff
        magnetSensorImage.image = UIImage.sensorOff
        
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
    
    @IBAction func movementBtnPressed(_ sender: Any) {
        movementSensorImage.image = (movementSensorImage.image == UIImage.sensorOn) ? UIImage.sensorOff : UIImage.sensorOn
        isMovementOn = (movementSensorImage.image == UIImage.sensorOn) ? true : false
    }
    
    @IBAction func magnetBtnPressed(_ sender: Any) {
        magnetSensorImage.image = (magnetSensorImage.image == UIImage.sensorOn) ? UIImage.sensorOff : UIImage.sensorOn
        isMagnetOn = (magnetSensorImage.image == UIImage.sensorOn) ? true : false
    }
}
extension SettingsViewController: UITextFieldDelegate{
    
}
extension UITextField{
    func setPlaceholder(){
        self.backgroundColor = .clear
        self.attributedPlaceholder = NSAttributedString(
            string: "0",
            attributes: [NSAttributedString.Key.foregroundColor: UIColor.appYellowColor!]
        )
    }
}
