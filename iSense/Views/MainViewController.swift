//
//  MainViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 27/08/2022.
//

//450 -> 270
//370 -> 200
//370 -> 200


import UIKit
import CoreMotion

class MainViewController: BaseViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var sensorOnOffImage: UIImageView!
    @IBOutlet weak var lblSensor: UILabel!
    @IBOutlet weak var lblSensorDesc: UILabel!
    @IBOutlet weak var sideConstraintForSwitch: NSLayoutConstraint!
    
    //MARK: - Variables
    
    private var updateInterval = ""
    private var isSensorOn: Bool = true
    private var motionManager = CMMotionManager()
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateInterval = UserDefaults.standard.string(forKey: "seconds") ?? "no seconds saved"
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        print("Seconds Save are = \(updateInterval)")
        navigateToSettings()
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
    
    func navigateToSettings(){
        guard let seconds = UserDefaults.standard.string(forKey: "seconds") else{
            return
        }
        print(seconds)
        didPressSettings(self)
    }
    
    private func setupUI(){
        defaultScreenView()
    }
    
    private func defaultScreenView(){
//        sensorOnOffImage.image = UIImage.sensorOff
        sideConstraintForSwitch.constant = 100
        lblSensor.text = AppStrings.offSensorText
        lblSensorDesc.text = AppStrings.onSensorDesc
        lblSensor.textColor = UIColor.appRedColor
        lblSensorDesc.textColor = UIColor.appYellowColor
    }
    
//    double teslaXYZ = Math.sqrt((magnetX*magnetX)+(magnetY*magnetY)+(magnetZ*magnetZ));

    //MARK: - IBActions
    
    @IBAction func didPressSensorOnOffBtn(_ sender: Any) {
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut) {
            self.sideConstraintForSwitch.constant = (self.sideConstraintForSwitch.constant == 100) ? 0 : 100
            self.view.layoutIfNeeded()
        }
        isSensorOn = (sideConstraintForSwitch.constant == 0) ? true : false
        lblSensor.textColor = isSensorOn ? UIColor.appYellowColor : UIColor.appRedColor
        lblSensorDesc.textColor = isSensorOn ? UIColor.appRedColor : UIColor.appYellowColor
        lblSensor.text = isSensorOn ? AppStrings.onSensorText : AppStrings.offSensorText
        lblSensorDesc.text = isSensorOn ? AppStrings.offSensorDesc : AppStrings.onSensorDesc
    }
    
    @IBAction func didPressSettings(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: SettingsViewController.self)) as! SettingsViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func didPressTest(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: TestViewController.self)) as! TestViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
