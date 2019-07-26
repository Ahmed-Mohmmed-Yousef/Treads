//
//  CurrentRunVC.swift
//  Treads
//
//  Created by Ahmed on 7/26/19.
//  Copyright © 2019 Ahmed, ORG. All rights reserved.
//

import UIKit

class CurrentRunVC: LocationVC {

    @IBOutlet weak var swipBGImage: UIImageView!
    @IBOutlet weak var sliderImgView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let swip = UIPanGestureRecognizer(target: self, action: #selector(endReunSwiped(sinder:)))
        sliderImgView.addGestureRecognizer(swip)
        sliderImgView.isUserInteractionEnabled = true
        swip.delegate = self as? UIGestureRecognizerDelegate
    }
    
    @objc func endReunSwiped(sinder: UIPanGestureRecognizer){
        let minAdjust: CGFloat = 80
        let maxAdjust: CGFloat = 130
        if sliderImgView == sinder.view{
            if sinder.state == .began || sinder.state == .changed{
                let traslation = sinder.translation(in: self.view)
                if sliderImgView.center.x >= (swipBGImage.center.x - minAdjust) && sliderImgView.center.x <= (swipBGImage.center.x + maxAdjust){
                    sliderImgView.center = CGPoint(x: sliderImgView.center.x + traslation.x, y: sliderImgView.center.y)
                } else if sliderImgView.center.x >= (swipBGImage.center.x + maxAdjust){
                    sliderImgView.center.x = swipBGImage.center.x + maxAdjust
                    // End Run Code here
                    dismiss(animated: true, completion: nil)
                } else {
                    sliderImgView.center.x = swipBGImage.center.x - minAdjust
                }
                
                sinder.setTranslation(CGPoint.zero, in: self.view)
            } else if  sinder.state == .ended {
                UIView.animate(withDuration: 0.1) { [weak self] in
                    guard let self = self else { return }
                    self.sliderImgView.center.x = self.swipBGImage.center.x - minAdjust
                }
            }
        }
    }
}
