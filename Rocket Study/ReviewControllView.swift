//
//  ReviewControllView.swift
//  Rocket Study
//
//  Created by Admin on 8/12/16.
//  Copyright © 2016 roman. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class ReviewControlView : UIViewController { //, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgProgress: UIImageView!
    @IBOutlet var btnNext:UIButton!
    @IBOutlet weak var GoogleBannerView: GADBannerView!
    
    var curQuiz:QuizData?
    var quizIx: Int = 1
    
    var arrViews = [AnyObject]()
    var arrLabels = [AnyObject]()
    
    var lblQuiz : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named:"icon_rocket")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let myBackButton:UIButton = UIButton(type: UIButtonType.Custom)
        myBackButton.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        myBackButton.addTarget(self, action: #selector(ReviewControlView.popToRoot), forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.frame = CGRectMake(0,0,30,30)
        
        
        lblQuiz = UILabel()
        lblQuiz.textColor = UIColor.init(red: 85.0/256, green: 99.0/256, blue: 117.0/256, alpha: 1)
        lblQuiz.numberOfLines = 0
        lblQuiz.adjustsFontSizeToFitWidth = true
        lblQuiz.minimumScaleFactor = 0.3
        lblQuiz.font = UIFont.systemFontOfSize(21.0)
        self.view.addSubview(lblQuiz)
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        for _ in 0...3 {
            let view = UIView()
            view.layer.cornerRadius = 7
            view.layer.masksToBounds = true
            arrViews.append(view)
            
            let label = UILabel()
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.font = label.font.fontWithSize(16)
            
            label.frame = CGRectMake(0,0,0,0)
            
            arrLabels.append(label)
            
            self.view.addSubview(view)
            view.addSubview(label)
            
            view.hidden = true
        }
        
        lblQuiz.hidden = true
        lblTitle.hidden = true
        imgProgress.hidden = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(ReviewControlView.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        GoogleBannerView.adUnitID = "ca-app-pub-3876549689987737/5981925401"
        GoogleBannerView.rootViewController = self
        GoogleBannerView.loadRequest(GADRequest())
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        popToRoot()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        lblTitle.hidden = false
        imgProgress.hidden = false
        lblQuiz.hidden = false
        
        showQuizData()
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func showQuizData() {
        let quiz = AppInstance.quizSet[quizIx-1]
        
        curQuiz = quiz

        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let width = screenSize.width - 40
        
        
        var maxHeightForQuiz:CGFloat = 0
        var height:CGFloat = 0
        var diff:CGFloat = 0
        
        if screenSize.height == 480 {
            maxHeightForQuiz = 50.0
            height = 35
            diff = 10
            
        } else if screenSize.height == 568  {
            maxHeightForQuiz = 70.0
            height = 45
            diff = 25
            
        } else if screenSize.height == 667 {
            maxHeightForQuiz = 100.0
            height = 65
            diff = 30
        } else { // if screenSize.height == 540 {
            maxHeightForQuiz = 100.0
            height = 75
            diff = 30
        }
        
        
        var height1:CGFloat = heightForView(quiz.quiz, font:UIFont.systemFontOfSize(21.0), width:width )
        print("\(height1)")
        if height1 > maxHeightForQuiz {
            height1 = maxHeightForQuiz
        }
        
        lblQuiz.frame = CGRectMake( 20, imgProgress.frame.origin.y + 25, width, height1 )
        lblQuiz.text = quiz.quiz
        
        var y = lblQuiz.frame.origin.y + lblQuiz.frame.size.height + diff
        print( "\(y)" )
        
        for i in 0...3 {
            
            let v = self.arrViews[i] as! UIView
            
            if i < quiz.nAnsCnt {
                v.hidden = false
                
                v.frame = CGRectMake(20, y, width, height) //height/4-20)
                y += (v.frame.size.height) + 10
                
                let l = self.arrLabels[i] as! UILabel
                l.frame = CGRectMake(7,5,v.frame.size.width-14,v.frame.size.height-10)
                l.text = quiz.answers[i]
                
                if i+1 == curQuiz?.nOK {
                    v.backgroundColor = UIColor.init(red: 102.0/256, green: 204.0/256, blue: 51.0/256, alpha: 1)
                    l.textColor = UIColor.whiteColor()
                }
                else if i+1 == curQuiz?.nSel && curQuiz?.nOK != curQuiz?.nSel {
                    v.backgroundColor = UIColor.init(red: 248.0/256, green: 13.0/256, blue: 13.0/256, alpha: 1)
                    l.textColor = UIColor.whiteColor()
                }
                else {
                    v.backgroundColor = UIColor.whiteColor()
                    l.textColor = UIColor.init(red: 85.0/256, green: 99.0/256, blue: 117.0/256, alpha: 1)
                }
                
            } else {
                v.hidden = true
            }
        }
        
        self.lblTitle.text = "\(quizIx) van de \(AppInstance.quizSet.count)"
        self.imgProgress.image = UIImage(named: "progres-bar-\(quizIx-1)")
    }

    
    func popToRoot(){
        self.navigationController!.popViewControllerAnimated(true);
    }
    
    @IBAction func clickNext(sender:UIButton) {
        
        if quizIx > 9 {
//            self.performSegueWithIdentifier("toResult", sender: btnResult)
            self.navigationController?.popViewControllerAnimated(true)
        }
        else {
            quizIx += 1
            showQuizData()
        }
    }
}