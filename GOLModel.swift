//
//  GOLModel.swift
//  GOL
//
//  Created by mengyun on 16/1/6.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import UIKit

class GOLModel: NSObject {
    //var currentdata: NSMutableArray!
    //var preData: NSMutableArray!
    var currentdata = [Bool]()
    var preData = [Bool]()
    var nSize: NSInteger!
    
    func initWithSize(size: NSInteger){
        nSize = size;
        currentdata.removeAll()
        for _ in 0...nSize*nSize-1 {
            currentdata+=[false]
        }
        //preData=currentdata
    }
    
    func DeleteData() {
        for i in 0...nSize*nSize-1 {
            currentdata[i] = false
        }
        preData = currentdata
    }
    
    func Next()->Int{
        var ifNeedBroadenGameView:Int = 0;
        preData = currentdata
        for i in 0...nSize*nSize-1{
            let aroundAliveNum = getAroundAliveNum(i)
            if aroundAliveNum == 3{
                currentdata[i] = true
            }
            else if aroundAliveNum == 2{
            }
            else{
                currentdata[i] = false
            }
            if nSize<120&&currentdata[i]&&(i/nSize<1||i/nSize+1>nSize||i%nSize<1||i%nSize+1>nSize){
                ifNeedBroadenGameView = -1
            }
        }
        if ifNeedBroadenGameView==(-1){
            broadenData()
        }
        return ifNeedBroadenGameView
    }
    
    func getAliveOrDie(btnID: Int)-> Int{
        return preData[btnID] ?1:0
    }
    
    func getAroundAliveNum(btnID: Int)-> Int{
        var rlt = 0
        let y = btnID/nSize
        let x = btnID%nSize
        for i in x-1...x+1{
            for j in y-1...y+1{
                if (i>=0&&i<nSize&&j>=0&&j<nSize){
                    rlt = rlt+getAliveOrDie(j*nSize+i)
                }
            }
        }
        rlt = rlt-getAliveOrDie(btnID)
        return rlt
    }
    
    func broadenData(){
        let increment=2
        nSize = nSize+2*increment
        initWithSize(nSize)
        for i in increment...nSize-increment-1{
            for j in increment...nSize-increment-1{
                currentdata[j*nSize+i]=preData[(j-increment)*(nSize-2*increment)+i-increment]
            }
        }
    }
    
    func setDataWithFlag(flag: Int){
        for i in 0...nSize*nSize-1{
            currentdata[i]=false
        }
        if flag==1{
            let startPos=nSize-3
            currentdata[startPos+1] = true
            currentdata[startPos+self.nSize] = true
            currentdata[startPos+self.nSize*2] = true
            currentdata[startPos+self.nSize*2+1] = true
            currentdata[startPos+self.nSize*2+2] = true
        }
        if(flag == 4)
        {
            for i in 0...nSize*nSize-1{
                currentdata[i]=true
            }
        }
        if(flag == 5)
        {
            for i in 0...nSize*nSize-1{
                if(i%2 == 0){
                    currentdata[i]=true
                }
            }
        }
        if(flag == 6)
        {
            for i in 0...nSize*nSize-1{
                if(i%3 == 0){
                    currentdata[i]=true
                }
            }
        }
        if(flag == 7)
        {
            for i in 0...nSize*nSize-1{
                if(i%4 == 0){
                    currentdata[i]=true
                }
            }
        }
        if(flag == 8)
        {
            for i in 0...nSize*nSize-1{
                if(i%nSize == i/nSize){
                    currentdata[i]=true
                }
            }
        }
        if(flag == 9)
        {
            for i in 0...nSize*nSize-1{
                if(i%nSize == i/nSize || i%nSize + i/nSize == nSize-1){
                    currentdata[i]=true
                }
            }
        }
        if(flag == 10)
        {
            for i in 0...nSize*nSize-1{
                if(i%3 == 0){
                    currentdata[i]=true
                }
            }
        }
        if(flag == 11)
        {
            for i in 0...nSize*nSize-1{
                if(i%3 == 0){
                    if (i/nSize<4||i/nSize+4>nSize||i%nSize<4||i%nSize+4>nSize){
                        currentdata[i]=true
                    }
                }
            }
        }
        if(flag == 2)
        {
            for i in 0...nSize*nSize-1{
                if(i%3 == 0){
                    if (i/nSize>2&&i/nSize+2<nSize&&i%nSize>2&&i%nSize+2<nSize){
                        currentdata[i]=true
                    }
                }
            }
        }
        if(flag == 3)
        {
            let middle = nSize/5
            for i in 0...nSize*nSize-1{
                if(i%3 == 0){
                    if (i/nSize<middle||i/nSize+middle>nSize||i%nSize<middle||i%nSize+middle>nSize){
                        currentdata[i]=true
                    }
                }
            }
        }
    }
    
    /*
    
    */
}
