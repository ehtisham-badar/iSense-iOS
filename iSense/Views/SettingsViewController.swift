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
    @IBOutlet weak var mainHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var movementMessageTF: UITextField!
    @IBOutlet weak var magnetMessageTF: UITextField!
    @IBOutlet weak var notificationMessageTF: UITextField!
    @IBOutlet weak var heightOfTiltView: NSLayoutConstraint!
    @IBOutlet weak var heightOfMovementView: NSLayoutConstraint!
    //MARK: - Variables
    
    private var isNotificationOn: Bool = true
    private var isMovementOn: Bool = true
    private var isMagnetOn: Bool = true
    
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addGestureToDismissKeyboard()
        setData()
    }
    
    //MARK: - Private Functions
    
    private func setData(){
        notificationOnOffImage.image = UIImage.sensorOff
        movementSensorImage.image = UIImage.sensorOff
        magnetSensorImage.image = UIImage.sensorOff
        
        let seconds = UserDefaults.standard.string(forKey: "seconds")
        let tilt_initial = UserDefaults.standard.string(forKey: "tilt_initial")
        let tilt_final = UserDefaults.standard.string(forKey: "tilt_final")
        let magnet_initial = UserDefaults.standard.string(forKey: "magnet_initial")
        let magnet_final = UserDefaults.standard.string(forKey: "magnet_final")
        let range_confirm = UserDefaults.standard.string(forKey: "range_confirm")
        let wait = UserDefaults.standard.string(forKey: "wait")
        let after_notification = UserDefaults.standard.string(forKey: "after_notification")
        
        let notification_message = UserDefaults.standard.string(forKey: "notification_message")
        let movement_message = UserDefaults.standard.string(forKey: "movement_message")
        let magnet_message = UserDefaults.standard.string(forKey: "magnet_message")
        
        secondsTF.text = seconds
        tiltInitialValueTF.text = tilt_initial
        tiltFinalValueTF.text = tilt_final
        magnetInitialValueTF.text = magnet_initial
        magnetFinalValueTF.text = magnet_final
        rangeConfirmTF.text = range_confirm
        waitTF.text = wait
        notificationTF.text = after_notification
        
        notificationMessageTF.text = notification_message
        movementMessageTF.text = movement_message
        magnetMessageTF.text = magnet_message
        
        let isNotificationOn = UserDefaults.standard.bool(forKey: "is_notification_on")
        let isMovementOn = UserDefaults.standard.bool(forKey: "is_movement_on")
        let isMagnetOn = UserDefaults.standard.bool(forKey: "is_magnet_on")
        
        notificationOnOffImage.image = (!isNotificationOn) ? UIImage.sensorOff : UIImage.sensorOn
        heightOfNotificationView.constant = isNotificationOn ? 430 : 270
        mainHeightConstraint.constant = isNotificationOn ? mainHeightConstraint.constant+200 : mainHeightConstraint.constant-160
        
        movementSensorImage.image = (!isMovementOn) ? UIImage.sensorOff : UIImage.sensorOn
        heightOfMovementView.constant = isMovementOn ? 380 : 220
        mainHeightConstraint.constant = isMovementOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
        
        magnetSensorImage.image = (!isMagnetOn) ? UIImage.sensorOff : UIImage.sensorOn
        heightOfTiltView.constant = isMagnetOn ? 380 : 220
        mainHeightConstraint.constant = isMagnetOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
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
            UserDefaults.standard.set(tiltInitialValueTF.text ?? "", forKey: "tilt_initial")
            UserDefaults.standard.set(tiltFinalValueTF.text ?? "", forKey: "tilt_final")
            UserDefaults.standard.set(magnetInitialValueTF.text ?? "", forKey: "magnet_initial")
            UserDefaults.standard.set(magnetFinalValueTF.text ?? "", forKey: "magnet_final")
            UserDefaults.standard.set(rangeConfirmTF.text ?? "", forKey: "range_confirm")
            UserDefaults.standard.set(waitTF.text ?? "", forKey: "wait")
            UserDefaults.standard.set(notificationTF.text ?? "", forKey: "after_notification")
            
            UserDefaults.standard.set(notificationMessageTF.text ?? "", forKey: "notification_message")
            UserDefaults.standard.set(movementMessageTF.text ?? "", forKey: "movement_message")
            UserDefaults.standard.set(magnetMessageTF.text ?? "", forKey: "magnet_message")
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
        UserDefaults.standard.set(isNotificationOn, forKey: "is_notification_on")
        heightOfNotificationView.constant = isNotificationOn ? 430 : 270
        mainHeightConstraint.constant = isNotificationOn ? mainHeightConstraint.constant+200 : mainHeightConstraint.constant-160
    }
    
    @IBAction func movementBtnPressed(_ sender: Any) {
        movementSensorImage.image = (movementSensorImage.image == UIImage.sensorOn) ? UIImage.sensorOff : UIImage.sensorOn
        isMovementOn = (movementSensorImage.image == UIImage.sensorOn) ? true : false
        UserDefaults.standard.set(isMovementOn, forKey: "is_movement_on")
        heightOfMovementView.constant = isMovementOn ? 380 : 220
        mainHeightConstraint.constant = isMovementOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
    }
    
    @IBAction func magnetBtnPressed(_ sender: Any) {
        magnetSensorImage.image = (magnetSensorImage.image == UIImage.sensorOn) ? UIImage.sensorOff : UIImage.sensorOn
        isMagnetOn = (magnetSensorImage.image == UIImage.sensorOn) ? true : false
        UserDefaults.standard.set(isMagnetOn, forKey: "is_magnet_on")
        heightOfTiltView.constant = isMagnetOn ? 380 : 220
        mainHeightConstraint.constant = isMagnetOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
    }
}
