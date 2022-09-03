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
    
    //MARK: - Variables
    
    private var updateInterval = ""
    private var motionManager = CMMotionManager()
    let motionQueue = OperationQueue()
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterval = UserDefaults.standard.string(forKey: "seconds") ?? "no seconds saved"
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        motionManager.startDeviceMotionUpdates(to: motionQueue) { (data: CMDeviceMotion?, error: Error?) in
            guard let data = data else {
                print("Error: \(error!)")
                return
            }

            let motion: CMAttitude = data.attitude
            self.motionManager.deviceMotionUpdateInterval = 2.5

            DispatchQueue.main.async {
                print(motion.pitch)
                print(motion.yaw)
                print(motion.roll)
            }
        }
    }
    
    //MARK: - Private Functions
    
    private func detectMagnometerReading(){
        if motionManager.isDeviceMotionAvailable{
            motionManager.magnetometerUpdateInterval = Double(updateInterval) ?? 0.0
            motionManager.startDeviceMotionUpdates(using: .xArbitraryCorrectedZVertical, to: .main) { motion, error in
                if error == nil{
                    print(motion!)
                }else{
                    print(error!)
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
            self.lblTilt.text = String(describing: yr)
        }
    }
    
    //MARK: - IBActions
    
    @IBAction func didPressBackBtn(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func startTestBtnPressed(_ sender: Any) {
        detectTilt()
    }
}
