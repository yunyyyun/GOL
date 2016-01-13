//
//  GOLView2.swift
//  GOL
//
//  Created by mengyun on 16/1/11.
//  Copyright © 2016年 mengyun. All rights reserved.
//

import UIKit

class GOLView2: UIImageView {
    var nSize: NSInteger!
    var nWidth: CGFloat!
    func initWithFrame(width: CGFloat,size: NSInteger){
        nSize = size;
        nWidth = width
    }
    func refreshGameViewWith(data: [Bool]){
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(nWidth, nWidth), false, 0);
        let context = UIGraphicsGetCurrentContext();
        let radius:CGFloat = nWidth/CGFloat(nSize)
        for i in 0...nSize*nSize-1{
            let y: NSInteger = i/nSize
            let x: NSInteger = i%nSize
            let cellBtnY: CGFloat = radius*CGFloat(y)
            let cellBtnX: CGFloat = radius*CGFloat(x)
            if data[i]{
                //CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1)
                let aliveColor = ColorData.aliveColorComponents()
                CGContextSetRGBFillColor(context, aliveColor[0],aliveColor[1],aliveColor[2],aliveColor[3])
            }
            else{
                //CGContextSetRGBFillColor(context, 0.4, 0.4, 0.4, 1)
                let dieColor = ColorData.dieColorComponents()
                CGContextSetRGBFillColor(context, dieColor[0],dieColor[1],dieColor[2],dieColor[3])
            }
            //CGContextSetRGBStrokeColor(context,0,0,0,0)
            //CGContextAddEllipseInRect(context, CGRectMake(cellBtnX, cellBtnY, radius, radius))
            CGContextAddRect(context, CGRectMake(cellBtnX, cellBtnY, radius-1, radius-1));
            CGContextDrawPath(context, .Fill)
        }
        image = UIGraphicsGetImageFromCurrentImageContext()
        //let data=UIImagePNGRepresentation(image!);
        //data?.writeToFile("/Users/mengyun/Desktop/ab1sc123.png", atomically: true)
    }
}


/*
UIGraphicsBeginImageContextWithOptions( CGSizeMake(200, 200), NO, 0);
30     //1.获取bitmap上下文
31     CGContextRef ctx = UIGraphicsGetCurrentContext();
32     //2.绘图(画一个圆)
33     CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, 100, 100));
34     //3.渲染
35     CGContextStrokePath(ctx);
36     //4.获取生成的图片
37     UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
38     //5.显示生成的图片到imageview
39     self.iv.image=image;
*/