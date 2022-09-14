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
    @IBOutlet weak var notificationSideConstraint: NSLayoutConstraint!
    @IBOutlet weak var notiSensorBackView: UIView!
    @IBOutlet weak var notiSensorSwitchView: UIView!
    @IBOutlet weak var tiltSensorBackView: UIView!
    @IBOutlet weak var tileSensorSwitchView: UIView!
    @IBOutlet weak var tileSideConstraint: NSLayoutConstraint!
    @IBOutlet weak var magnetSensorBackView: UIView!
    @IBOutlet weak var magnetSensorSwitchView: UIView!
    @IBOutlet weak var magnetSideConstraint: NSLayoutConstraint!
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
        notificationSideConstraint.constant = 50
        tileSideConstraint.constant = 50
        magnetSideConstraint.constant = 50
        
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
        
        notificationSideConstraint.constant = (!isNotificationOn) ? 50 : 0
        heightOfNotificationView.constant = isNotificationOn ? 430 : 270
//        mainHeightConstraint.constant = isNotificationOn ? mainHeightConstraint.constant+200 : mainHeightConstraint.constant-160
        notiSensorBackView.backgroundColor = isNotificationOn ? UIColor.color1 : UIColor.red2
        notiSensorSwitchView.backgroundColor = isNotificationOn ? UIColor.color2 : UIColor.red1
        
//        movementSensorImage.image = (!isMovementOn) ? UIImage.sensorOff : UIImage.sensorOn
        tileSideConstraint.constant = (!isMovementOn) ? 50 : 0
        heightOfMovementView.constant = isMovementOn ? 380 : 220
//        mainHeightConstraint.constant = isMovementOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
        tiltSensorBackView.backgroundColor = isMovementOn ? UIColor.color1 : UIColor.red2
        tileSensorSwitchView.backgroundColor = isMovementOn ? UIColor.color2 : UIColor.red1
        
        magnetSideConstraint.constant = (!isMagnetOn) ? 50 : 0
        magnetSensorImage.image = (!isMagnetOn) ? UIImage.sensorOff : UIImage.sensorOn
        heightOfTiltView.constant = isMagnetOn ? 380 : 220
//        mainHeightConstraint.constant = isMagnetOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
        magnetSensorBackView.backgroundColor = isMagnetOn ? UIColor.color1 : UIColor.red2
        magnetSensorSwitchView.backgroundColor = isMagnetOn ? UIColor.color2 : UIColor.red1
        if isNotificationOn && isMovementOn && isMagnetOn{
            mainHeightConstraint.constant = mainHeightConstraint.constant + 160 + 160 + 160
        }else if isNotificationOn && isMovementOn && !isMagnetOn{
            mainHeightConstraint.constant = mainHeightConstraint.constant + 160 + 160
        }else if isNotificationOn && !isMovementOn && !isMagnetOn{
            mainHeightConstraint.constant = mainHeightConstraint.constant + 160
        }else if !isNotificationOn && !isMovementOn && isMagnetOn{
            mainHeightConstraint.constant = mainHeightConstraint.constant + 160
        }else if !isNotificationOn && isMovementOn && !isMagnetOn{
            mainHeightConstraint.constant = mainHeightConstraint.constant + 160
        }else if isNotificationOn && !isMovementOn && isMagnetOn{
            mainHeightConstraint.constant = mainHeightConstraint.constant + 160 + 160
        }else if !isNotificationOn && isMovementOn && isMagnetOn{
            mainHeightConstraint.constant = mainHeightConstraint.constant + 160 + 160
        }else if !isNotificationOn && !isMovementOn && !isMagnetOn{
            mainHeightConstraint.constant = mainHeightConstraint.constant
        }
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
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.notificationSideConstraint.constant = (self.notificationSideConstraint.constant == 0) ? 50 : 0
            self.view.layoutIfNeeded()
        }
        isNotificationOn = (notificationSideConstraint.constant == 0) ? true : false
        UserDefaults.standard.set(isNotificationOn, forKey: "is_notification_on")
        heightOfNotificationView.constant = isNotificationOn ? 430 : 270
        mainHeightConstraint.constant = isNotificationOn ? mainHeightConstraint.constant+200 : mainHeightConstraint.constant-160
        notiSensorBackView.backgroundColor = isNotificationOn ? UIColor.color1 : UIColor.red2
        notiSensorSwitchView.backgroundColor = isNotificationOn ? UIColor.color2 : UIColor.red1
    }
    
    @IBAction func movementBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.tileSideConstraint.constant = (self.tileSideConstraint.constant == 0) ? 50 : 0
            self.view.layoutIfNeeded()
        }
        isMovementOn = (tileSideConstraint.constant == 0) ? true : false
        UserDefaults.standard.set(isMovementOn, forKey: "is_movement_on")
        heightOfMovementView.constant = isMovementOn ? 380 : 220
        mainHeightConstraint.constant = isMovementOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
        tiltSensorBackView.backgroundColor = isMovementOn ? UIColor.color1 : UIColor.red2
        tileSensorSwitchView.backgroundColor = isMovementOn ? UIColor.color2 : UIColor.red1
    }
    
    @IBAction func magnetBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.magnetSideConstraint.constant = (self.magnetSideConstraint.constant == 0) ? 50 : 0
            self.view.layoutIfNeeded()
        }
        isMagnetOn = (magnetSideConstraint.constant == 0) ? true : false
        UserDefaults.standard.set(isMagnetOn, forKey: "is_magnet_on")
        heightOfTiltView.constant = isMagnetOn ? 380 : 220
        mainHeightConstraint.constant = isMagnetOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
        magnetSensorBackView.backgroundColor = isMagnetOn ? UIColor.color1 : UIColor.red2
        magnetSensorSwitchView.backgroundColor = isMagnetOn ? UIColor.color2 : UIColor.red1
    }
}
