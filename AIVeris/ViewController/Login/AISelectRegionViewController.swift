//
//  AISelectRegionViewController.swift
//  AIVeris
//
//  Created by 刘先 on 16/5/28.
//  Copyright © 2016年 ___ASIAINFO___. All rights reserved.
//

import UIKit

class AISelectRegionViewController: UIViewController, UITableViewDelegate,UITableViewDataSource {

    var delegate : AISelectRegionViewControllerDelegate?
    var model : [RegionModel]?
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupViews()
        loadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews(){
        tableView.delegate = self
        tableView.dataSource = self
        
        self.navigationItem.title = "Select Country"
    }
    
    func loadData(){
        let model = [RegionModel(countryNumber: "+86", regionName: "China"),RegionModel(countryNumber: "+33", regionName: "France"),
                     RegionModel(countryNumber: "+49", regionName: "Germany"),
                     RegionModel(countryNumber: "+61", regionName: "Australia"),
                     RegionModel(countryNumber: "+36", regionName: "Hungary"),
                     RegionModel(countryNumber: "+81", regionName: "Japan")]
        self.model = model
    }
    
    //MARK: - tableViewDelegate
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let model = model{
            return model.count
        }
        return 0
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("RegionSelectTableViewCell", forIndexPath: indexPath) as UITableViewCell
        //TODO: 后续根据UI修改
        let regionModel = model![indexPath.row]
        cell.textLabel?.text = regionModel.countryNumber
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.detailTextLabel?.text = regionModel.regionName
        cell.detailTextLabel?.textColor = UIColor.whiteColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if let cell = tableView.cellForRowAtIndexPath(indexPath){
            if let delegate = delegate{
                delegate.didSelectRegion(cell.detailTextLabel!.text!, countryNumber: cell.textLabel!.text!)
            }
            self.navigationController?.popViewControllerAnimated(true)
        }
    }
    
}

protocol AISelectRegionViewControllerDelegate {
    
    func didSelectRegion(regionName : String, countryNumber : String)
}

struct RegionModel {
    var countryNumber : String
    var regionName : String
    
    init(countryNumber : String, regionName : String){
        self.countryNumber = countryNumber
        self.regionName = regionName
    }
}
