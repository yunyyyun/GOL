//
//  ViewController.swift
//  GOL
//
//  Created by mengyun on 16/1/5.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import UIKit
//define
let Frame_Times = UIScreen.mainScreen().bounds.size.width/375.0
let lNum = 11
let rNum = 9

class ViewController: UIViewController ,UIScrollViewDelegate{
    
    var sView: UIScrollView!
    var lView: UIView!
    var rView: UIView!
    var GOLViewCtl: GOLViewController!
    var times:CGFloat!{
        didSet {
            if (times > 0 ){
                //print("%lf",times)
                lView.frame = CGRectMake(100 - 100*times, 334 - 200*times, 100*times, 400*times)
                for i in 1...lNum{
                    //var tmpBtn:UIButton! = lView.subviews[i-1]
                    let tmpBtn = lView.subviews[i-1]as! UIButton
                    tmpBtn.frame = CGRectMake(4, 10*times+35*(CGFloat(i)-1)*times, 100*times-14, 30*times)
                    if (times>0.5){
                        tmpBtn.setTitle(NSString(format: "%d", i) as String, forState:UIControlState.Normal)
                    }
                    else{
                        tmpBtn.setTitle("-", forState:UIControlState.Normal)
                    }
                }
            }
            else{
                times = 0-times
                rView.frame = CGRectMake(475, 334 - 200*times, 100*times, 400*times)
                for i in 1...rNum{
                    //var tmpBtn:UIButton! = lView.subviews[i-1]
                    let tmpBtn = rView.subviews[i-1]as! UIButton
                    tmpBtn.frame = CGRectMake(10, 10*times+35*(CGFloat(i)-1)*times, 100*times-14, 30*times)
                    if (times>0.5){
                        tmpBtn.setTitle(NSString(format: "(%dX%d)", 10*i,i*10) as String, forState:UIControlState.Normal)
                    }
                    else{
                        tmpBtn.setTitle("-", forState:UIControlState.Normal)
                    }
                }

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        sView = UIScrollView(frame: CGRectMake(0, 0, 375*Frame_Times, 667*Frame_Times))
        sView.backgroundColor = UIColor.lightGrayColor()
        sView.contentSize = CGSizeMake(575*Frame_Times, 0)
        sView.showsHorizontalScrollIndicator = false
        sView.showsVerticalScrollIndicator = false
        sView.bounces = false
        sView.delegate = self
        sView.setContentOffset(CGPointMake(100, 0), animated: false)
        self.view.addSubview(sView)
        
        GOLViewCtl = GOLViewController()
        GOLViewCtl.view.frame = CGRectMake(100, 0, 375*Frame_Times, 667*Frame_Times)
        GOLViewCtl.view.backgroundColor = UIColor.lightGrayColor()
        self.addChildViewController(GOLViewCtl)
        sView.addSubview(GOLViewCtl.view)
        
        lView = UIView(frame: CGRectMake(1,1,1,1))
        lView.backgroundColor = UIColor.grayColor()
        lView.layer.cornerRadius = 5
        for i in 1...lNum {
            let btn = UIButton(type: .Custom)
            btn.frame = CGRectMake(1,1,1,1)
            btn.layer.cornerRadius = 5.0
            btn.backgroundColor = UIColor(white: 0.8,alpha: 0.8)
            btn.accessibilityIdentifier = NSString(format: "%d", i) as String
            btn.addTarget(self, action:Selector("clickToSetGOF:"), forControlEvents: .TouchUpInside)
            lView.addSubview(btn)
        }
        sView.addSubview(lView)
        
        rView = UIView(frame: CGRectMake(1,1,1,1))
        rView.backgroundColor = UIColor.grayColor()
        rView.layer.cornerRadius = 5
        for i in 1...rNum {
            let btn = UIButton(type: .Custom)
            btn.frame = CGRectMake(1,1,1,1)
            btn.layer.cornerRadius = 5.0
            btn.backgroundColor = UIColor(white: 0.8,alpha: 0.8)
            btn.accessibilityIdentifier = NSString(format: "%d", i+100) as String
            btn.addTarget(self, action:Selector("clickToSetGOF:"), forControlEvents: .TouchUpInside)
            rView.addSubview(btn)
        }
        sView.addSubview(rView)
              
        let lSet = UIButton(type: .Custom)
        lSet.frame = CGRectMake(101, 10, 40, 50)
        lSet.setImage(UIImage(named:"set"),forState:.Normal)
        lSet.addTarget(self, action: Selector("clickToSet:"), forControlEvents: .TouchUpInside)
        sView.addSubview(lSet)
        
        let RSet = UIButton(type: .Custom)
        RSet.frame = CGRectMake(100+375*Frame_Times-42, 10, 40, 50)
        RSet.setImage(UIImage(named:"set"),forState:.Normal)
        RSet.addTarget(self, action: Selector("clickToSet:"), forControlEvents: .TouchUpInside)
        sView.addSubview(RSet)
        
    }
    
    override func viewDidAppear(animated: Bool) {
        sView.addObserver(self, forKeyPath: "contentOffset", options: NSKeyValueObservingOptions.New, context: nil)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        let xx = sView.contentOffset.x
        times = 1.0 - xx/100.0
    }

    func clickToSet(btn:UIButton){
        if (sView.contentOffset.x == 0 || sView.contentOffset.x == 200) {
            sView.setContentOffset(CGPointMake(100, 0), animated: true)
        }else if (sView.contentOffset.x == 100 && btn.center.x > 200){
            sView.setContentOffset(CGPointMake(200, 0), animated: true)
        }else{
            sView.setContentOffset(CGPointMake(0, 0), animated: true)
        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        var offsetX = sView.contentOffset.x
        if (offsetX <= 50) {
            offsetX = 0
        }else if (offsetX <= 150){
            offsetX = 100
        }else if (offsetX <= 200){
            offsetX = 200
        }
        sView.setContentOffset(CGPointMake(offsetX, 0), animated: true)
    }
    func clickToSetGOF( btn:UIButton){
        let btnID: Int = Int(btn.accessibilityIdentifier!)!//[btn.accessibilityIdentifier intValue]
        if btnID<100{
            GOLViewCtl.SetDataWithFlag(btnID)
        }
        else{
            let Num = 10*(btnID-100)
            GOLViewCtl.InitWithFlag(Num)
        }
        sView.setContentOffset(CGPointMake(100, 0), animated: true)
        //[_sView setContentOffset:CGPointMake(100, 0)animated:YES]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}



















