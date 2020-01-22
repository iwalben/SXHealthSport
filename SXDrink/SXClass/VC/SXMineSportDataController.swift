//
//  SXMineSportDataController.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/16.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class SXMineSportDataController: UIViewController ,UITableViewDataSource , UITableViewDelegate {
    
    private let reusedID = "SXMineSportDataCellID"
    private var mileageArray : NSMutableArray!
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = SXHEXCOLOR(rgbValue:0xF2F2F2)
        tView.register(UINib(nibName: "SXMineSportDataCell", bundle: .main), forCellReuseIdentifier: reusedID)
        return tView
    }()
    
    lazy var data = {
        return SXSportDataManager.shareManager.queryAllSport()
    }()
    


    override func viewDidLoad() {
        super.viewDidLoad()
        data = SXSportDataManager.shareManager.queryAllSport()
        view.addSubview(self.tableView)
        self.tableView.frame = view.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        data = SXSportDataManager.shareManager.queryAllSport()
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190+20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! SXMineSportDataCell
        cell.sport  = self.data[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
}
