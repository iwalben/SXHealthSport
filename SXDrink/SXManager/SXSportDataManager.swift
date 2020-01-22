//
//  SXSportDataManager.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/17.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import RealmSwift


class Sport: Object {
    //开始时间
    @objc dynamic var startTime = ""
    //结束时间
    @objc dynamic var endTime = ""
    //运动里程
    @objc dynamic var mileage = ""
    //平均速度
    @objc dynamic var averageSpeed = ""
    //平均配速
    @objc dynamic var averageSettingSpped = ""
    //时长
    @objc dynamic var durationTime = ""
    //卡路里
    @objc dynamic var calorie = ""
}

// 水的数据模型
class Drink: Object {
    //主键
    @objc dynamic var id = 0
    @objc dynamic var time = ""
    @objc dynamic var value = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class UserPrivateData: Object {
    //主键
    @objc dynamic var id = 0
    //设置通知打开和关闭
    @objc dynamic var remindtips = "关闭"
    //今日目标里程
    @objc dynamic var totoalGoalMileage : Int = 3
    override static func primaryKey() -> String? {
        return "id"
    }
    let cellDatas = List<Drink>()
}


class SXSportDataManager: NSObject {

    static let shareManager: SXSportDataManager = {
        let instance = SXSportDataManager()
        return instance
    }()

    private let realm = try! Realm()
    public var totalTimes = 0
    
    func configuralRealm() -> Void {
        /* Realm 数据库配置，用于数据库的迭代更新 */
        let schemaVersion: UInt64 = 0
        let config = Realm.Configuration(schemaVersion: schemaVersion, migrationBlock: { migration, oldSchemaVersion in
            /* 什么都不要做！Realm 会自行检测新增和需要移除的属性，然后自动更新硬盘上的数据库架构 */
            if (oldSchemaVersion < schemaVersion) {}
        })
        Realm.Configuration.defaultConfiguration = config
        Realm.asyncOpen { (realm, error) in
            /* Realm 成功打开，迁移已在后台线程中完成 */
            if let _ = realm {
                print("Realm 数据库配置成功")
            }
            /* 处理打开 Realm 时所发生的错误 */
            else if let error = error {
                print("Realm 数据库配置失败：\(error.localizedDescription)")
            }
        }
    }
    
    func addSport(sport: Sport) -> Void {
        try! realm .write {
            realm.add(sport)
        }
    }

    func deleteSport(sport:Sport) -> Void {
        try! realm.write {
            realm.delete(sport)
        }
    }

    func deleteAllSport() -> Void {
        try! realm.write {
            realm.deleteAll()
        }
    }

    func queryAllSport() -> Results<Sport> {
        let sports = realm.objects(Sport.self)
        self.totalTimes = sports.count
        return sports
    }
    
    func getCurrentDaySportMileage(current : Date) -> Double {
        let condition = sx_StringDayFromeDate(date: Date())
        let sports = realm.objects(Sport.self).filter("startTime BEGINSWITH '\(condition)'")
        var mileage = 0.0
        for sport in sports {
            mileage += Double(sport.mileage)!
        }
        return mileage
    }
    
    //增
    func addUserData(user: UserPrivateData) -> Void {
        guard UserDefaults.standard.object(forKey:SXUSERDATAREMINDKEY) == nil else { return }
        try! realm .write {
            realm.add(user)
        }
        print("用户数据插入成功")
    }
    
    //查
    func queryUserData() -> (UserPrivateData?) {
        return realm.object(ofType: UserPrivateData.self, forPrimaryKey: 0)
    }
    
    //查datas
    func queryUserCellData() -> [Drink]?{
        let user = self.queryUserData()
        guard  user != nil else {return nil}
        var datas :[Drink] = []
        for drink in user!.cellDatas{
            datas.append(drink)
        }
        print("查datas 成功")
        return datas
    }
    
    //改 (通知设置)
    func modifyUserData(remind:String) -> Void{
        let user = self.queryUserData()
        guard  user != nil || user!.remindtips != remind else {return}
        try! realm .write {
            user!.remindtips = remind
        }
        print("改 (通知设置) 成功")
    }
    
    //改 (今日目标里程)
    func modifyUserData(mileage:Int) -> Void{
        let user = self.queryUserData()
        guard  user != nil || user!.totoalGoalMileage != mileage else {return}
        try! realm .write {
            user!.totoalGoalMileage = mileage
        }
        print("改 (今日目标里程) 成功")
    }
    
    
    //改 (CellData通知时间)
    func modifyUserCellData(primaryKey:Int , time : String) -> Void{
        let user = self.queryUserData()
        guard  user != nil else {return}
        try! realm .write {
            for drink in user!.cellDatas{
                if drink.id == primaryKey {
                    drink.time = time
                }
            }
        }
        print("改 (CellData通知时间) 成功")
    }
    
    //改 (CellData通知设置)
    func modifyUserCellData(primaryKey:Int , value : Bool) -> Void{
        let user = self.queryUserData()
        guard  user != nil else {return}
        try! realm .write {
            for drink in user!.cellDatas{
                if drink.id == primaryKey {
                    drink.value = value
                }
            }
        }
        print("改 (CellData通知设置) 成功")
    }
    
    //改 (CellData通知设置-allValueChange)
    func modifyUserCellData(allValueChange : Bool) -> Void{
        let user = self.queryUserData()
        guard  user != nil else {return}
        try! realm .write {
            for drink in user!.cellDatas{
                drink.value = allValueChange
            }
        }
        print("改 (CellData通知设置-allValueChange) 成功")
    }
    
}
