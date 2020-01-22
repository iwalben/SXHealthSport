//
//  SXMineSettingController.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/17.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

@objc protocol SXMineSettingControllerDelegate: NSObjectProtocol{
    @objc optional func reload()
}

class SXMineSettingController: UIViewController,UITableViewDataSource , UITableViewDelegate {
    public weak var delegate: SXMineSettingControllerDelegate?
    private let reusedID = "SXMineSportDataStyleCellID"
    private var mileageArray : NSMutableArray!
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = SXHEXCOLOR(rgbValue:0xF2F2F2)
        tView.register(UINib(nibName: "SXMineSportDataStyleCell", bundle: .main), forCellReuseIdentifier: reusedID)
        return tView
    }()
    

    private var data :[(String,String)]!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mileageArray = NSMutableArray.init()
        for index in 1...100 {
            self.mileageArray.add(String(index)+"公里")
        }
        view.addSubview(self.tableView)
        self.tableView.frame = view.bounds
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let set = SXSportDataManager.shareManager.queryUserData()?.remindtips
        let mileage = SXSportDataManager.shareManager.queryUserData()?.totoalGoalMileage
        self.data = [("设置今日目标里程",String(mileage ?? 0)+"公里"),("通知提醒设置(全部关闭或全部打开)", set ?? "关闭")]
        self.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reusedID, for: indexPath) as! SXMineSportDataStyleCell
        cell.mainL.text = self.data[indexPath.row].0
        cell.subL.text = self.data[indexPath.row].1
        
        let imageV =  cell.viewWithTag(900) as! UIImageView
        imageV.isHidden  = false
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let cell = tableView.cellForRow(at: indexPath) as! SXMineSportDataStyleCell
        if indexPath.row == 0 {
            let rPick : SXPickView = SXPickView.init(frame: .zero)
            rPick.showView(superV: self.view, title: cell.subL.text!, tipsTitle: "请设置今日目标里程", titleData:(self.mileageArray.copy() as! [String])) { (value : String) in
                print("今日目标里程设置"+value)
                cell.subL.text = value
                let index = value.index(value.endIndex, offsetBy: -2)
                let goal = String(value.prefix(upTo:index))
                SXSportDataManager.shareManager.modifyUserData(mileage: Int(goal)!)
                self.delegate?.reload?()
            }
        }

        if indexPath.row == 1 {
            let pick = SXPickView.init(frame: .zero)
            pick.showView(superV: self.view, title: cell.subL.text!, tipsTitle: "请设置提醒功能", titleData:["打开","关闭"]) { (value:String) in
                print("value" + value)
                cell.subL.text = value
                SXSportDataManager.shareManager.modifyUserData(remind: value)
                if value == "关闭"{
                    let navs :[SXNavgationController] = UIApplication.shared.keyWindow?.rootViewController?.children as! [SXNavgationController]
                    for nav in navs{
                        for vc in nav.children {
                            if vc.isKind(of: SXDrinkController.self) {
                                let dvc : SXDrinkController = vc as! SXDrinkController
                                dvc.closeAllNotification()
                                break
                            }
                        }
                    }
                }
                
                if value == "打开"{
                    let navs :[SXNavgationController] = UIApplication.shared.keyWindow?.rootViewController?.children as! [SXNavgationController]
                    for nav in navs{
                        for vc in nav.children {
                            if vc.isKind(of: SXDrinkController.self) {
                                let dvc : SXDrinkController = vc as! SXDrinkController
                                dvc.openAllNotification()
                                break
                            }
                        }
                    }
                }
                
            }
        }
    }
}
