//
//  TestViewController.swift
//  iSense
//
//  Created by Abdullah Javed on 27/08/2022.
//

import UIKit
import CoreMotion
import AudioToolbox
import CoreHaptics


class TestViewController: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var lblTilt: UILabel!
    @IBOutlet weak var lblMagnet: UILabel!
    @IBOutlet weak var lblTiltAverage: UILabel!
    @IBOutlet weak var lblTiltLowest: UILabel!
    @IBOutlet weak var lblTiltHighest: UILabel!
    @IBOutlet weak var lblMagnetAverage: UILabel!
    @IBOutlet weak var lblMagnetHighest: UILabel!
    @IBOutlet weak var lblMagnetLowest: UILabel!
    @IBOutlet weak var lblStartTime: UILabel!
    @IBOutlet weak var lblTiltDetection: UILabel!
    @IBOutlet weak var lblMagnetDetection: UILabel!
    @IBOutlet weak var phoneMovementView: UIView!
    @IBOutlet weak var magnetDetectView: UIView!
    @IBOutlet weak var phoneHeading: UILabel!
    @IBOutlet weak var magnetHeading: UILabel!
    @IBOutlet weak var startTestBtn: UIButton!
    
    @IBOutlet weak var restartSecondStackView: UIStackView!
    
    @IBOutlet weak var restartSecondStackViewBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var restartSecondStackViewTopConstraint: NSLayoutConstraint!
    
    //MARK: - Variables
    
    private var updateInterval = "2"
    private var motionManager = CMMotionManager()
    let motionQueue = OperationQueue()
    
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
    
    var magnetDetected = false
    var tiltDetected = false
    
    var is_restart_on_off = false
    
    var isVibrationOn = false
    
    var no_of_vibrations = 0
    
    @IBOutlet weak var lblRestartTimer: UILabel!
    
    private var engine: CHHapticEngine?
    
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reinitializeAll()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        reinitializeAll()
        
