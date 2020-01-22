//
//  SXMineController.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/15.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import Cards

class SXMineController: SXBaseViewController ,UITableViewDelegate ,UITableViewDataSource ,SXMineSettingControllerDelegate {
    private let reusedStyleAID = "SXMineShowCellID"
    private let reusedStyleBID = "SXMinePlayerCellID"
    private var card : CardArticle?
    private var dayMileage : String!
    private lazy var tableView : UITableView = {
        let tView: UITableView = UITableView.init(frame: CGRect.zero , style: UITableView.Style.plain)
        tView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tView.delegate = self
        tView.dataSource = self
        tView.backgroundColor = SXHEXCOLOR(rgbValue:0xF2F2F2)
        tView.register(UINib(nibName: "SXMineShowCell", bundle: .main), forCellReuseIdentifier: reusedStyleAID)
        tView.register(UINib(nibName: "SXMinePlayerCell", bundle: .main), forCellReuseIdentifier: reusedStyleBID)
        return tView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        _ = SXSportDataManager.shareManager.queryAllSport()
        dayMileage = String(format: "%.2f公里", SXSportDataManager.shareManager.getCurrentDaySportMileage(current: Date()))
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "我的"
        view.addSubview(self.tableView)
        self.tableView.frame = view.bounds
        self.tableView.frame.size.height = SXScreenH - SXNavigationHeight
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 2 {
            return 330
        }else{
            return 170
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 2 {
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedStyleBID, for: indexPath) as! SXMinePlayerCell
            let card = cell.viewWithTag(500) as! CardPlayer
            let vc : SXMineSportDataController = SXMineSportDataController.init()
            card.videoSource = URL(string: "http://static1.gotokeep.com/homepage/full.mp4")
            card.shouldDisplayPlayer(from: self)
            card.playerCover = UIImage(named: "sx_montain")
            card.playImage = UIImage(named: "sx_play")
            card.isAutoplayEnabled =  false
            card.shouldRestartVideoWhenPlaybackEnds = false
            card.title =  "我的运动数据"
            let times = SXSportDataManager.shareManager.totalTimes
            card.subtitle =  "总运动次数" + "\(times)" + "次" + "\n今日已运动里程:" + dayMileage
            card.category = "Today Video"
            card.shouldPresent(vc, from: self,fullscreen: true)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: reusedStyleAID, for: indexPath) as! SXMineShowCell
            let card = cell.viewWithTag(1000) as! CardArticle
            card.backgroundImage = UIImage(named: "sx_montain")
            card.textColor = .white
            if indexPath.row == 0 {
                self.card = card
                card.title = "我的设置"
                let mileage = SXSportDataManager.shareManager.queryUserData()?.totoalGoalMileage
                card.subtitle = "今日目标里程:" + String(mileage ?? 0) + "公里"
                card.category = "Setting"
                let v = SXMineSettingController.init()
                v.delegate = self
                card.shouldPresent(v, from: self,fullscreen: true)
            }else if indexPath.row == 1 {
                card.title = "关于我们"
                card.subtitle = "隐私协议"
                card.category = "Privacy policy"
                let v =  SXPolicyController.init()
                card.shouldPresent(v, from: self ,fullscreen: true)
            }else{
                let vc : SXMineSettingController = SXMineSettingController.init()
                card.shouldPresent(vc, from: self,fullscreen: true)
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func reload() {
        let mileage = SXSportDataManager.shareManager.queryUserData()?.totoalGoalMileage
        self.card!.subtitle = "今日目标里程:" + String(mileage ?? 0) + "公里"
    }
}
