//
//  MainViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 27/08/2022.
//

import UIKit

class MainViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var sensorOnOffImage: UIImageView!
    @IBOutlet weak var lblSensor: UILabel!
    @IBOutlet weak var lblSensorDesc: UILabel!
    
    //MARK: - Variables
    
    private var isSensorOn: Bool = true
    
    //MARK: - Load View
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = true
        setupUI()
    }
    
    //MARK: - Private Functions
    
    private func setupUI(){
        defaultScreenView()
    }
    
    private func defaultScreenView(){
        sensorOnOffImage.image = UIImage.sensorOn
        lblSensor.text = AppStrings.onSensorText
        lblSensorDesc.text = AppStrings.offSensorDesc
        lblSensor.textColor = UIColor.appYellowColor
        lblSensorDesc.textColor = UIColor.appRedColor
    }
    
    //MARK: - IBActions
    
    @IBAction func didPressSensorOnOffBtn(_ sender: Any) {
        sensorOnOffImage.image = (sensorOnOffImage.image == UIImage.sensorOn) ? UIImage.sensorOff : UIImage.sensorOn
        isSensorOn = (sensorOnOffImage.image == UIImage.sensorOn) ? true : false
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
