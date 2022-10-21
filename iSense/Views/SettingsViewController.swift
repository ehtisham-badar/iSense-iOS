//
//  SettingsViewController.swift
//  iSense
//
//  Created by  Abdullah Javed on 27/08/2022.
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
    
    
    
    @IBOutlet weak var restartMessageTF: UITextField!
    @IBOutlet weak var restartSensorSeconds: UITextField!
    
    
    @IBOutlet weak var restartSideConstraint: NSLayoutConstraint!
    @IBOutlet weak var highetOfRestartView: NSLayoutConstraint!
    
    @IBOutlet weak var restartNotificationBackView: UIView!
    @IBOutlet weak var restartSwitchView: UIView!
    @IBOutlet weak var vibrationSensorImage: UIImageView!
    @IBOutlet weak var vibrationSideConstraint: NSLayoutConstraint!
    @IBOutlet weak var hapticsTF: UITextField!
    
    @IBOutlet weak var vibrationSensorSwitchView: UIView!
    @IBOutlet weak var vibrationSensorBackView: UIView!
    
    @IBOutlet weak var autoLockSensorImage: UIImageView!
    @IBOutlet weak var autolockSensorSwitchView: UIView!
    @IBOutlet weak var autolockSensorBackView: UIView!
    @IBOutlet weak var autoLockSideContraint: NSLayoutConstraint!
    @IBOutlet weak var heightOfAutoLockView: NSLayoutConstraint!
    @IBOutlet weak var heightOfVibrationView: NSLayoutConstraint!
    
    
    @IBOutlet weak var restartOnOffSideConstraint: NSLayoutConstraint!
    @IBOutlet weak var restartOnOffBackView: UIView!
    @IBOutlet weak var restartOnOffSwitchView: UIView!
    
    //MARK: - Variables
    
    private var isNotificationOn: Bool = true
    private var isRestartOn: Bool = true
    private var isMovementOn: Bool = true
    private var isMagnetOn: Bool = true
    private var isAutoLockOn: Bool = true
    private var isVibrationOn: Bool = true
    private var isRestartOnOff: Bool = true
    private var isSaveSettingPressed: Bool = false
    
    var tap: UITapGestureRecognizer!
    
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
        let restart_seconds = UserDefaults.standard.string(forKey: "restart_seconds")

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
        
        let restart_message = UserDefaults.standard.string(forKey: "restart_message")
        
        let is_restart_on_off = UserDefaults.standard.bool(forKey: "is_restart_on")
                        
        secondsTF.text = seconds
        tiltInitialValueTF.text = tilt_initial
        tiltFinalValueTF.text = tilt_final
        magnetInitialValueTF.text = magnet_initial
        magnetFinalValueTF.text = magnet_final
        rangeConfirmTF.text = range_confirm
        waitTF.text = wait
        notificationTF.text = after_notification
        
        restartSensorSeconds.text = restart_seconds
        
        notificationMessageTF.text = notification_message
        movementMessageTF.text = movement_message
        magnetMessageTF.text = magnet_message
        
        restartMessageTF.text = restart_message
        
        let isNotificationOn = UserDefaults.standard.bool(forKey: "is_notification_on")
        let isMovementOn = UserDefaults.standard.bool(forKey: "is_movement_on")
        let isMagnetOn = UserDefaults.standard.bool(forKey: "is_magnet_on")
        
        let isRestartOn = UserDefaults.standard.bool(forKey: "is_restart_on_notification")
        
        notificationSideConstraint.constant = (!isNotificationOn) ? 50 : 0
        heightOfNotificationView.constant = isNotificationOn ? 430 : 270
        mainHeightConstraint.constant = isNotificationOn ? mainHeightConstraint.constant+70 : mainHeightConstraint.constant-160
        notiSensorBackView.backgroundColor = isNotificationOn ? UIColor.color1 : UIColor.red2
        notiSensorSwitchView.backgroundColor = isNotificationOn ? UIColor.color2 : UIColor.red1
        
        
        restartSideConstraint.constant = (!isRestartOn) ? 50 : 0
        highetOfRestartView.constant = isRestartOn ? 460 : 335
        mainHeightConstraint.constant = isNotificationOn ? mainHeightConstraint.constant+70 : mainHeightConstraint.constant-160
        restartNotificationBackView.backgroundColor = isRestartOn ? UIColor.color1 : UIColor.red2
        restartSwitchView.backgroundColor = isRestartOn ? UIColor.color2 : UIColor.red1
        
        
