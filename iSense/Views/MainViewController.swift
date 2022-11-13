//
//  MainViewController.swift
//  iSense
//
//  Created by Abdullah Javed on 27/08/2022.
//

//450 -> 270
//370 -> 220
//370 -> 220


import UIKit
import CoreMotion
import AudioToolbox

class MainViewController: BaseViewController, UNUserNotificationCenterDelegate {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lblSensor: UILabel!
    @IBOutlet weak var lblSensorDesc: UILabel!
    @IBOutlet weak var sideConstraintForSwitch: NSLayoutConstraint!
    @IBOutlet weak var backSensorView: UIView!
    @IBOutlet weak var switchSensor: UIView!
    
    //MARK: - Variables
    
    private var updateInterval = ""
    private var isSensorOn: Bool = true
    private var motionManager = CMMotionManager()
    
    var tiltDetections = [Int]()
    var magnetDetections = [Int]()
    var magnetInitial = 0
    var magnetFinal = 0
    var tiltInitial = 0
    var tiltFinal = 0
    var timer = Timer()
    var restartTimer = Timer()
    var timerTiltDetection = Timer()
    var count = 0
    var countRestart = 0
    var countTiltDetection = 0
    
    var notificationMessage = ""
    var tiltNotificationMessage = ""
    var magnetNotificationMessage = ""
    var restartNotificationMessage = ""
    var confirmationSeconds = 0
    var restart_seconds = 0
    
    var is_notification_on = false
    var is_movement_on = false
    var is_magnet_on = false
    var is_restart_notify_on = false
    
    var range_confirm = "0"
    var wait_between_notifications = "0"
        
    override var prefersHomeIndicatorAutoHidden: Bool { return true }
    
    var magnetDetected = false
    var tiltDetected = false
    
    var is_restart_on_off = false
    
    var isSensorCanBeClicked = true
    
    var isVibrationOn = false
    
    var no_of_vibrations = 0
    

    //MARK: - Load View
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setNeedsUpdateOfHomeIndicatorAutoHidden()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reinitializeAll()
        
