//
//  SXBDManager.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/10.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import CoreLocation
import AVFoundation

class SXBDManager: NSObject ,BMKLocationAuthDelegate{
    static let SXBaiduMapAK = "WYku09tFmiLWPBYlThFuEGiNqmKaFsz3"
    
    
    let  location:CLLocationManager = CLLocationManager.init()

    static let manager : SXBDManager = {
        let instance = SXBDManager()
        return instance
    }()
    
    func start() -> Bool {
//                // 要使用百度地图，请先启动BaiduMapManager
//                   BMKMapManager *mapManager = [[BMKMapManager alloc] init];
//                   // 如果要关注网络及授权验证事件，请设定generalDelegate参数
//                   BOOL ret = [_mapManager start:@"在此处输入您的授权AK"  generalDelegate:nil];
//                   if (!ret) {
//                       NSLog(@"manager start failed!");
//                   }
//                   /**
//                    全局设置地图SDK与开发者交互时的坐标类型。不调用此方法时，
//
//                    设置此坐标类型意味着2个方面的约定：
//                    1. 地图SDK认为开发者传入的所有坐标均为此类型；
//                    2. 所有地图SDK返回给开发者的坐标均为此类型；
//
//                    地图SDK默认使用BD09LL（BMK_COORDTYPE_BD09LL）坐标。
//                    如需使用GCJ02坐标，传入参数值为BMK_COORDTYPE_COMMON即可。ß
//                    本方法不支持传入WGS84（BMK_COORDTYPE_GPS）坐标。
//
//                    @param coorType 地图SDK全局使用的坐标类型
//                    @return 设置成功返回YES，设置失败返回False
//                    */
        let mapManager = BMKMapManager.init()
        BMKMapManager.setCoordinateTypeUsedInBaiduMapSDK(.COORDTYPE_BD09LL)
        let ret: Bool = mapManager.start("WYku09tFmiLWPBYlThFuEGiNqmKaFsz3", generalDelegate: nil)
        if !ret {
            print("地图启动失败!")
        }else{
           print("地图启动成功")
        }
        
        BMKLocationAuth.sharedInstance()?.checkPermision(withKey: "WYku09tFmiLWPBYlThFuEGiNqmKaFsz3", authDelegate: self)
        //语音权限检查
        checkUserAudioAuthor()
        //定位权限检查
        checkLocation(manager: location)
        return ret
    }
    
    
   // BMKLocationAuthDelegate
    func onCheckPermissionState(_ iError: BMKLocationAuthErrorCode) {
        print("定位错误码 = \(iError.rawValue)")
    }
    
    
    func checkLocation(manager: CLLocationManager) -> Void {
        let enable = CLLocationManager.locationServicesEnabled()
        if enable {
            print("定位服务可用")
        }else{
            print("定位服务不可用")
        }
        let statue = CLLocationManager.authorizationStatus()
        switch statue {
            case .notDetermined:
                fallthrough
            case .restricted:
                manager.requestWhenInUseAuthorization()
            case .denied:
                print("请开启定位权限")
            case .authorizedAlways:
                print("允许后台定位")
            case .authorizedWhenInUse:
                print("在app使用时允许定位")
        default:
            break
        }
    }
    
    func checkUserAudioAuthor() -> (Void) {
        let auth = AVCaptureDevice.authorizationStatus(for: .audio)
        switch auth {
            case .notDetermined://未询问用户是否授权
                print("未询问用户是否授权")
                let audio = AVAudioSession.sharedInstance()
                if audio.responds(to: Selector(("requestRecordPermission"))) {
                    audio.perform(#selector(AVAudioSession.requestRecordPermission(_:)))
                }
            case .restricted:
                fallthrough
            case .denied:
            print("未授权")
            case .authorized:
            print("已授权")
        default:
            break
        }
    }
}
