//
//  SXRunController.swift
//  SXDrink
//
//  Created by Roddick on 2020/1/10.
//  Copyright © 2020 Roddick. All rights reserved.
//

import UIKit
import fluid_slider


class SXRunController: SXBaseViewController ,SXRunViewDelegate{

// MARK: - init
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        runView.locationManager.stopUpdatingLocation()
    }
    
    private var runView : SXRunView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "运动"
        let nibs = Bundle.main.loadNibNamed("SXRunView", owner: nil, options:nil)
        runView = (nibs?.last as! SXRunView)
        runView.frame = view.bounds
        runView.delegate = self
        view.addSubview(runView)
    }
    
    
 // MARK: - action

    
 // MARK: - method
    func runViewGoBack() -> Void {
        self.navigationController?.popViewController(animated: true)
    }
}


//        let slider = Slider.init(frame: CGRect(x: 0, y: 200, width: SXScreenH, height: 50))
//        slider.attributedTextForFraction = { fraction in
//            let formatter = NumberFormatter()
//            formatter.maximumIntegerDigits = 3
//            formatter.maximumFractionDigits = 0
//            let string = formatter.string(from: (fraction * 500) as NSNumber) ?? ""
//            return NSAttributedString(string: string)
//        }
//        slider.setMinimumLabelAttributedText(NSAttributedString(string: "0"))
//        slider.setMaximumLabelAttributedText(NSAttributedString(string: "500"))
//        slider.fraction = 0.5
//        slider.shadowOffset = CGSize(width: 0, height: 10)
//        slider.shadowBlur = 5
//        slider.shadowColor = UIColor(white: 0, alpha: 0.1)
//        slider.contentViewColor = UIColor(red: 78/255.0, green: 77/255.0, blue: 224/255.0, alpha: 1)
//        slider.valueViewColor = .white
//        view.addSubview(slider)
//
//        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
//@objc func sliderValueChanged(){
//
//}