        setupUI()
        print("Seconds Save are = \(updateInterval)")
        navigateToSettings()
    }
    
    func reinitializeAll(){
        
        magnetDetections.removeAll()
        tiltDetections.removeAll()
        
        let arrayDictionary = UserDefaults.standard.array(forKey: "data") ?? []
        
        let pre_selected = UserDefaults.standard.integer(forKey: "pre-selected")
        
        let dict = arrayDictionary[pre_selected] as! [String:Any]
        
        notificationMessage = dict["notification_message"] as! String
        tiltNotificationMessage = dict["movement_message"] as! String
        magnetNotificationMessage = dict["magnet_message"] as! String
        
        restartNotificationMessage = dict["restart_message"] as! String
        
        is_restart_notify_on = dict["is_restart_on_notification"] as! Bool
    
        is_restart_on_off = dict["is_restart_on"] as! Bool
        
        let seconds = dict["restart_seconds"] as! String
        restart_seconds = Int(seconds) ?? 0
        
        countRestart = restart_seconds
        
        is_notification_on = dict["is_notification_on"] as! Bool
        is_movement_on = dict["is_movement_on"] as! Bool
        is_magnet_on = dict["is_magnet_on"] as! Bool
        range_confirm = dict["range_confirm"] as! String
        wait_between_notifications = dict["wait"] as! String

        updateInterval = dict["seconds"] as? String ?? "no seconds saved"
        count = Int(updateInterval) ?? 0
        countTiltDetection = Int(range_confirm) ?? 0
        tiltInitial = Int(dict["tilt_initial"] as? String ?? "0") ?? 0
        tiltFinal = Int(dict["tilt_final"] as? String ?? "0") ?? 0
        magnetInitial = Int(dict["magnet_initial"] as? String ?? "0") ?? 0
        magnetFinal = Int(dict["magnet_final"] as? String  ?? "0") ?? 0
        
        magnetDetected = false
        tiltDetected = false
        
        isVibrationOn = dict["is_vibration_on"] as? Bool ?? false
        no_of_vibrations = Int(dict["no_of_vibrations"] as? String ?? "0") ?? 0
        
        self.navigationController?.isNavigationBarHidden = true
    }
    

  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name("stopSensor"), object: nil, queue: .main) { notification in
            self.stopSensor()
            
            self.restartTimer.invalidate()
            self.timer.invalidate()
        }
        
        tiltDetections.removeAll()
        magnetDetections.removeAll()
        
        reinitializeAll()
        
        //stopSensor()
    }
    
    func stopSensor(){
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                self.sideConstraintForSwitch.constant = 100
                isSensorOn = false
                lblSensor.textColor = isSensorOn ? UIColor.appYellowColor : UIColor.appRedColor
                lblSensorDesc.textColor = isSensorOn ? UIColor.appRedColor : UIColor.appYellowColor
                lblSensor.text = isSensorOn ? AppStrings.onSensorText : AppStrings.offSensorText
                lblSensorDesc.text = isSensorOn ? AppStrings.offSensorDesc : AppStrings.onSensorDesc
                backSensorView.backgroundColor = isSensorOn ? UIColor.color1 : UIColor.red2
                switchSensor.backgroundColor = isSensorOn ? UIColor.color2 : UIColor.red1
                self.view.layoutIfNeeded()
                
                timer.invalidate()
                
                motionManager.stopDeviceMotionUpdates()
                motionManager.stopMagnetometerUpdates()
                
                reinitializeAll()
            }
        }
    }
    
    //MARK: - Private Functions
    
    private func detectMagnometerReading(){
        
        if motionManager.isDeviceMotionAvailable{
            motionManager.magnetometerUpdateInterval = 0.1
            motionManager.deviceMotionUpdateInterval = 0.1

            motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical,to: .main) { [self] motion, error in
                if let motion = motion {
//                    print(motion)
                    let _ = motion.magneticField.accuracy
                    let x = motion.magneticField.field.x
                    let y = motion.magneticField.field.y
                    let z = motion.magneticField.field.z
                    
                    let xm = motionManager.deviceMotion?.gravity.x ?? 0.0
                    let ym = motionManager.deviceMotion?.gravity.y ?? 0.0
                    let zm = motionManager.deviceMotion?.gravity.z ?? 0.0
                                                            
                    let teslaXYZ = Int(round(sqrt((x*x)+(y*y)+(z*z))))
                    
                    let teslaXYZd = Int(round(sqrt((xm*xm)+(ym*ym)+(zm*zm))))
                    
                    if(is_movement_on){
                        let tiltForwardBackward = Double(acosf(Float(Double(zm)/Double(teslaXYZd)))) * 180.0 / .pi - 90.0;
                        if !tiltForwardBackward.isNaN && !tiltForwardBackward.isInfinite {
                            if !self.tiltDetections.contains(Int(round(tiltForwardBackward))) {
                                self.tiltDetections.append(Int(round(tiltForwardBackward)))
                            }
                        }
                        
                        checkIfPhoneDetection()
                    }
                    
                    if(is_magnet_on && !magnetDetected){
                        
                        if !self.magnetDetections.contains(teslaXYZ){
                            self.magnetDetections.append(teslaXYZ)
                        }
                        
                        if self.magnetDetections.count >= 2 {
                            let average = Int(self.magnetDetections.reduce(0, +) / self.magnetDetections.count)
                            let highest = self.magnetDetections.max() ?? 0
                            let lowest =  self.magnetDetections.min() ?? 0
                            let value1 = average > highest ? average - highest : average > lowest ? average - lowest : 0
                            let value2 = average < highest ? highest - average : average < lowest ? lowest - average : 0
                            
                            if ((value1 >= magnetInitial &&  value1 <= magnetFinal) || (value2 >= magnetInitial &&  value2 <= magnetFinal))  {
                                
                                if is_movement_on {
                                    is_magnet_on = false
                                      
                                    magnetDetected = true
                                     
                                    tiltDetected = false
                                                                                                     
                                    timerTiltDetection = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForPhoneDetection), userInfo: nil, repeats: true)
                                }else {
                                    sendNotification(title: magnetNotificationMessage, body: "Magnet detected", secondsToShow: Int(wait_between_notifications) ?? 0, category: "magnet")
                                    
                                    motionManager.stopMagnetometerUpdates()
                                    motionManager.stopDeviceMotionUpdates()
                                    
                                    stopSensor()
                                    
                                    if is_restart_on_off {
                                        sensorOnOffMethod(showBlackScreen: false)
                                    }
                                }
                            }
                        }
                    }
                }
                else {
                    print("Device motion is nil.")
                }
            }
        }
    }

    
    func checkIfPhoneDetection(){
        
        if tiltDetected {
            return
        }
    
        if self.tiltDetections.count >= 2 {
            let average = Int(self.tiltDetections.reduce(0, +) / self.tiltDetections.count)
            let highest = self.tiltDetections.max() ?? 0
            let lowest =  self.tiltDetections.min() ?? 0
            let value1 = average > highest ? average - highest : average > lowest ? average - lowest : 0
            let value2 = average < highest ? highest - average : average < lowest ? lowest - average : 0
            if ((value1 >= tiltInitial &&  value1 <= tiltFinal) || (value2 >= tiltInitial &&  value2 <= tiltFinal))  {
                sendNotification(title: tiltNotificationMessage, body: "Phone Movement detected", secondsToShow: 1, category: "movement")
                motionManager.stopMagnetometerUpdates()
                motionManager.stopDeviceMotionUpdates()
                                
                tiltDetected = true
                
                stopSensor()
                
                if is_restart_on_off {
                    sensorOnOffMethod(showBlackScreen: false)
                }

            }
        }
    }
    
    private func detectTilt() -> CGFloat{
        if let attitude = self.motionManager.deviceMotion?.attitude{
            let xr = CGFloat(-attitude.pitch * 2 / .pi)
            let yr = CGFloat(round(-((180 / Double.pi) * attitude.pitch) * 10)/10)
//            print("Y: " + String(describing: yr))
//            print("X: " + String(describing: xr))
            let angle = atan2(yr, xr) + (.pi / 2)
            let angleDegrees = angle * 180.0 / .pi
            
            return angleDegrees
        }
        
        return 0.0
    }
    
    @objc func checkForPhoneDetection(){
        if(Int(countTiltDetection) > 0) {
            countTiltDetection = countTiltDetection - 1
        }else{
            if(!tiltDetected){
                countTiltDetection = Int(range_confirm) ?? 0
                timerTiltDetection.invalidate()
                sendNotification(title: magnetNotificationMessage, body: "Magnet detected", secondsToShow: 1, category: "magnet")
                
                let time = Double(wait_between_notifications) ?? 1.0
                tiltDetected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + time) { [self] in
                    tiltDetected = false
                }
            }
        }
    }
    
    func navigateToSettings(){
        if UserDefaults.standard.string(forKey: "seconds") == "no seconds saved"{
            didPressSettings(self)
        } else{
            return
        }
        
    }
    
    private func setupUI(){
        defaultScreenView()
    }
    
    private func defaultScreenView(){
        sideConstraintForSwitch.constant = 100
        lblSensor.text = AppStrings.offSensorText
        lblSensorDesc.text = AppStrings.onSensorDesc
        lblSensor.textColor = UIColor.appRedColor
        lblSensorDesc.textColor = UIColor.appYellowColor
    }
    func presentBlackScreen(){
//        self.sideConstraintForSwitch.constant = 0
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: BlackScreenViewController.self)) as! BlackScreenViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .fullScreen
        self.present(vc, animated: true)
    }
    func showAlert(){
        let alert = UIAlertController(title: "Wait", message: "Enter Values First", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { [weak self]alert in
            guard let `self` = self else{
                return
            }
            self.didPressSettings(self)
        }))
        
        self.present(alert, animated: true)
    }
    
    //MARK: - IBActions
    
    @IBAction func didPressSensorOnOffBtn(_ sender: Any) {
        sensorOnOffMethod(showBlackScreen: true)
    }
    
    @IBAction func didPressVideosButton(_ sender: Any) {
        guard let url = URL(string: "https://www.youtube.com/channel/UCNq9yUZg1DFDQS6sI4jGH5A/featured") else {
          return //be safe
        }

        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
    
    func sensorOnOffMethod(showBlackScreen: Bool = true){
        
        if(isSensorCanBeClicked){
            isSensorCanBeClicked = false
            guard updateInterval != "no seconds saved" else{
                showAlert()
                return
            }
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
                self.sideConstraintForSwitch.constant = (self.sideConstraintForSwitch.constant == 100) ? 0 : 100
                self.view.layoutIfNeeded()
            } completion: { animationDone in
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    if self.isSensorOn && showBlackScreen{
                        self.presentBlackScreen()
                    }
                }
                
                self.isSensorCanBeClicked = true
            }
            
            isSensorOn = (sideConstraintForSwitch.constant == 0) ? true : false
            lblSensor.textColor = isSensorOn ? UIColor.appYellowColor : UIColor.appRedColor
            lblSensorDesc.textColor = isSensorOn ? UIColor.appRedColor : UIColor.appYellowColor
            lblSensor.text = isSensorOn ? AppStrings.onSensorText : AppStrings.offSensorText
            lblSensorDesc.text = isSensorOn ? AppStrings.offSensorDesc : AppStrings.onSensorDesc
            backSensorView.backgroundColor = isSensorOn ? UIColor.color1 : UIColor.red2
            switchSensor.backgroundColor = isSensorOn ? UIColor.color2 : UIColor.red1
            
            
            if(showBlackScreen){
                if self.isSensorOn {
                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
                }else{
                    timer.invalidate()
                    restartTimer.invalidate()
                            
                    motionManager.stopDeviceMotionUpdates()
                    motionManager.stopMagnetometerUpdates()
                }
            }else{
                restartTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestart), userInfo: nil, repeats: true)
            }
        }
    }
    
    @objc func update() {
        if(Int(count) > 0) {
            count = count - 1
        }else{
            count = Int(updateInterval) ?? 0
            timer.invalidate()
            if(is_notification_on) {
                sendNotification(title: notificationMessage, body: "Sensor Started", secondsToShow: 1, category: "sensor",startSensor: true)
            }else{
                self.detectMagnometerReading()
            }
        }
    }
    
    @objc func updateRestart() {
        if(Int(countRestart) > 0) {
            countRestart = countRestart - 1
        }else{
            countRestart = restart_seconds
            restartTimer.invalidate()
            if(is_restart_notify_on) {
                sendNotification(title: restartNotificationMessage, body: "Sensor Restarted", secondsToShow: 1, category: "sensor",startSensor: true)
            }else{
                self.detectMagnometerReading()
            }
        }
    }
    
    
    @IBAction func didPressSettings(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: SettingsViewController.self)) as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didPressTest(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: TestViewController.self)) as! TestViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func sendNotification(title: String,body: String, secondsToShow: Int,category: String, startSensor: Bool = false){
        
        if(isVibrationOn) {
            vibrate(count: no_of_vibrations,startSensor: startSensor)
            return
        }
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        content.categoryIdentifier = category
        if #available(iOS 15.0, *) {
            content.interruptionLevel = .critical
        } else {
            // Fallback on earlier versions
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(secondsToShow), repeats: false)
        let request = UNNotificationRequest.init(identifier: UUID().uuidString, content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if error == nil {
                if startSensor {
                    self.detectMagnometerReading()
                }
            }
        }
    }
    
    func vibrate(count: Int,startSensor: Bool) {
           if count == 0 {
               if(startSensor){
                   self.detectMagnometerReading()
               }
               return
           }
           AudioServicesPlaySystemSoundWithCompletion(kSystemSoundID_Vibrate) { [weak self] in
               self?.vibrate(count: count - 1,startSensor: startSensor)
           }
       }
}
