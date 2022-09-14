//
//  TestViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 27/08/2022.
//

import UIKit
import CoreMotion


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
    var timerTiltDetection = Timer()
    var count = 0
    var countTiltDetection = 0
    
    var notificationMessage = ""
    var tiltNotificationMessage = ""
    var magnetNotificationMessage = ""
    var confirmationSeconds = 0
    
    var is_notification_on = false
    var is_movement_on = false
    var is_magnet_on = false
    
    var range_confirm = "0"
    var wait_between_notifications = "0"
    
    var magnetDetected = false
    var tiltDetected = false
    
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        notificationMessage = UserDefaults.standard.string(forKey: "notification_message") ?? ""
        tiltNotificationMessage = UserDefaults.standard.string(forKey: "movement_message") ?? ""
        magnetNotificationMessage = UserDefaults.standard.string(forKey: "magnet_message") ?? ""
        
        is_notification_on = UserDefaults.standard.bool(forKey: "is_notification_on")
        is_movement_on = UserDefaults.standard.bool(forKey: "is_movement_on")
        is_magnet_on = UserDefaults.standard.bool(forKey: "is_magnet_on")
        range_confirm = UserDefaults.standard.string(forKey: "range_confirm") ?? "0"
        wait_between_notifications = UserDefaults.standard.string(forKey: "wait") ?? "0"

        updateInterval = UserDefaults.standard.string(forKey: "seconds") ?? "no seconds saved"
        count = Int(updateInterval) ?? 0
        lblStartTime.text = "\(count)"
        countTiltDetection = Int(range_confirm) ?? 0
        tiltInitial = Int(UserDefaults.standard.string(forKey: "tilt_initial") ?? "0") ?? 0
        tiltFinal = Int(UserDefaults.standard.string(forKey: "tilt_final")  ?? "0") ?? 0
        magnetInitial = Int(UserDefaults.standard.string(forKey: "magnet_initial")  ?? "0") ?? 0
        magnetFinal = Int(UserDefaults.standard.string(forKey: "magnet_final")  ?? "0") ?? 0
        
        
        lblMagnetDetection.text = "\(magnetInitial)-\(magnetFinal) NOT DETECTED"
        lblTiltDetection.text = "\(tiltInitial)-\(tiltFinal) NOT DETECTED"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: - Private Functions
    
    private func detectMagnometerReading(){
        
        if motionManager.isDeviceMotionAvailable{
            motionManager.magnetometerUpdateInterval = 0.1
            motionManager.deviceMotionUpdateInterval = 0.1
                                                        
            motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical,to: .main) { [self] motion, error in
                if let motion = motion {
                    print(motion)
                    let _ = motion.magneticField.accuracy
                    let x = motion.magneticField.field.x
                    let y = motion.magneticField.field.y
                    let z = motion.magneticField.field.z
                    
                    let xm = motionManager.deviceMotion?.gravity.x ?? 0.0
                    let ym = motionManager.deviceMotion?.gravity.y ?? 0.0
                    let zm = motionManager.deviceMotion?.gravity.z ?? 0.0
                                                                                                    
                    let teslaXYZ = Int(round(sqrt((x*x)+(y*y)+(z*z))))
                    
                    let teslaXYZd = Int(round(sqrt((xm*xm)+(ym*ym)+(zm*zm))))
                    
                    self.lblMagnet.text = "\(teslaXYZ)"
                    
                    let tiltForwardBackward = Double(acosf(Float(Double(zm)/Double(teslaXYZd)))) * 180.0 / .pi - 90.0;

                    if is_movement_on {
                        
                        if !tiltForwardBackward.isNaN && !tiltForwardBackward.isInfinite {
                            
                            self.lblTilt.text = String(describing: Int(round(tiltForwardBackward)))

                            if !self.tiltDetections.contains(Int(round(tiltForwardBackward))) {
                                self.tiltDetections.append(Int(round(tiltForwardBackward)))
                            }
                        }
                        
                       checkIfPhoneDetection()
                    }
                    
                    if is_magnet_on && !magnetDetected {
                        if !self.magnetDetections.contains(teslaXYZ){
                            self.magnetDetections.append(teslaXYZ)
                        }
                        
                        if self.magnetDetections.count >= 2 {
                            let value = (self.magnetDetections[self.magnetDetections.count - 1] - self.magnetDetections[self.magnetDetections.count - 2])
                            if (value >= magnetInitial &&  value <= magnetFinal)  {
                                
                                is_magnet_on = false
                                 
                                magnetDetected = true
                                                                 
                                timerTiltDetection = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(checkForPhoneDetection), userInfo: nil, repeats: true)
                            }
                        }
                        
                    }

                    self.lblTiltAverage.text = "\(Int(self.tiltDetections.reduce(0, +) / self.tiltDetections.count))"
                    self.lblMagnetAverage.text = "\(Int(self.magnetDetections.reduce(0, +) / self.magnetDetections.count))"
                    
                    self.lblMagnetLowest.text = "\(String(describing: self.magnetDetections.min() ?? 0))"
                    self.lblTiltLowest.text = "\(String(describing: self.tiltDetections.min() ?? 0))"
                    
                    self.lblMagnetHighest.text = "\(String(describing: self.magnetDetections.max() ?? 0))"
                    self.lblTiltHighest.text = "\(String(describing: self.tiltDetections.max() ?? 0))"
                    
                    if !is_magnet_on {
                        motionManager.stopMagnetometerUpdates()
                    }
                    if !is_movement_on {
                        motionManager.stopDeviceMotionUpdates()
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
            timerTiltDetection.invalidate()
            sendNotification(title: "Magnet detected", body: magnetNotificationMessage, secondsToShow: Int(wait_between_notifications) ?? 0)
            
            lblMagnetDetection.text = "\(magnetInitial)-\(magnetFinal) DETECTED"
            magnetDetectView.backgroundColor = UIColor.greenColor
            lblMagnetDetection.textColor = UIColor.greenDetectColor
            magnetHeading.textColor = UIColor.greenDetectColor

            let time = Double(wait_between_notifications) ?? 1.0
            DispatchQueue.main.asyncAfter(deadline: .now() + time) { [self] in
                magnetDetected = false
            }
        }
    }
    
    func checkIfPhoneDetection(){
        
        if magnetDetected {
            return
        }
    
        if self.tiltDetections.count >= 2 {
            let value = (self.tiltDetections[self.tiltDetections.count - 1] - self.tiltDetections[self.tiltDetections.count - 2])
            if (value >= tiltInitial &&  value <= tiltFinal)  {
                sendNotification(title: "Phone Movement detected", body: tiltNotificationMessage, secondsToShow: Int(wait_between_notifications) ?? 0)
                motionManager.stopMagnetometerUpdates()
                motionManager.stopDeviceMotionUpdates()
                
                lblTiltDetection.text = "\(tiltInitial)-\(tiltFinal) DETECTED"
                phoneMovementView.backgroundColor = UIColor.greenColor
                lblTiltDetection.textColor = UIColor.greenDetectColor
                phoneHeading.textColor = UIColor.greenDetectColor
                
                magnetDetected = false
            }
        }
    }
    
    private func detectTilt() -> CGFloat{
        
        if let attitude = self.motionManager.deviceMotion?.attitude{
            
            let xr = CGFloat(-attitude.pitch * 2 / .pi)
            let yr = CGFloat(round(-((180 / Double.pi) * attitude.pitch) * 10)/10)
            print("Y: " + String(describing: yr))
            print("X: " + String(describing: xr))
            let angle = atan2(yr, xr) + (.pi / 2)
            let angleDegrees = angle * 180.0 / .pi
            
            return angleDegrees
        }
        
        return 0.0
    }
    
    //MARK: - IBActions
    
    @IBAction func didPressBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func startTestBtnPressed(_ sender: Any) {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
    }
    @objc func update() {
        if(Int(count) > 0) {
            count = count - 1
            lblStartTime.text = String(count)
        }else{
            timer.invalidate()
            sendNotification(title: "Sensor Started", body: notificationMessage, secondsToShow: Int(wait_between_notifications) ?? 0,startSensor: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
        
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
        
    }
    
    func sendNotification(title: String,body: String, secondsToShow: Int, startSensor: Bool = false){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(secondsToShow), repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request) { error in
            if error == nil {
                if startSensor {
                    self.detectMagnometerReading()
                }
            }
        }
    }
}
