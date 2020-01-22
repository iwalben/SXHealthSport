//
//  SXDrinkController.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/10.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import SCLAlertView
let reusedID = "SXDrinkCellID"

class SXDrinkController: SXBaseViewController , UITableViewDelegate , UITableViewDataSource {
    var datas: [Drink]!
    
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        
        let headerVirew : UIView = UIView.init(frame:CGRect(x: 0, y: 0, width: SXScreenH, height: 50))
        headerVirew.backgroundColor = SXThemeColor
        let tLabel : UILabel = UILabel.init()
        tLabel.text = "按时喝水,保持健康"
        tLabel.textAlignment = .center
        tLabel.textColor = UIColor.white
        tLabel.font = UIFont.systemFont(ofSize:13)
        headerVirew.addSubview(tLabel)
        tLabel.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
        }
        
        tView.tableHeaderView = headerVirew
        tView.backgroundColor = UIColor.white
        tView.rowHeight = 57
        tView.register(UINib(nibName: "SXDrinkCell", bundle: .main), forCellReuseIdentifier: reusedID)
        return tView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "喝水提醒"
        self.datas = SXSportDataManager.shareManager.queryUserCellData() ?? []
        view.addSubview(self.tableView)
        self.tableView.frame = view.bounds
        self.tableView.frame.size.height = SXScreenH - SXNavigationHeight
        
        guard UserDefaults.standard.object(forKey: NOTIFICATIONKEY) == nil else {return}
        for drink in datas {
            SXNotificationManager.manager.addNotification(dateString: drink.time)
        }
        UserDefaults.standard.set("add", forKey: NOTIFICATIONKEY)
        self.tableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.datas = SXSportDataManager.shareManager.queryUserCellData() ?? []
        self.tableView.reloadData()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.datas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! SXDrinkCell
        let drink: Drink = self.datas![indexPath.row]
        cell.cellTitleL.text = drink.time
        cell.smileSwitch.setOn(drink.value, animate: true)
        cell.smileSwitch.valueChange = {[weak cell](value : Bool) in
            print(value)
            SXSportDataManager.shareManager.modifyUserCellData(primaryKey: indexPath.row, value: !value)
            if value { //关闭
                SXNotificationManager.manager.calcleNotificationForDate(dateString: cell!.cellTitleL.text!)
                guard self.isAllNotificationOpen(data: self.datas) || self.isAllNotificationClose(data: self.datas) else{
                    SCLAlertView().showInfo("温馨提示", subTitle: "关闭通知成功")
                    return
                }
            }else{
                SXNotificationManager.manager.addNotification(dateString: cell!.cellTitleL.text!)
                guard self.isAllNotificationOpen(data: self.datas) || self.isAllNotificationClose(data: self.datas) else{
                    SCLAlertView().showInfo("温馨提示", subTitle: "开启通知成功")
                    return
                }
            }
            
            if self.isAllNotificationOpen(data: self.datas) {
                SXSportDataManager.shareManager.modifyUserData(remind: "打开")
                return
            }
            
            if self.isAllNotificationClose(data: self.datas) {
                SXSportDataManager.shareManager.modifyUserData(remind: "关闭")
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell : SXDrinkCell = tableView.cellForRow(at: indexPath) as! SXDrinkCell
        let pickView : SXPickDateView = SXPickDateView.init(frame: CGRect.zero)
        let cellString : String = cell.cellTitleL.text!
        //09:33
        let h_index = cellString.index(cellString.startIndex, offsetBy: 2)
        let hour = String(cellString.prefix(upTo:h_index))
        let m_index = cellString.index(cellString.startIndex, offsetBy: 3)
        let minute = String(cellString.suffix(from: m_index))
        pickView.setupSelectedHourAndMinute(hour: hour, minute: minute)
        pickView.showView(superV: self.view)
        pickView.selectedHandle = {(hour : String , minute :String) in
            let time = "\(hour):\(minute)"
            cell.cellTitleL.text = time
            SXSportDataManager.shareManager.modifyUserCellData(primaryKey: indexPath.row, time: time)
            guard cell.smileSwitch.on == false else {
                SXNotificationManager.manager.addNotification(dateString: time)
                SCLAlertView().showInfo("温馨提示", subTitle: "设置成功")
                return
            }
        }
    }
    
    func isAllNotificationOpen(data:[Drink]) -> Bool {
        var flag = true
        for model in self.datas {
            if model.value == false {
                flag = false
                break
            }
        }
        return flag
    }
    
    
    func isAllNotificationClose(data:[Drink]) -> Bool {
        var flag = true
        for model in self.datas {
            if model.value == true {
                flag = false
                break
            }
        }
        return flag
    }
    
    func openAllNotification() -> Void {
        for item in self.datas {
            SXNotificationManager.manager.addNotification(dateString: item.time)
        }
        SXSportDataManager.shareManager.modifyUserCellData(allValueChange: true)
        self.tableView.reloadData()
    }
    
    func closeAllNotification() -> Void {
        SXNotificationManager.manager.cancelAllNotificaton()
        SXSportDataManager.shareManager.modifyUserCellData(allValueChange: false)
        self.tableView.reloadData()
    }
}
