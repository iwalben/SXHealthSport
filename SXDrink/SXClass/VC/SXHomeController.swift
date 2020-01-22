//
//  SXHomeController.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/9.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import SnapKit
import HGRippleRadarView

class SXHomeController: SXBaseViewController ,BMKLocationManagerDelegate{
    private let mapView: BMKMapView = BMKMapView.init()
    private let locationManager: BMKLocationManager = BMKLocationManager.init()
    private let userLocation :BMKUserLocation = BMKUserLocation.init()
    private var ripperView : RippleView!
    
    private lazy var todayL : UILabel = {
        let tl: UILabel = UILabel.init()
        tl.font = UIFont.systemFont(ofSize: 14)
        tl.textColor = UIColor.white
        tl.backgroundColor = SXThemeColor
        return tl
    }()
    
    private lazy var middleBtn : UIButton = {
        let btn = UIButton.init(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        btn.setTitle("开始运动", for: UIControl.State.normal)
        btn.backgroundColor = SXThemeColor
        btn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        btn.layer.masksToBounds = true
        btn.layer.shadowColor = btn.backgroundColor?.cgColor
        btn.layer.shadowOffset = CGSize(width: 0, height: 5)
        btn.layer.shadowOpacity = 0.8
        btn.layer.shadowRadius = 8
        btn.layer.cornerRadius = btn.frame.size.width / 2;
        btn.addTarget(self, action: #selector(btnClick), for: UIControl.Event.touchUpInside)
        return btn
    }()
    
    @objc func btnClick(){
        self.navigationController?.pushViewController(SXRunController.init(), animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "运动"
        mapView.frame = view.bounds
        //显示定位图层
        mapView.showsUserLocation = true;
        view.addSubview(mapView)
        mapView.zoomLevel = 18;

        locationManager.delegate = self
        locationManager.coordinateType = .BMK09LL
        locationManager.distanceFilter =  kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.activityType = .automotiveNavigation;
        locationManager.pausesLocationUpdatesAutomatically = false;
        locationManager.allowsBackgroundLocationUpdates = false;
        locationManager.locationTimeout = 10;
        locationManager.startUpdatingHeading()
        locationManager.startUpdatingLocation()
        
        view.addSubview(todayL)
        todayL.snp.makeConstraints { (make) in
            make.left.equalToSuperview()
            make.height.equalTo(25)
            make.top.equalTo(20)
        }
        
        ripperView = RippleView.init(frame:view.bounds)
        ripperView.numberOfCircles = 0
        view.addSubview(self.ripperView)
        
        view.addSubview(middleBtn)
        middleBtn.snp.makeConstraints { (make) in
            make.width.height.equalTo(100)
            make.centerX.equalToSuperview()
            make.bottom.equalTo(-SXTabBarHeight-10)
        }
        let user = UserPrivateData(value: [0,"关闭",3, [[0 ,"08:30" ,false],[1 ,"10:30" ,false],[2 ,"12:30" ,false],[3 ,"14:30" ,false],[4 ,"16:30" ,false],[5 ,"18:30" ,false],[6 ,"20:30" ,false]]])
        SXSportDataManager.shareManager.addUserData(user: user)
        guard UserDefaults.standard.object(forKey:SXUSERDATAREMINDKEY) == nil else { return }
        UserDefaults.standard.set("UserPrivateData", forKey: SXUSERDATAREMINDKEY)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        mapView.viewWillAppear()
        let mileage = SXSportDataManager.shareManager.queryUserData()?.totoalGoalMileage
        todayL.text = "今日目标:" + "\(Int(mileage ?? 0))"+"公里"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        mapView.viewWillDisappear()
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    
    //#pragma mark - BMKLocationManagerDelegate
    func bmkLocationManager(_ manager: BMKLocationManager, didFailWithError error: Error?) {
        print("定位失败")
    }
    
    // 更新定位的位置朝向
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate heading: CLHeading?) {
        print("更新定位的位置朝向")
        userLocation.heading = heading
        mapView.updateLocationData(userLocation)
    }
    
    // 更新定位的位置信息
    func bmkLocationManager(_ manager: BMKLocationManager, didUpdate location: BMKLocation?, orError error: Error?) {
        print("更新定位的位置信息")
        if error != nil {
            print("Error=\(error?.localizedDescription ?? "0")")
        }
        
        if location == nil {
            print("定位失败")
            return
        }
        userLocation.location = location?.location
        mapView.updateLocationData(userLocation)
        mapView.setCenter(userLocation.location.coordinate, animated: true)
    }
}
