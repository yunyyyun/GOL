//
//  GOLViewController.swift
//  GOL
//
//  Created by mengyun on 16/1/6.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import UIKit

class GOLViewController: UIViewController, UITextFieldDelegate {
    
    var gameView: UIView!
    var preBtn: UIButton!
    var nextBtn: UIButton!
    var timeBtn: UIButton!
    var restartBtn: UIButton!
    var addBtn: UIButton!
    var deleteBtn: UIButton!
    
    var xText: UITextField!
    var yText: UITextField!
    var genLabel: UILabel!
    var headLabel: UILabel!
    
    var generation: NSInteger!{
        didSet {
            if (generation > -1){
                genLabel.text = NSString(format: "自动机第(%d)代", generation)as String
            }
            else{
                generation = generation+1
            }
        }
    }
    var data: GOLModel!
    var gView: GOLView2!
    
    var timer: NSTimer!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        generation = -1
        data = GOLModel()
        data.initWithSize(5)
        initGameViewWithCellNumber(data.currentdata.count)
        refreshGameView()
        initOtherViews()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: Selector("viewTapped"))
        tapGesture.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGesture)
    }
    
    func initGameViewWithCellNumber(number: NSInteger){
        let startX: CGFloat = 10.0
        let startY: CGFloat = 51.0
        let totalWidth = self.view.frame.size.width-2*startX
        let spaceWidth: CGFloat = 0//15/CGFloat(data.nSize)
        let cellWidth: CGFloat = (totalWidth-2*spaceWidth)/CGFloat(data.nSize)
        if (gameView == nil){
            gameView = UIView(frame: CGRectMake(startX, startY, totalWidth, totalWidth))
            gameView.backgroundColor = UIColor.lightGrayColor()
            view.addSubview(gameView)
        }
        if(data.nSize<30){
            for i in 0...number-1{
                let y: NSInteger = i/data.nSize
                let x: NSInteger = i%data.nSize
                let cellBtnY: CGFloat = cellWidth*CGFloat(y)+spaceWidth
                let cellBtnX: CGFloat = cellWidth*CGFloat(x)+spaceWidth
                let cellBtn = UIButton(type: .Custom)
                cellBtn.frame = CGRectMake(cellBtnX+spaceWidth, cellBtnY+spaceWidth, cellWidth-2*spaceWidth, cellWidth-2*spaceWidth)
                cellBtn.accessibilityIdentifier = NSString(format: "%d", i) as String
                
                    cellBtn.setTitle("o", forState: UIControlState.Normal)
                    cellBtn.setTitleColor(UIColor.purpleColor(),forState: .Normal)
                    cellBtn.titleLabel!.font = UIFont.systemFontOfSize(cellBtn.intrinsicContentSize().width/2.2)
            
                cellBtn.layer.cornerRadius = 3.0
                cellBtn.layer.borderWidth = 15/CGFloat(data.nSize)
                cellBtn.layer.borderColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1).CGColor
                cellBtn.addTarget(self, action:Selector("cellBtnclick:"), forControlEvents: .TouchUpInside)
                gameView.addSubview(cellBtn)
            }
        }
        else{
            //gameView.backgroundColor = UIColor.grayColor()
            gView = GOLView2()
            let frame: CGRect = gameView.frame;
            gView.initWithFrame(frame.width,size: data.nSize)
        }
        if headLabel==nil{
            headLabel = UILabel(frame: CGRectMake(50, 18, self.view.frame.size.width-100, 30))
            headLabel.textAlignment = NSTextAlignment.Center
            self.view.addSubview(headLabel)

        }
        let headTitle = NSString(format: "Game Of Life(%dX%d)", self.data.nSize,self.data.nSize) as String
        headLabel.text = headTitle
    }
    
    func refreshGameView(){
        if(data.nSize<30){
            var btnID: Int
            for view in gameView.subviews {
                btnID = Int(view.accessibilityIdentifier!)!
                view.backgroundColor=data.currentdata[btnID] ?UIColor.blackColor():UIColor.grayColor()
            }
        }
        else{
            for view in gameView.subviews {
                view.removeFromSuperview()
            }
            gView.refreshGameViewWith(data.currentdata)
            let imgView = UIImageView(image: gView.image)
            gameView.addSubview(imgView)
        }
    }
    
    func initOtherViews(){
        let width = 17.0*Frame_Times
        let navHeight: CGFloat = 51.0
        
        var frame = CGRectMake(10*Frame_Times, navHeight+380*Frame_Times, width*5, width*2)
        preBtn = buttonInitWithFrame(frame, title: "上一步", enable: false)
        preBtn.addTarget(self, action: Selector("clickPre:"), forControlEvents: .TouchUpInside)
        
        frame = CGRectMake(100*Frame_Times, navHeight+380*Frame_Times, width*5, width*2)
        nextBtn = buttonInitWithFrame(frame, title: "下一步", enable: false)
        nextBtn.addTarget(self, action: Selector("clickNext:"), forControlEvents: .TouchUpInside)
        
        frame = CGRectMake(190*Frame_Times, navHeight+380*Frame_Times, width*5, width*2)
        timeBtn = buttonInitWithFrame(frame, title: "自动", enable: false)
        timeBtn.addTarget(self, action: Selector("clickTime:"), forControlEvents: .TouchUpInside)
        
        frame = CGRectMake(280*Frame_Times, navHeight+380*Frame_Times, width*5, width*2)
        restartBtn = buttonInitWithFrame(frame, title: "重开", enable: false)
        restartBtn.addTarget(self, action: Selector("clickRestart:"), forControlEvents: .TouchUpInside)
        
        frame = CGRectMake(190*Frame_Times, navHeight+420*Frame_Times, width*5, width*2)
        addBtn = buttonInitWithFrame(frame, title: "添加", enable: true)
        addBtn.addTarget(self, action: Selector("clickAdd"), forControlEvents: .TouchUpInside)
        
        frame = CGRectMake(280*Frame_Times, navHeight+420*Frame_Times, width*5, width*2)
        deleteBtn = buttonInitWithFrame(frame, title: "删除", enable: true)
        deleteBtn.addTarget(self, action: Selector("clickDelete"), forControlEvents: .TouchUpInside)
    
        genLabel = UILabel(frame: CGRectMake(50*Frame_Times, 600*Frame_Times, width*9, width*2))
        let generStr = "自动机第(0)代"
        genLabel.text = generStr
        genLabel.textAlignment = NSTextAlignment.Left

        xText = UITextField(frame: CGRectMake(10*Frame_Times, navHeight+420*Frame_Times,  width*5, width*2))
        xText.borderStyle = UITextBorderStyle.RoundedRect
        xText.autocorrectionType = UITextAutocorrectionType.Yes
        xText.placeholder = "xPoint"
        xText.returnKeyType = UIReturnKeyType.Go
        xText.clearButtonMode = UITextFieldViewMode.WhileEditing
        xText.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.7, alpha: 0.9)
        xText.keyboardType = UIKeyboardType.NumberPad
        xText.delegate = self
        
        yText = UITextField(frame: CGRectMake(100*Frame_Times, navHeight+420*Frame_Times,  width*5, width*2))
        yText.borderStyle = UITextBorderStyle.RoundedRect
        yText.autocorrectionType = UITextAutocorrectionType.Yes
        yText.placeholder = "yPoint"
        yText.returnKeyType = UIReturnKeyType.Done
        yText.clearButtonMode = UITextFieldViewMode.WhileEditing
        yText.backgroundColor = UIColor(red: 1.0, green: 0.8, blue: 0.7, alpha: 0.9)
        yText.keyboardType = UIKeyboardType.NumberPad
        yText.delegate = self
        
        self.view.addSubview(preBtn)
        self.view.addSubview(nextBtn)
        self.view.addSubview(timeBtn)
        self.view.addSubview(restartBtn)
        self.view.addSubview(addBtn)
        self.view.addSubview(deleteBtn)
        self.view.addSubview(xText)
        self.view.addSubview(yText)
        self.view.addSubview(genLabel)
    }
    
    func buttonInitWithFrame(frame: CGRect, title: String = "未命名", enable: Bool = true)->UIButton{
        let btn = UIButton(type: .Custom)
        btn.frame = frame
        btn.setTitle(title as String, forState: .Normal)
        btn.setTitle("禁用", forState: .Disabled)
        btn.titleLabel?.font = UIFont.systemFontOfSize(18.0)
        btn.enabled = enable
        btn.layer.cornerRadius = 6.0
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1).CGColor
        return btn
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        let animationDuration: NSTimeInterval = 0.3
        var frame = self.view.frame;
        if frame.origin.y == 0{
            frame.origin.y -= 216;
            frame.size.height+=216;
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        self.view.frame = frame
        UIView.commitAnimations();
        return true
    }
    
    func viewTapped(){
        let animationDuration: NSTimeInterval = 0.3
        var frame = self.view.frame;
        if frame.origin.y == -216{
            frame.origin.y += 216;
            frame.size.height-=216;
        }
        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationDuration(animationDuration)
        self.view.frame = frame
        UIView.commitAnimations();
        self.view.endEditing(true)
    }

    func cellBtnclick(btn: UIButton){
        let btnID: Int = Int(btn.accessibilityIdentifier!)!
        if data.currentdata[btnID]{
            data.currentdata[btnID] = false
            btn.backgroundColor = UIColor.grayColor();
        }
        else{
            data.currentdata[btnID] = true
            btn.backgroundColor = UIColor.blackColor();
        }
        data.preData = data.currentdata
        preBtn.enabled = false
        nextBtn.enabled = true
        timeBtn.enabled = true
        restartBtn.enabled = true
        generation = 0
        //genLabel.text = NSString(format: "自动机第(%d)代",generation) as String
    }
    
    func clickNext(btn: UIButton){
        if data.Next()+1==0{
            for view in gameView.subviews {
                view.removeFromSuperview()
            }
            initGameViewWithCellNumber(data.nSize*data.nSize)
        }
        refreshGameView();
        preBtn.enabled = true;
        generation = generation+1;
        //genLabel.text = NSString(format: "自动机第(%d)代", generation)as String
    }

    func clickPre(btn: UIButton){
        data.currentdata = data.preData
        refreshGameView();
        btn.enabled = false;
        generation = generation-1;
        //genLabel.text = NSString(format: "自动机第(%d)代", generation)as String
    }
    
    func clickTime(btn: UIButton){
        if !(timer == nil){
            timer.invalidate();
            timer = nil;
            timeBtn.setTitle("自动", forState: .Normal);
        }
        else{
            timer = NSTimer.scheduledTimerWithTimeInterval(0.25, target: self, selector: Selector("tick:"), userInfo: nil, repeats: true)
            preBtn.enabled = false
            nextBtn.enabled = false
            timeBtn.setTitle("暂停", forState: .Normal);
        }
    }
    func tick(paramTimer: NSTimer){
        if data.Next()+1==0{
            for view in gameView.subviews {
                view.removeFromSuperview()
            }
            initGameViewWithCellNumber(data.nSize*data.nSize)
        }
        refreshGameView();
        generation = generation+1;
        //genLabel.text = NSString(format: "自动机第(%d)代", generation)as String
    }
    
    func clickRestart(btn: UIButton){
        data.DeleteData()
        refreshGameView()
        preBtn.enabled = false
        nextBtn.enabled = false
        timeBtn.enabled = false
        timeBtn.setTitle("自动", forState: .Normal);
        generation = 0;
        //genLabel.text = NSString(format: "自动机第(%d)代", generation)as String
        if !(timer==nil){
            timer.invalidate()
            timer = nil;
        }
    }
    
    func clickAdd(){
        var addPointX = -1;
        var addPointY = -1;
        if (xText.text==""||xText.text=="")==false{
            addPointX = Int(xText.text!)!
            addPointY = Int(yText.text!)!
        }
        if (addPointX>=0&&addPointX<data.nSize&&addPointY>=0&&addPointY<data.nSize){
            let btnID = addPointY*data.nSize+addPointX
            let btn = gameView.subviews[btnID] as! UIButton
            data.currentdata[btnID] = true
            btn.backgroundColor = UIColor.blackColor()
            preBtn.enabled = false
            nextBtn.enabled = false
            timeBtn.enabled = false
            restartBtn.enabled = false
        }
    }
    
    func clickDelete(){
        var addPointX = -1;
        var addPointY = -1;
        if (xText.text==""||xText.text=="")==false{
            addPointX = Int(xText.text!)!
            addPointY = Int(yText.text!)!
        }
        if (addPointX>=0&&addPointX<data.nSize&&addPointY>=0&&addPointY<data.nSize){
            let btnID = addPointY*data.nSize+addPointX
            let btn = gameView.subviews[btnID] as! UIButton
            data.currentdata[btnID] = false
            btn.backgroundColor = UIColor.grayColor()
            preBtn.enabled = false
            nextBtn.enabled = false
            timeBtn.enabled = false
            restartBtn.enabled = false
        }
        for i in 0...data.nSize*data.nSize-1{
            if data.currentdata[i]{
                return
            }
        }
        preBtn.enabled = false
        nextBtn.enabled = false
        timeBtn.enabled = false
    }
    
    func SetDataWithFlag(flag: Int){
        data.setDataWithFlag(flag)
        refreshGameView()
        generation = 0
        for i in 0...data.nSize*data.nSize-1{
            if data.currentdata[i]{
                preBtn.enabled=false
                nextBtn.enabled=true
                timeBtn.enabled=true
                restartBtn.enabled=true
                return
            }
        }
        preBtn.enabled=false
        nextBtn.enabled=true
        timeBtn.enabled=true
        restartBtn.enabled=true
    }
    
    func InitWithFlag(Num: Int){
        for view in gameView.subviews {
            view.removeFromSuperview()
        }
        generation = 0
        data.initWithSize(Num)
        initGameViewWithCellNumber(Num*Num)
        refreshGameView()
        preBtn.enabled=false
        nextBtn.enabled=false
        timeBtn.enabled=false
        restartBtn.enabled=false
        if !(timer==nil){
            timer.invalidate()
            timer = nil;
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
