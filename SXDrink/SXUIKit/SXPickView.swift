//
//  SXPickView.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/16.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit

class SXPickView: UIView ,UIPickerViewDelegate , UIPickerViewDataSource {
    private var index = 0
    private let containViewWidth = 300
    private let containViewHeight = 300
    private var titleData : [String]!
    private var tipsTitle : String!
    private var selectedHandle: ((String)->Void)?
    //MARK: - lazy

    private lazy var containView : UIView = {
        let cView = UIView.init()
        cView.layer.shadowColor = UIColor.black.cgColor
        cView.layer.shadowOpacity = 0.7
        cView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cView.layer.shadowRadius = 8
        return cView
    }()
    
    private lazy var headerView : UIView = {
        let hView = UIView.init()
        hView.backgroundColor = SXHEXCOLOR(rgbValue:0x5CCDDA) //SXThemeColor
        return hView
    }()
    private lazy var pickerView : UIPickerView = {
        let p : UIPickerView = UIPickerView.init()
        p.backgroundColor = SXHEXCOLOR(rgbValue:0x5CCDDA)  //SXThemeColor
        p.delegate = self
        p.dataSource = self
        return p
    }()
    
    lazy var cancleBtn : UIButton = {
        let btn : UIButton =  UIButton.init()
        btn.setTitle("取消", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(clickCancle), for: .touchUpInside)
        return btn
    }()
    
    lazy var doneBtn : UIButton = {
        let btn : UIButton = UIButton.init()
        btn.setTitle("完成", for: .normal)
        btn.setTitleColor(UIColor.white, for: .normal)
        btn.setTitleColor(UIColor.white, for: .selected)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.addTarget(self, action: #selector(clickDone), for: .touchUpInside)
        return btn
    }()
    
    lazy var titleL : UILabel = {
        let tl : UILabel = UILabel.init()
        tl.textAlignment = .center
        tl.text = tipsTitle
        tl.textColor = UIColor.white
        tl.font = .systemFont(ofSize: 14)
        return tl
    }()
    
    lazy var backEffective : UIVisualEffectView = {
        let blurEct : UIBlurEffect =  UIBlurEffect(style: UIBlurEffect.Style.light)
        let effectView : UIVisualEffectView = UIVisualEffectView(effect: blurEct)
        effectView.alpha = 0
        return effectView
    }()
    
    
    //MARK: - init
    override init(frame: CGRect) {
        super.init(frame:frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func setupUI() -> Void {
        self.addSubview(self.backEffective)
        self.addSubview(self.containView)
        
        self.headerView.addSubview(self.cancleBtn)
        self.headerView.addSubview(self.doneBtn)
        self.headerView.addSubview(self.titleL)
        
        let line : UIView = UIView.init()
        line.backgroundColor = UIColor.white
        self.headerView.addSubview(line)
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(0)
            make.height.equalTo(1)
        }

        self.containView.addSubview(self.pickerView)
        self.containView.addSubview(self.headerView)
    }
    
    //MARK: - Action()
    @objc func clickDone(){
        if (self.selectedHandle != nil) {
            let first_idex : Int = self.pickerView.selectedRow(inComponent: 0)
            self.selectedHandle!((self.titleData?[first_idex])!)
        }
        self.clickCancle()
    }
    
    @objc func clickCancle(){
        let keyAnimation = CAKeyframeAnimation(keyPath: "transform.scale")
        keyAnimation.values = [ 1.0, 0.999, 0.996, 0.993, 0.99, 0.96, 0.93, 0.9, 0.6, 0.3, 0 ]
        keyAnimation.duration = 0.3
        keyAnimation.timingFunction = CAMediaTimingFunction(name: .easeIn)
        self.containView.layer.add(keyAnimation, forKey: nil)
        self.containView.transform = CGAffineTransform(scaleX: 0,y: 0)

        
        UIView.animate(withDuration: 0.3, animations: {
            self.backEffective.alpha = 0
        }) { (finish) in
            self.removeFromSuperview()
        }
    }
    
    //MARK: - method
    func showView(superV:UIView ,title : String = "", tipsTitle:String = "请选择", titleData:[String]! , handle : ((String)->Void)?) -> Void {
        self.selectedHandle = handle
        self.titleData = titleData
        self.tipsTitle = tipsTitle
        var i = 0
        for value : String in self.titleData!{
            if value == title {
                self.index = i
                break
            }
            i += 1
        }

        if #available(iOS 11.0, *) {
            if superV.contains(self){
                return
            }
        }
        superV.addSubview(self)
        startLayout()
        
        UIView.animate(withDuration: 0.7, animations: {
            self.backEffective.alpha = 1
            self.containView.alpha = 1
        }) { (finish) in
            self.refresh()
        }
        let keyAnimation : CAKeyframeAnimation = CAKeyframeAnimation.init(keyPath: "transform.scale")
        keyAnimation.values = [0.0, 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0, 1.03, 1.06, 1.09, 1.093, 1.096, 1.099, 1.1, 1.09, 1.08, 1.07, 1.06, 1.05, 1.04, 1.03, 1.02, 1.01, 1.009, 1.006, 1.003, 1]
        keyAnimation.duration =  0.7
        
        keyAnimation.timingFunction = CAMediaTimingFunction(name:.easeOut)
        self.containView.layer.add(keyAnimation, forKey:nil)
        self.containView.transform = CGAffineTransform(scaleX: 1,y: 1)
    }
    
    func refresh() -> Void {
        self.pickerView.selectRow(self.index, inComponent: 0, animated: true)
        self.pickerView.reloadComponent(0)
    }
    
    func startLayout() -> Void {
        
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        self.backEffective.snp.makeConstraints({ (make) in
            make.edges.equalToSuperview()
        })
        
        let width = containViewWidth
        let height = containViewHeight
        
        
        
        self.containView.snp.makeConstraints { (make) in
            make.size.equalTo(CGSize(width: width, height: height))
            make.center.equalToSuperview()
        }
        
        let btnWidth = 14*4
        self.headerView.frame = CGRect(x: 0, y: 0, width: width, height: 40)
        self.cancleBtn.frame = CGRect(x: 0, y: 0, width: btnWidth, height: 40)
        self.doneBtn.frame = CGRect(x: width - btnWidth, y: 0, width: btnWidth, height: 40)
        self.titleL.frame = CGRect(x: btnWidth, y: 0, width: width - btnWidth*2, height: 40)
        self.pickerView.frame = CGRect(x: 0, y: 40, width: containViewWidth, height: containViewHeight - 40)
    }
    
    //MARK: - PickerViewDelegate  - PickerViewDataSource
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.titleData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 36
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var tl : UILabel? =  view as? UILabel
        if tl == nil {
            tl = UILabel.init()
            tl?.textAlignment = .center
            tl?.textColor = UIColor.white
            tl?.font = .boldSystemFont(ofSize:14)
        }
        tl?.text = self.titleData[row]
        return tl!
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerView.reloadComponent(0)
    }

}
