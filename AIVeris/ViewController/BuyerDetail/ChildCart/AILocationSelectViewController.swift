//
//  AILocationSelectViewController.swift
//  AIVeris
//
// Copyright (c) 2016 ___ASIAINFO___
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

import Foundation


class MICountry: NSObject {
    let name: String
    let code: String
    var section: Int?
    
    init(name: String, code: String) {
        self.name = name
        self.code = code
    }
}

struct Section {
    var countries: [MICountry] = []
    
    mutating func addCountry(country: MICountry) {
        countries.append(country)
    }
}

protocol AILocationSelectDelegate: class {
    func countryPicker(picker: AILocationSelectViewController, didSelectCountryWithName name: String, code: String)
}

public class AILocationSelectViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    public var customCountriesCode: [String]?
    private var filteredList = [MICountry]()
    private var unsourtedCountries : [MICountry] {
//        let locale = NSLocale.currentLocale()
        var unsourtedCountries = [MICountry]()
        let countriesCodes = customCountriesCode ?? [""]
        
        for countryCode in countriesCodes {
            let displayName = countryCode
            let country = MICountry(name: displayName, code: countryCode)
            unsourtedCountries.append(country)
        }
        
        return unsourtedCountries
    }
    
    private var _sections: [Section]?
    private var sections: [Section] {
        
        if _sections != nil {
            return _sections!
        }
        
        let countries: [MICountry] = unsourtedCountries.map { country in
            let country = MICountry(name: country.name, code: country.code)
            country.section = collation.sectionForObject(country, collationStringSelector: Selector("name"))
            return country
        }
        
        // create empty sections
        var sections = [Section]()
        for _ in 0..<self.collation.sectionIndexTitles.count {
            sections.append(Section())
        }
        
        // put each country in a section
        for country in countries {
            sections[country.section!].addCountry(country)
        }
        
        // sort each section
        for section in sections {
            var s = section
            s.countries = collation.sortedArrayFromArray(section.countries, collationStringSelector: Selector("name")) as! [MICountry]
        }
        
        _sections = sections
        
        return _sections!
    }
    let collation = UILocalizedIndexedCollation.currentCollation()
        as UILocalizedIndexedCollation
    weak var delegate: AILocationSelectDelegate?
    var didSelectCountryClosure: ((String, String) -> ())?
    
    convenience public init(completionHandler: ((String, String) -> ())) {
        self.init()
        self.didSelectCountryClosure = completionHandler
    }
    
    private var tableView: UITableView =  UITableView()
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(tableView)
        tableView.frame = view.frame
        tableView.backgroundColor = UIColor.clearColor()
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.separatorStyle = .None
        
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "UITableViewCell")
        createSearchBar()
        tableView.reloadData()
        
        tableView.sectionIndexColor = UIColor(hex: "#AB807E")
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        
        tableView.contentInset = UIEdgeInsetsMake(0, 0, 50, 0)
        
    }
    
    func showSearchViewController(){
        
        let vc = UIStoryboard(name: AIApplication.MainStoryboard.MainStoryboardIdentifiers.AIAlertStoryboard, bundle: nil).instantiateViewControllerWithIdentifier(AIApplication.MainStoryboard.ViewControllerIdentifiers.AILocationSearchViewController)
        self.presentViewController(vc, animated: true, completion: nil)
        
    }
    
    // MARK: Methods
    
    private func createSearchBar() {
        if self.tableView.tableHeaderView == nil {
            
            if let head = AILocationSelectHeadView.initFromNib() {
                tableView.tableHeaderView = head
            }
        }
    }
    
    private func filter(searchText: String) -> [MICountry] {
        filteredList.removeAll()
        
        sections.forEach { (section) -> () in
            section.countries.forEach({ (country) -> () in
                let result = country.name.compare(searchText, options: [.CaseInsensitiveSearch, .DiacriticInsensitiveSearch], range: searchText.startIndex ..< searchText.endIndex)
                if result == .OrderedSame {
                    filteredList.append(country)
                }
                
            })
        }
        
        return filteredList
    }
}

// MARK: - Table view data source

extension AILocationSelectViewController {
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].countries.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var tempCell: UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("UITableViewCell")
        
        if tempCell == nil {
            tempCell = UITableViewCell(style: .Default, reuseIdentifier: "UITableViewCell")
        }
        
        let cell: UITableViewCell! = tempCell
        
        let country = sections[indexPath.section].countries[indexPath.row]
        cell.selectionStyle = .None
        cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.font = AITools.myriadLightWithSize(14)
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.text = country.name
        cell.addBottomWholeSSBorderLine("#6441D9")
        return cell
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if !sections[section].countries.isEmpty {
            return self.collation.sectionTitles[section] as String
        }
        return ""
    }
    
    public func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var title = ""
        if !sections[section].countries.isEmpty {
            title = self.collation.sectionTitles[section] as String
        }
        
        let label = UILabel()
        label.text = "   \(title)"
        label.backgroundColor = UIColor(hex: "#392C9D")
        label.frame = CGRectMake(0, 0, self.view.width, 20)
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.whiteColor()
        return label
    }
    
    public func sectionIndexTitlesForTableView(tableView: UITableView) -> [String]? {
        return collation.sectionIndexTitles
    }
    
    public func tableView(tableView: UITableView,
                                   sectionForSectionIndexTitle title: String,
                                                               atIndex index: Int)
        -> Int {
            return collation.sectionForSectionIndexTitleAtIndex(index)
    }
}

// MARK: - Table view delegate

extension AILocationSelectViewController {
    
    public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let country = sections[indexPath.section].countries[indexPath.row]
        delegate?.countryPicker(self, didSelectCountryWithName: country.name, code: country.code)
        didSelectCountryClosure?(country.name, country.code)
        //navigationController?.popToRootViewControllerAnimated(true)
    }
}
 