//
//  PresetViewController.swift
//  iSense
//
//  Created by Ehtisham Badar on 20/10/2022.
//

import UIKit

class PresetViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var selectedIndex = -1
    
    var data = [[String:Any]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "PresetTableViewCell", bundle: nil), forCellReuseIdentifier: "PresetTableViewCell")
        
        data = UserDefaults.standard.object(forKey: "data") as? [[String:Any]] ?? [[String:Any]]()
        
        selectedIndex = UserDefaults.standard.integer(forKey: "pre-selected") - 1
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension PresetViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PresetTableViewCell") as! PresetTableViewCell
        
        cell.lblTxt.text = data[indexPath.row]["name"] as? String ?? ""
        
        if selectedIndex == indexPath.row{
            cell.mainView.backgroundColor = UIColor.appYellowColor
            cell.lblTxt.textColor = UIColor.black
        }else{
            cell.mainView.backgroundColor = UIColor.clear
            cell.lblTxt.textColor = UIColor.appYellowColor
        }
                
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        self.tableView.reloadData()
        
        UserDefaults.standard.set(selectedIndex + 1, forKey: "pre-selected")
    }
}