//        movementSensorImage.image = (!isMovementOn) ? UIImage.sensorOff : UIImage.sensorOn
        tileSideConstraint.constant = (!isMovementOn) ? 50 : 0
        heightOfMovementView.constant = isMovementOn ? 380 : 220
        mainHeightConstraint.constant = isMovementOn ? mainHeightConstraint.constant+70 : mainHeightConstraint.constant-100
        tiltSensorBackView.backgroundColor = isMovementOn ? UIColor.color1 : UIColor.red2
        tileSensorSwitchView.backgroundColor = isMovementOn ? UIColor.color2 : UIColor.red1
        
        magnetSideConstraint.constant = (!isMagnetOn) ? 50 : 0
        magnetSensorImage.image = (!isMagnetOn) ? UIImage.sensorOff : UIImage.sensorOn
        heightOfTiltView.constant = isMagnetOn ? 380 : 220
        mainHeightConstraint.constant = isMagnetOn ? mainHeightConstraint.constant+70 : mainHeightConstraint.constant-100
        magnetSensorBackView.backgroundColor = isMagnetOn ? UIColor.color1 : UIColor.red2
        magnetSensorSwitchView.backgroundColor = isMagnetOn ? UIColor.color2 : UIColor.red1
        
        restartOnOffSideConstraint.constant = (!is_restart_on_off) ? 50 : 0
//        magnetSensorImage.image = (!is_restart_on_off) ? UIImage.sensorOff : UIImage.sensorOn
        mainHeightConstraint.constant = isMagnetOn ? mainHeightConstraint.constant+70 : mainHeightConstraint.constant-100
        restartOnOffBackView.backgroundColor = is_restart_on_off ? UIColor.color1 : UIColor.red2
        restartOnOffSwitchView.backgroundColor = is_restart_on_off ? UIColor.color2 : UIColor.red1
        
        