//        prepareHaptic()
    }
    
    func reinitializeAll(){
        
        
        magnetDetections.removeAll()
        tiltDetections.removeAll()
        
        let arrayDictionary = UserDefaults.standard.array(forKey: "data") ?? []
        
        let pre_selected = UserDefaults.standard.integer(forKey: "pre-selected")
        
        let dict = arrayDictionary[pre_selected] as! [String:Any]
        
        notificationMessage = dict["notification_message"] as? String ?? ""
        tiltNotificationMessage = dict["movement_message"] as? String ?? ""
        magnetNotificationMessage = dict["magnet_message"] as? String ?? ""
        restartNotificationMessage = dict["restart_message"] as? String ?? ""
        
        is_restart_notify_on = dict["is_restart_on_notification"] as! Bool
        
        is_restart_on_off = dict["is_restart_on"] as! Bool
        
        let seconds = dict["restart_seconds"] as? String ?? "0"
        restart_seconds = Int(seconds) ?? 0
        
        countRestart = restart_seconds
        
        is_notification_on = dict["is_notification_on"] as! Bool
        is_movement_on =  dict["is_movement_on"] as! Bool
        is_magnet_on = dict["is_magnet_on"] as! Bool
        range_confirm = dict["range_confirm"] as? String ?? "0"
        wait_between_notifications = dict["wait"] as? String ?? "0"

        updateInterval = dict["seconds"] as? String ?? "no seconds saved"
        count = Int(updateInterval) ?? 0
        lblStartTime.text = "\(count)"
        countTiltDetection = Int(range_confirm) ?? 0
        tiltInitial = Int(dict["tilt_initial"] as? String ?? "0") ?? 0
        tiltFinal = Int(dict["tilt_final"] as? String  ?? "0") ?? 0
        magnetInitial = Int(dict["magnet_initial"] as? String ?? "0") ?? 0
        magnetFinal = Int(dict["magnet_final"] as? String  ?? "0") ?? 0
        
        isVibrationOn = dict["is_vibration_on"] as? Bool ?? false
        no_of_vibrations = Int(dict["no_of_vibrations"] as? String ?? "0") ?? 0
        
        if (Int(restart_seconds) == 0 || !is_restart_on_off){
            restartSecondStackView.isHidden = true
            restartSecondStackViewTopConstraint.constant = 10
            restartSecondStackViewBottomConstraint.constant = 10
        }
        
        lblRestartTimer.text = String(countRestart)
        
        
        lblMagnetDetection.text = "\(magnetInitial)-\(magnetFinal) NOT DETECTED"
        lblTiltDetection.text = "\(tiltInitial)-\(tiltFinal) NOT DETECTED"
        
        self.magnetDetectView.backgroundColor =  UIColor.noDetectRedColor
        self.lblMagnetDetection.textColor = UIColor.noDetectTextColor
        self.magnetHeading.textColor =  UIColor.noDetectTextColor

        self.phoneMovementView.backgroundColor =  UIColor.noDetectRedColor
        self.lblTiltDetection.textColor =  UIColor.noDetectTextColor
        self.phoneHeading.textColor =  UIColor.noDetectTextColor
        
        if !is_magnet_on {
            magnetDetectView.backgroundColor = UIColor.disabledColor
            lblMagnetDetection.textColor = UIColor.hexStringToUIColor(hex: "7c7c7c")
            magnetHeading.textColor = UIColor.hexStringToUIColor(hex: "7c7c7c")
        }
        
        if !is_movement_on {
            phoneMovementView.backgroundColor = UIColor.disabledColor
            lblTiltDetection.textColor = UIColor.hexStringToUIColor(hex: "7c7c7c")
            phoneHeading.textColor = UIColor.hexStringToUIColor(hex: "7c7c7c")
        }
        
        self.lblMagnet.text = "0"
        self.lblTilt.text = "0"
        
        self.lblMagnetAverage.text = "0"
        self.lblMagnetHighest.text = "0"
        self.lblMagnetLowest.text = "0"
        
        self.lblTiltAverage.text = "0"
        self.lblTiltHighest.text = "0"
        self.lblTiltLowest.text = "0"
        
        magnetDetected = false
        tiltDetected = false
    }
    
    //MARK: - Private Functions
    
    private func detectMagnometerReading(){
        
        if motionManager.isDeviceMotionAvailable{
            DispatchQueue.main.async {
                self.startTestBtn.setTitle("CANCEL", for: .normal)
                self.startTestBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#C6AC63"), for: .normal)
                self.startTestBtn.isEnabled = true
            }

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
                    
                    
                    let tiltForwardBackward = Double(acosf(Float(Double(zm)/Double(teslaXYZd)))) * 180.0 / .pi - 90.0;

                    if is_movement_on {
                        
                        if !tiltForwardBackward.isNaN && !tiltForwardBackward.isInfinite {
                            
                            self.lblTilt.text = String(describing: Int(round(tiltForwardBackward)))

                            if !self.tiltDetections.contains(Int(round(tiltForwardBackward))) {
                                self.tiltDetections.append(Int(round(tiltForwardBackward)))
                            }
                        }
                        
                        checkIfPhoneDetection()
                        
                        if(self.tiltDetections.count > 0){
                            self.lblTiltAverage.text = "\(Int(self.tiltDetections.reduce(0, +) / self.tiltDetections.count))"
                        }
                        
                        self.lblTiltLowest.text = "\(String(describing: self.tiltDetections.min() ?? 0))"
                        
                        self.lblTiltHighest.text = "\(String(describing: self.tiltDetections.max() ?? 0))"
                    }
                    
                    if is_magnet_on && !magnetDetected {
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
                                
                                if (is_movement_on){
                                    is_magnet_on = false
                                     
                                    magnetDetected = true
                                    
                                    tiltDetected = false
                                                                     
                                    timerTiltDetection = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForPhoneDetection), userInfo: nil, repeats: true)
                                }else{
                                    sendNotification(title: magnetNotificationMessage, body: "Magnet detected", secondsToShow: Int(wait_between_notifications) ?? 0, category: "magnet")
                                    
                                    lblMagnetDetection.text = "\(magnetInitial)-\(magnetFinal) DETECTED"
                                    magnetDetectView.backgroundColor = UIColor.greenColor
                                    lblMagnetDetection.textColor = UIColor.greenDetectColor
                                    magnetHeading.textColor = UIColor.greenDetectColor

                                    
                                    motionManager.stopMagnetometerUpdates()
                                    motionManager.stopDeviceMotionUpdates()
                                    
                                    startTestBtn.setTitle("RESTART", for: .normal)
                                    startTestBtn.isEnabled = true
                                    
                                    if (is_restart_on_off) {
                                        restartTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestart), userInfo: nil, repeats: true)
                                    }
                                }
                            }
                        }
                        
                        if(self.magnetDetections.count > 0){
                            self.lblMagnetAverage.text = "\(Int(self.magnetDetections.reduce(0, +) / self.magnetDetections.count))"
                        }
                        
                        self.lblMagnetHighest.text = "\(String(describing: self.magnetDetections.max() ?? 0))"
                        self.lblMagnetLowest.text = "\(String(describing: self.magnetDetections.min() ?? 0))"
                        
                        self.lblMagnet.text = "\(teslaXYZ)"
                    }
                    
                }
                else {
                    print("Device motion is nil.")
                }
            }
        }
    }
    
    @objc func checkForPhoneDetection(){
        if(Int(countTiltDetection) > 0) {
            countTiltDetection = countTiltDetection - 1
        }else{
            if(!tiltDetected){
                timerTiltDetection.invalidate()
                sendNotification(title: magnetNotificationMessage, body: "Magnet detected", secondsToShow: Int(wait_between_notifications) ?? 0, category: "magnet")
                
                lblMagnetDetection.text = "\(magnetInitial)-\(magnetFinal) DETECTED"
                magnetDetectView.backgroundColor = UIColor.greenColor
                lblMagnetDetection.textColor = UIColor.greenDetectColor
                magnetHeading.textColor = UIColor.greenDetectColor

                let time = Double(wait_between_notifications) ?? 1.0
                tiltDetected = true
                DispatchQueue.main.asyncAfter(deadline: .now() + time) { [self] in
                    tiltDetected = false
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
                sendNotification(title: tiltNotificationMessage, body: "Phone Movement detected", secondsToShow: Int(wait_between_notifications) ?? 0, category: "movement")
                motionManager.stopMagnetometerUpdates()
                motionManager.stopDeviceMotionUpdates()
                
                lblTiltDetection.text = "\(tiltInitial)-\(tiltFinal) DETECTED"
                phoneMovementView.backgroundColor = UIColor.greenColor
                lblTiltDetection.textColor = UIColor.greenDetectColor
                phoneHeading.textColor = UIColor.greenDetectColor
                
                startTestBtn.setTitle("RESTART", for: .normal)
                startTestBtn.isEnabled = true
                
                tiltDetected = true
                                
                if (is_restart_on_off) {
                    restartTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestart), userInfo: nil, repeats: true)
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
    
    
    func cancelBtnOption(){
        startTestBtn.setTitle("START TEST", for: .normal)
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
        startTestBtn.setTitle("START TEST", for: .normal)
        startTestBtn.isEnabled = true
    }
    
    func startBtnOption(){
        count = Int(updateInterval) ?? 0
        timer.invalidate()
        startTestBtn.isEnabled = false
        reinitializeAll()
        
        startTestBtn.setTitle("START TEST", for: .normal)
        startTestBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#C6AC63",alpha: 0.2), for: .normal)
    }
    
    //MARK: - IBActions
    
    @IBAction func didPressBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func startTestBtnPressed(_ sender: Any) {
        
        count = Int(updateInterval) ?? 0
        timer.invalidate()
        startTestBtn.isEnabled = false
        reinitializeAll()
        
        if startTestBtn.title(for: .normal) ?? "" == "CANCEL" {
            cancelBtnOption()
        }else {
            motionManager.stopMagnetometerUpdates()
            motionManager.stopDeviceMotionUpdates()
            
//            if(is_restart_on_off){
//                if(startTestBtn.title(for: .normal) == "RESTART"){
//                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateRestart), userInfo: nil, repeats: true)
//                }else{
//                    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
//                }
//            }else{
//                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
//            }
            
            if(startTestBtn.title(for: .normal) == "RESTART"){
                restartTimer.invalidate()
                lblRestartTimer.text = String(countRestart)
            }else{
                startTestBtn.setTitle("START TEST", for: .normal)
                startTestBtn.setTitleColor(UIColor.hexStringToUIColor(hex: "#C6AC63",alpha: 0.2), for: .normal)
            }
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
    }
    @objc func update() {
        if(Int(count) > 0) {
            count = count - 1
            lblStartTime.text = String(count)
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
            lblRestartTimer.text = String(countRestart)
        }else{
            reinitializeAll()
            countRestart = restart_seconds
            restartTimer.invalidate()
            if(is_restart_notify_on) {
                sendNotification(title: restartNotificationMessage, body: "Sensor Restarted", secondsToShow: 1, category: "sensor",startSensor: true)
            }else{
                self.detectMagnometerReading()
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
        restartTimer.invalidate()
        
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
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
