//
//  SXRunView.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/13.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import CoreLocation
import CircleMenu

@objc protocol SXRunViewDelegate: NSObjectProtocol{
    @objc optional func runViewGoBack()
}

class SXRunView: UIView ,BMKLocationManagerDelegate ,CircleMenuDelegate{

    @IBOutlet weak var runTotalL: UILabel!
    @IBOutlet weak var castTimeL: UILabel!
    @IBOutlet weak var speedL: UILabel!
    
    @IBOutlet weak var pauseBtn: CircleMenu!
    
    @IBOutlet weak var pauseConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var bottomBackgroundView: UIView!
    
    weak var delegate: SXRunViewDelegate?
    var isDisplayout:Bool = false
    var startTime : NSDate = NSDate()
    var endTime : NSDate = NSDate()
    
    private var timer : Timer?
    private var count : CGFloat = 0.0
    public let locationManager: BMKLocationManager = BMKLocationManager.init()
    private var lastLocation: BMKLocation = BMKLocation.init()
    private var currentLocation: BMKLocation = BMKLocation.init()
    private var distance : CLLocationDistance = 0
    private var speed: CLLocationSpeed = 0
    
    let items: [(icon: String, color: UIColor)] = [
        ("sx_play", UIColor(red: 0.19, green: 0.57, blue: 1, alpha: 1)),
        ("sx_white_back", UIColor(red: 0.22, green: 0.74, blue: 0, alpha: 1))
    ]
    
    // MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
    }

    required init?(coder : NSCoder) {
        super.init(coder: coder)
        start()
    }
    
    func start() -> Void {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCount), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if !isDisplayout {
            self.backgroundColor = SXThemeColor
            bottomBackgroundView.backgroundColor = UIColor.clear
            pauseBtn.delegate = self
            pauseBtn.duration = 0.5
            pauseBtn.buttonsCount = 2
            pauseBtn.distance = 150
            pauseBtn.startAngle = -90
            pauseBtn.endAngle = 90
            
            showCornerRadius(btn: pauseBtn)
            
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
        }
        isDisplayout = true
    }
    
    // MARK: - action
    
    @IBAction func pauseBtnClick(_ sender: Any) {
        self.endTime = NSDate()
        
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
        
        UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.pauseBtn.alpha = 0
        }, completion:nil)
        
        self.locationManager.stopUpdatingLocation()
    }
    
    @objc func timeCount(){
        count += 1 ;
        self.castTimeL.text = formattingTime(time: Float(count))
    }
    

    // MARK: - method
    func showCornerRadius(btn: UIButton!) -> Void {
        btn.layer.masksToBounds = true
        btn.layer.cornerRadius = btn.frame.size.width/2
    }
    
    
    // 格式化时间
    fileprivate func formattingTime(time:Float) -> String {
        var minutes: String = "\((Int)(time / 60))"
        if (Int)(time / 60) < 10 {
            minutes = "0\((Int)(time / 60))"
        }
        var seconds: String = String(format: "%.0f", (time.truncatingRemainder(dividingBy: 60)))
        if time.truncatingRemainder(dividingBy: 60) < 10 {
            seconds = "0" + seconds
        }
        return minutes + ":" + seconds
    }
    //MARK: - BMKLocationManagerDelegate
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
        
        print("+++更新+++")

        self.lastLocation = self.currentLocation
        self.currentLocation = location!
        self.speed = fabs(self.currentLocation.location?.speed ?? 0)
        
        let last : CLLocation = self.lastLocation.location ?? location?.location! ??  CLLocation.init()
        let current : CLLocation = self.currentLocation.location!
        let dis :CLLocationDistance = current.distance(from: last)
        if dis > 0 {
            self.distance += dis
        }
        self.runTotalL.text = String(format: "%.2f", self.distance/1000)
        self.speedL.text = String(format: "%.1f", speed)
    }
    
    //MARK: - CircleMenuDelegate
    func circleMenu(_: CircleMenu, willDisplay button: UIButton, atIndex: Int) {
        button.backgroundColor = items[atIndex].color
        button.setImage(UIImage(named: items[atIndex].icon), for: .normal)
        let highlightedImage = UIImage(named: items[atIndex].icon)?.withRenderingMode(.alwaysTemplate)
        button.setImage(highlightedImage, for: .highlighted)
        button.tintColor =  UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
    }
    
    
    func circleMenu(_ circleMenu: CircleMenu, buttonDidSelected button: UIButton, atIndex: Int) {
        print("atIndex = \(atIndex)")
        if atIndex == 0 { //暂停
            if timer == nil {
                timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCount), userInfo: nil, repeats: true)
                RunLoop.current.add(timer!, forMode: RunLoop.Mode.common)
            }
            UIView.animate(withDuration: 0.5, delay: 0, options: UIView.AnimationOptions.curveEaseInOut, animations: {
                self.pauseBtn.alpha = 1
            }, completion:nil)
            self.locationManager.startUpdatingLocation()
        }
        
        if atIndex == 1 { //停止
            if timer != nil {
                timer?.invalidate()
                timer = nil
            }
            self.locationManager.stopUpdatingLocation()
            self.delegate?.runViewGoBack?()
            if self.distance < 20 {
                return
            }
            
            let sport  = sx_calculateData(duration: count, distance: self.distance, start: self.startTime, end: self.endTime)
            SXSportDataManager.shareManager.addSport(sport: sport)
            self.distance = 0
            
        }
    }
    
    func sx_calculateData(duration: CGFloat, distance:CLLocationDistance , start:NSDate , end:NSDate) -> (Sport) {
        let min = duration/60
        //平均速度
        let averageSpped : CLLocationSpeed = (distance/1000)/Double((min/60))
        //卡路里
        let calorie =  41 * distance / 1000;
        //配速
        let settingSpped = Double(duration)/(distance/1000)
        var paceMin = Int(floor(settingSpped/60))
        var paceSec = Int(round(settingSpped - Double(paceMin*60)))
        if paceSec == 60 {
            paceMin += 1
            paceSec = 0
        }
        var paceFormat = "%d':%d\""
        if paceSec < 10 {
            paceFormat = "%d':0%d\""
        }
        let settingSppedString = String(format: paceFormat, paceMin,paceSec)
        
        let sport  = Sport()
        sport.startTime = sx_StringFromeDate(date: start as Date)
        sport.endTime = sx_StringFromeDate(date: end as Date)
        sport.mileage = String(format: "%.2f", distance/1000)
        sport.averageSpeed = String(format: "%.2f", averageSpped)
        sport.averageSettingSpped = settingSppedString
        sport.durationTime = formattingTime(time: Float(duration))
        sport.calorie = String(format: "%.2f", calorie)
        return sport
    }
}
