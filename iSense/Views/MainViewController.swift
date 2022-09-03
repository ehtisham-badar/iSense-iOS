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
    
    @IBOutlet weak var lblSensor: UILabel!
    @IBOutlet weak var lblSensorDesc: UILabel!
    @IBOutlet weak var sideConstraintForSwitch: NSLayoutConstraint!
    @IBOutlet weak var backSensorView: UIView!
    @IBOutlet weak var switchSensor: UIView!
    
    //MARK: - Variables
    
    private var updateInterval = ""
    private var isSensorOn: Bool = true
    private var motionManager = CMMotionManager()
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
        print("Seconds Save are = \(updateInterval)")
        navigateToSettings()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateInterval = UserDefaults.standard.string(forKey: "seconds") ?? "no seconds saved"
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
        let alert = UIAlertController(title: "Wait!!!", message: "Enter Values First", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive))
        alert.addAction(UIAlertAction(title: "Go to Settings", style: .default, handler: { [weak self]alert in
            guard let `self` = self else{
                return
            }
            self.didPressSettings(self)
        }))
        
        self.present(alert, animated: true)
    }
    
//    double teslaXYZ = Math.sqrt((magnetX*magnetX)+(magnetY*magnetY)+(magnetZ*magnetZ));

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
            self.isSensorOn ? self.presentBlackScreen() : nil
        }
        isSensorOn = (sideConstraintForSwitch.constant == 0) ? true : false
        lblSensor.textColor = isSensorOn ? UIColor.appYellowColor : UIColor.appRedColor
        lblSensorDesc.textColor = isSensorOn ? UIColor.appRedColor : UIColor.appYellowColor
        lblSensor.text = isSensorOn ? AppStrings.onSensorText : AppStrings.offSensorText
        lblSensorDesc.text = isSensorOn ? AppStrings.offSensorDesc : AppStrings.onSensorDesc
        backSensorView.backgroundColor = isSensorOn ? UIColor.color1 : UIColor.red2
        switchSensor.backgroundColor = isSensorOn ? UIColor.color2 : UIColor.red1
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
