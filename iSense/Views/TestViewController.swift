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
    var count = 0
    
    
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterval = UserDefaults.standard.string(forKey: "seconds") ?? "no seconds saved"
        count = Int(updateInterval) ?? 0
        lblStartTime.text = "\(count)"
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
                    
                    self.lblTilt.text = String(describing: Int(round(tiltForwardBackward)))
                    self.lblMagnet.text = "\(teslaXYZ)"
                    
                    if !self.tiltDetections.contains(Int(round(tiltForwardBackward))) {
                        self.tiltDetections.append(Int(round(tiltForwardBackward)))
                    }
                    if self.tiltDetections.count >= 2 {
                        let value = (self.tiltDetections[self.tiltDetections.count - 1] - self.tiltDetections[self.tiltDetections.count - 2])
                        if (value >= tiltInitial &&  value <= tiltFinal)  {
                            lblTiltDetection.text = "\(tiltInitial)-\(tiltFinal) DETECTED"
                            phoneMovementView.backgroundColor = UIColor.greenColor
                        }
                    }
                    if !self.magnetDetections.contains(teslaXYZ){
                        self.magnetDetections.append(teslaXYZ)
                    }
                    
                    if self.magnetDetections.count >= 2 {
                        let value = (self.magnetDetections[self.magnetDetections.count - 1] - self.magnetDetections[self.magnetDetections.count - 2])
                        if (value >= magnetInitial &&  value <= magnetFinal)  {
                            lblMagnetDetection.text = "\(magnetInitial)-\(magnetFinal) DETECTED"
                            magnetDetectView.backgroundColor = UIColor.greenColor
                        }
                    }
                    
                    self.lblTiltAverage.text = "\(Int(self.tiltDetections.reduce(0, +) / self.tiltDetections.count))"
                    self.lblMagnetAverage.text = "\(Int(self.magnetDetections.reduce(0, +) / self.magnetDetections.count))"
                    
                    self.lblMagnetLowest.text = "\(String(describing: self.magnetDetections.min() ?? 0))"
                    self.lblTiltLowest.text = "\(String(describing: self.tiltDetections.min() ?? 0))"
                    
                    self.lblMagnetHighest.text = "\(String(describing: self.magnetDetections.max() ?? 0))"
                    self.lblTiltHighest.text = "\(String(describing: self.tiltDetections.max() ?? 0))"
                    
                }
                else {
                    print("Device motion is nil.")
                }
            }
        }
    }
    
    private func detectTilt(){
        if let attitude = self.motionManager.deviceMotion?.attitude{
            let xr = CGFloat(-attitude.pitch * 2 / .pi)
            let yr = CGFloat(round(-((180 / Double.pi) * attitude.pitch) * 10)/10)
            print("Y: " + String(describing: yr))
            print("X: " + String(describing: xr))
            let angle = atan2(yr, xr) + (.pi / 2)
            let angleDegrees = angle * 180.0 / .pi;
            self.lblTilt.text = String(describing: Int(round(angleDegrees)))
        }
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
            detectMagnometerReading()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        timer.invalidate()
        
        motionManager.stopMagnetometerUpdates()
        motionManager.stopDeviceMotionUpdates()
        
    }
}
