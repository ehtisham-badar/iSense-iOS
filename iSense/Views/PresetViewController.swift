//
//  PresetViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 20/10/2022.
//

import UIKit

class PresetViewController: UIViewController,RemoveEditDelegate {
    
    @IBOutlet weak var editPresetView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = -1
    
    var data = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PresetTableViewCell", bundle: nil), forCellReuseIdentifier: "PresetTableViewCell")
        
        data = UserDefaults.standard.object(forKey: "data") as? [[String:Any]] ?? [[String:Any]]()
        
        selectedIndex = UserDefaults.standard.integer(forKey: "pre-selected")
                
        if(selectedIndex <= 0){
            editPresetView.isHidden = true
        }
        
        tableView.separatorStyle = .none
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func editPresetSelected(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: String(describing: RenamePopupViewController.self)) as! RenamePopupViewController
        vc.modalTransitionStyle = .crossDissolve
        vc.modalPresentationStyle = .overCurrentContext
        vc.isFromRename = false
        vc.index = selectedIndex
        vc.delegate = self
        self.present(vc, animated: true)
    }
    
    func updateDone(name: String?) {
        
        data = UserDefaults.standard.object(forKey: "data") as? [[String:Any]] ?? [[String:Any]]()
        tableView.reloadData()
    }
    
}

extension PresetViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if data.count == 1 {
              tableView.setMessage("No Pre-Sets Found")
              editPresetView.isHidden = true
        } else if data.count > 1 {
              tableView.clearBackground()
        }
        
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresetTableViewCell") as! PresetTableViewCell
        
        if(indexPath.row != 0){
            
            cell.lblTxt.text = data[indexPath.row]["name"] as? String ?? ""
            
            if selectedIndex == indexPath.row{
                cell.mainView.backgroundColor = UIColor.appYellowColor
                cell.lblTxt.textColor = UIColor.black
            }else{
                cell.mainView.backgroundColor = UIColor.clear
                cell.lblTxt.textColor = UIColor.appYellowColor
            }
            
            cell.mainView.isHidden = false
            cell.lblTxt.isHidden = false
        }else{
            cell.mainView.isHidden = true
            cell.lblTxt.isHidden = true
        }
        
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if(indexPath.row == 0){
            return 0
        }
        
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tableView.reloadData()
        UserDefaults.standard.set(selectedIndex, forKey: "pre-selected")
        
        editPresetView.isHidden = false
    }
}

extension UITableView {

    func setMessage(_ message: String) {
        let lblMessage = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        lblMessage.text = message
        lblMessage.textColor = UIColor.appYellowColor
        lblMessage.numberOfLines = 0
        lblMessage.textAlignment = .center
        lblMessage.font = UIFont(name: "Helvetica", size: 20)
        lblMessage.sizeToFit()

        self.backgroundView = lblMessage
        self.separatorStyle = .none
    }

    func clearBackground() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}
