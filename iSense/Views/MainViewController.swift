//
//  MainViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 27/08/2022.
//

//450 -> 270
//370 -> 220
//370 -> 220


import UIKit
import CoreMotion

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
    var count = 0
    
    var notificationMessage = ""
    var tiltNotificationMessage = ""
    var magnetNotificationMessage = ""
    var confirmationSeconds = 0

    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        notificationMessage = UserDefaults.standard.string(forKey: "notification_message") ?? ""
        tiltNotificationMessage = UserDefaults.standard.string(forKey: "movement_message") ?? ""
        magnetNotificationMessage = UserDefaults.standard.string(forKey: "magnet_message") ?? ""

        updateInterval = UserDefaults.standard.string(forKey: "seconds") ?? "no seconds saved"
        count = Int(updateInterval) ?? 0
        tiltInitial = Int(UserDefaults.standard.string(forKey: "tilt_initial") ?? "0") ?? 0
        tiltFinal = Int(UserDefaults.standard.string(forKey: "tilt_final")  ?? "0") ?? 0
        magnetInitial = Int(UserDefaults.standard.string(forKey: "magnet_initial")  ?? "0") ?? 0
        magnetFinal = Int(UserDefaults.standard.string(forKey: "magnet_final")  ?? "0") ?? 0
        
        UNUserNotificationCenter.current().delegate = self
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
                if granted {
                    // do something
                }
            }
        
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        print("Seconds Save are = \(updateInterval)")
        navigateToSettings()
    }
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        print("Got the msg...")
        completionHandler([.badge, .sound, .alert])
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(forName: Notification.Name("stopSensor"), object: nil, queue: .main) { notification in
            UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [self] in
                    self.sideConstraintForSwitch.constant = (self.sideConstraintForSwitch.constant == 100) ? 0 : 100
                    isSensorOn = (sideConstraintForSwitch.constant == 0) ? true : false
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
                }
            }
        }
        updateInterval = UserDefaults.standard.string(forKey: "seconds") ?? "no seconds saved"
    }
    
    //MARK: - Private Functions
    
    private func detectMagnometerReading(){
        
        if motionManager.isDeviceMotionAvailable{
            motionManager.magnetometerUpdateInterval = Double(updateInterval) ?? 0.0
            
            motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical,to: .main) { [self] motion, error in
                if let motion = motion {
                    print(motion)
                    let _ = motion.magneticField.accuracy
                    let x = motion.magneticField.field.x
                    let y = motion.magneticField.field.y
                    let z = motion.magneticField.field.z
                                                            
                    let teslaXYZ = Int(round(sqrt((x*x)+(y*y)+(z*z))))
                    
                    let tiltForwardBackward = Double(acosf(Float(Double(z)/Double(teslaXYZ)))) * 180.0 / .pi - 90.0;
                    
                    if !self.tiltDetections.contains(Int(round(tiltForwardBackward))) {
                        self.tiltDetections.append(Int(round(tiltForwardBackward)))
                    }
                    if self.tiltDetections.count >= 2 {
                        let value = (self.tiltDetections[self.tiltDetections.count - 1] - self.tiltDetections[self.tiltDetections.count - 2])
                        if (value >= tiltInitial &&  value <= tiltFinal)  {
                            self.dismiss(animated: true)
                            
                            sendNotification(title: "Phone Movement detected", body: tiltNotificationMessage, secondsToShow: 1)
                            
                            motionManager.stopMagnetometerUpdates()
                            motionManager.stopDeviceMotionUpdates()
                        }
                    }
                    if !self.magnetDetections.contains(teslaXYZ){
                        self.magnetDetections.append(teslaXYZ)
                    }
                    
                    if self.magnetDetections.count >= 2 {
                        let value = (self.magnetDetections[self.magnetDetections.count - 1] - self.magnetDetections[self.magnetDetections.count - 2])
                        if (value >= magnetInitial &&  value <= magnetFinal)  {
                           //
                        }
                    }
                    
                }
                else {
                    print("Device motion is nil.")
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
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: BlackScreenViewController.self)) as! BlackScreenViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
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
        guard updateInterval != "no seconds saved" else{
            showAlert()
            return
        }
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.sideConstraintForSwitch.constant = (self.sideConstraintForSwitch.constant == 100) ? 0 : 100
            self.view.layoutIfNeeded()
        } completion: { animationDone in
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.isSensorOn ? self.presentBlackScreen() : nil
            }
        }
        isSensorOn = (sideConstraintForSwitch.constant == 0) ? true : false
        lblSensor.textColor = isSensorOn ? UIColor.appYellowColor : UIColor.appRedColor
        lblSensorDesc.textColor = isSensorOn ? UIColor.appRedColor : UIColor.appYellowColor
        lblSensor.text = isSensorOn ? AppStrings.onSensorText : AppStrings.offSensorText
        lblSensorDesc.text = isSensorOn ? AppStrings.offSensorDesc : AppStrings.onSensorDesc
        backSensorView.backgroundColor = isSensorOn ? UIColor.color1 : UIColor.red2
        switchSensor.backgroundColor = isSensorOn ? UIColor.color2 : UIColor.red1
        
        if self.isSensorOn {
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }else{
            timer.invalidate()
            
            motionManager.stopDeviceMotionUpdates()
            motionManager.stopMagnetometerUpdates()
        }
    }
    
    @objc func update() {
        if(Int(count) > 0) {
            count = count - 1
        }else{
            timer.invalidate()
            sendNotification(title: "Sensor Started", body: notificationMessage, secondsToShow: 1)
            detectMagnometerReading()
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
    
    func sendNotification(title: String,body: String, secondsToShow: Int){
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: TimeInterval(secondsToShow), repeats: false)
        let request = UNNotificationRequest.init(identifier: "FiveSecond", content: content, trigger: trigger)
        
        let center = UNUserNotificationCenter.current()
        center.add(request)
    }
}