//        if isNotificationOn && isMovementOn && isMagnetOn{
//            mainHeightConstraint.constant = mainHeightConstraint.constant + 160 + 160 + 160
//        }else if isNotificationOn && isMovementOn && !isMagnetOn{
//            mainHeightConstraint.constant = mainHeightConstraint.constant + 160 + 160
//        }else if isNotificationOn && !isMovementOn && !isMagnetOn{
//            mainHeightConstraint.constant = mainHeightConstraint.constant + 160
//        }else if !isNotificationOn && !isMovementOn && isMagnetOn{
//            mainHeightConstraint.constant = mainHeightConstraint.constant + 160
//        }else if !isNotificationOn && isMovementOn && !isMagnetOn{
//            mainHeightConstraint.constant = mainHeightConstraint.constant + 160
//        }else if isNotificationOn && !isMovementOn && isMagnetOn{
//            mainHeightConstraint.constant = mainHeightConstraint.constant + 160 + 160
//        }else if !isNotificationOn && isMovementOn && isMagnetOn{
//            mainHeightConstraint.constant = mainHeightConstraint.constant + 160 + 160
//        }else if !isNotificationOn && !isMovementOn && !isMagnetOn{
//            mainHeightConstraint.constant = mainHeightConstraint.constant
//        }
    }
    
    func addGestureToDismissKeyboard(){
        tap = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard(){
        if isSaveSettingPressed{
            return
        }
        if secondsTF.text != ""{
            
            var arrayDictionary = UserDefaults.standard.array(forKey: "data") ?? []
            
            var d1: [String:Any] = [
                "seconds" : secondsTF.text ?? "",
                "tilt_initial" : tiltInitialValueTF.text ?? "",
                "tilt_final" : tiltFinalValueTF.text ?? "",
                "magnet_initial" : magnetInitialValueTF.text ?? "",
                "magnet_final" : magnetFinalValueTF.text ?? "",
                "range_confirm" : rangeConfirmTF.text ?? "",
                "wait" : waitTF.text ?? ""
            ]
                        
            let d2 = [
                    "after_notification" : notificationTF.text ?? "",
                    "notification_message" : notificationMessageTF.text ?? "",
                    "movement_message" : movementMessageTF.text ?? "",
                    "magnet_message" : magnetMessageTF.text ?? "",
                    "restart_message" : restartMessageTF.text ?? "",
                    "restart_seconds" : restartSensorSeconds.text ?? ""
            ]
            d1.merge(dict: d2)
            
            arrayDictionary.append(d1)
//
            UserDefaults.standard.set(arrayDictionary, forKey: "data" )
            
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
                        
            UserDefaults.standard.set(restartMessageTF.text ?? "", forKey: "restart_message")
            
            UserDefaults.standard.set(restartSensorSeconds.text ?? "", forKey: "restart_seconds")
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
    
    @IBAction func restartOnOffBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.restartOnOffSideConstraint.constant = (self.restartOnOffSideConstraint.constant == 0) ? 50 : 0
            self.view.layoutIfNeeded()
        }
        isRestartOnOff = (restartOnOffSideConstraint.constant == 0) ? true : false
        UserDefaults.standard.set(isRestartOnOff, forKey: "is_restart_on")
        restartOnOffBackView.backgroundColor = isRestartOnOff ? UIColor.color1 : UIColor.red2
        restartOnOffSwitchView.backgroundColor = isRestartOnOff ? UIColor.color2 : UIColor.red1
    }
    
    @IBAction func getRestartBtnPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.restartSideConstraint.constant = (self.restartSideConstraint.constant == 0) ? 50 : 0
            self.view.layoutIfNeeded()
        }
        isRestartOn = (restartSideConstraint.constant == 0) ? true : false
        UserDefaults.standard.set(isRestartOn, forKey: "is_restart_on_notification")
        highetOfRestartView.constant = isRestartOn ? 460 : 335
        mainHeightConstraint.constant = isRestartOn ? mainHeightConstraint.constant+200 : mainHeightConstraint.constant-160
        restartNotificationBackView.backgroundColor = isRestartOn ? UIColor.color1 : UIColor.red2
        restartSwitchView.backgroundColor = isRestartOn ? UIColor.color2 : UIColor.red1
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
    @IBAction func presetBtnPressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: PresetViewController.self)) as! PresetViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func vibrationSensorBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.vibrationSideConstraint.constant = (self.vibrationSideConstraint.constant == 0) ? 50 : 0
            self.view.layoutIfNeeded()
        }
        isVibrationOn = (vibrationSideConstraint.constant == 0) ? true : false
        UserDefaults.standard.set(isVibrationOn, forKey: "is_magnet_on")
        mainHeightConstraint.constant = isVibrationOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
        vibrationSensorBackView.backgroundColor = isVibrationOn ? UIColor.color1 : UIColor.red2
        vibrationSensorSwitchView.backgroundColor = isVibrationOn ? UIColor.color2 : UIColor.red1
    }
    @IBAction func saveSettingBtnPressed(_ sender: Any) {
        isSaveSettingPressed = true
        var arrayDictionary = UserDefaults.standard.array(forKey: "data") ?? []
        
        var d1: [String:Any] = [
            "name": "Pre-Set \(arrayDictionary.count)",
            "seconds" : secondsTF.text ?? "",
            "tilt_initial" : tiltInitialValueTF.text ?? "",
            "tilt_final" : tiltFinalValueTF.text ?? "",
            "magnet_initial" : magnetInitialValueTF.text ?? "",
            "magnet_final" : magnetFinalValueTF.text ?? "",
            "range_confirm" : rangeConfirmTF.text ?? "",
            "wait" : waitTF.text ?? ""
        ]
                    
        let d2 = [
                "after_notification" : notificationTF.text ?? "",
                "notification_message" : notificationMessageTF.text ?? "",
                "movement_message" : movementMessageTF.text ?? "",
                "magnet_message" : magnetMessageTF.text ?? "",
                "restart_message" : restartMessageTF.text ?? "",
                "restart_seconds" : restartSensorSeconds.text ?? ""
        ]
        d1.merge(dict: d2)
        
        arrayDictionary.append(d1)
        
        UserDefaults.standard.set(arrayDictionary, forKey: "data")
        
        isSaveSettingPressed = false
        
    }
    @IBAction func autoLockSwitchPressed(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.autoLockSideContraint.constant = (self.autoLockSideContraint.constant == 0) ? 50 : 0
            self.view.layoutIfNeeded()
        }
        isAutoLockOn = (autoLockSideContraint.constant == 0) ? true : false
        UserDefaults.standard.set(isAutoLockOn, forKey: "is_magnet_on")
        mainHeightConstraint.constant = isAutoLockOn ? mainHeightConstraint.constant+130 : mainHeightConstraint.constant-100
        autolockSensorBackView.backgroundColor = isAutoLockOn ? UIColor.color1 : UIColor.red2
        autolockSensorSwitchView.backgroundColor = isAutoLockOn ? UIColor.color2 : UIColor.red1
    }
}
extension Dictionary {
    mutating func merge(dict: [Key: Value]){
        for (k, v) in dict {
            updateValue(v, forKey: k)
        }
    }
}
