//
//  QuizViewController.swift
//  Rocket Study
//
//  Created by Admin on 8/11/16.
//  Copyright © 2016 roman. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds

class QuizViewController : UIViewController {
    
    var curQuiz:QuizData?
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var imgProgress: UIImageView!
    
    var arrViews = [UIView]()
    var arrButtons = [UIButton]()
    var arrLabels = [AnyObject]()
    
    var quizIx: Int = 1
    
    var lblQuiz: UILabel!
    
    @IBOutlet weak var GoogleBannerView: GADBannerView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        lblQuiz.hidden = true
        imgProgress.hidden = true
        lblTitle.hidden = true
        
        let count : Int = arrViews.count
        for i in 1...count {
            let v = self.arrViews[i-1]
            v.hidden = true
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named:"icon_rocket")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let myBackButton:UIButton = UIButton(type: UIButtonType.Custom)
        myBackButton.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        myBackButton.addTarget(self, action: #selector(QuizViewController.popToRoot), forControlEvents: UIControlEvents.TouchUpInside)
        myBackButton.frame = CGRectMake(0,0,30,30)
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        lblQuiz = UILabel()
        lblQuiz.textColor = UIColor.init(red: 85.0/256, green: 99.0/256, blue: 117.0/256, alpha: 1)
        lblQuiz.numberOfLines = 0
        lblQuiz.adjustsFontSizeToFitWidth = true
        lblQuiz.minimumScaleFactor = 0.3
        lblQuiz.font = UIFont.systemFontOfSize(21.0)
        self.view.addSubview(lblQuiz)
        
        
        for _ in 0...3 {
            let view = UIView()
            view.layer.cornerRadius = 7
            view.layer.masksToBounds = true
            view.backgroundColor = UIColor.whiteColor()
            arrViews.append(view)
            
            let button = UIButton()
            arrButtons.append(button)
            
            let label = UILabel()
            label.numberOfLines = 0
            label.adjustsFontSizeToFitWidth = true
            label.textColor = UIColor.init(red: 85.0/256, green: 99.0/256, blue: 117.0/256, alpha: 1)
            label.font = label.font.fontWithSize(16)
            arrLabels.append(label)
            
            self.view.addSubview(view)
            view.addSubview(button)
            view.addSubview(label)
            
            view.hidden = true
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(QuizViewController.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        GoogleBannerView.adUnitID = "ca-app-pub-3876549689987737/5981925401"
        GoogleBannerView.rootViewController = self
        GoogleBannerView.loadRequest(GADRequest())
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        AppInstance.quizSet.removeAll()
        
        var categories = [CategoryData]()
        for category in AppInstance.curThema.categories {
            if category.isSelected == true {
                categories.append(category)
            }
        }
        
        var i = 0
        while AppInstance.quizSet.count < 10 {
            let category = categories[i];
            if category.selectedQuiz < category.quizDB.count {
                let quiz = category.quizDB[category.selectedQuiz]
                quiz.isUsed = true
                AppInstance.quizSet.append(quiz)
                category.selectedQuiz+=1
                
                print("added thema:\(quiz.thema) category:\(quiz.category) Idx:\(quiz.nIx)")
            } else {
                category.shuffleQuiz()
                continue
            }
            
            if AppInstance.quizSet.count > 9 {
                break
            }
            
            if i == categories.count - 1 {
                i = 0
                continue
            }
            i+=1
        }
        
        for quiz in AppInstance.quizSet {
            quiz.shuffleAnswer()
        }
        
        lblQuiz.hidden = false
        imgProgress.hidden = false
        lblTitle.hidden = false
        
        for i in 0...3 {
            let v = self.arrViews[i]
            v.hidden = true
        }
        
        quizIx = 1
        
        showQuizData()
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        popToRoot()
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
        
/*
        if quizIx == 1 {
            quiz.quiz = "This is sample"
        } else if quizIx == 2 {
            quiz.quiz = "1This is sample text. 2This is sample text."
        } else if quizIx == 3 {
            quiz.quiz = "1This is sample text. 2This is sample text. 3This is sample text."
            
        } else if quizIx == 4 {
            quiz.quiz = "1This is sample text. 2This is sample text. 3This is sample text. 4This is sample text."
            
        } else if quizIx == 5 {
            quiz.quiz = "1This is sample text. 2This is sample text. 3This is sample text. 4This is sample text. 5This is sample text."
            
        } else if quizIx == 6 {
            quiz.quiz = "1This is sample text. 2This is sample text. 3This is sample text. 4This is sample text. 5This is sample text. 6This is sample text."
            
        } else if quizIx == 7 {
            quiz.quiz = "1This is sample text. 2This is sample text. 3This is sample text. 4This is sample text. 5This is sample text. 6This is sample text. 7This is sample."
            
        } else if quizIx == 8 {
            quiz.quiz = "1This is sample text. 2This is sample text. 3This is sample text. 4This is sample text. 5This is sample text. 6This is sample text. 7This is sample. 8This is sample."
            
        } else if quizIx == 9 {
            quiz.quiz = "1This is sample text. 2This is sample text. 3This is sample text. 4This is sample text. 5This is sample text. 6This is sample text. 7This is sample. 8This is sample. 9. This is sample"
            
        } else if quizIx == 10 {
            quiz.quiz = "1This is sample text. 2This is sample text. 3This is sample text. 4This is sample text. 5This is sample text. 6This is sample text. 7This is sample. 8This is sample. 9 This is sample 10 This is sample"
            
        }
 */
        
        
        var maxHeightForQuiz:CGFloat = 0
        var height:CGFloat = 0
        var diff:CGFloat = 0
        
        if screenSize.height == 480 {
            maxHeightForQuiz = 50.0
            height = 45
            diff = 15

        } else if screenSize.height == 568  {
            maxHeightForQuiz = 70.0
            height = 55
            diff = 25

        } else if screenSize.height == 667 {
            maxHeightForQuiz = 100.0
            height = 65
            diff = 30
        } else { // if screenSize.height == 540 {
            maxHeightForQuiz = 120.0
            height = 70
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
        
 //       let height:CGFloat = 65//screenHeight - y - vAdmob.frame.size.height - 10
        
        for i in 0...3 {
            
            let v = self.arrViews[i]
            
            if i < quiz.nAnsCnt {
                v.hidden = false

                v.frame = CGRectMake(20, y, width, height)
                y +=  (v.frame.size.height) + 10
                
                let b = self.arrButtons[i]
                b.frame = CGRectMake(0,0,v.frame.size.width, v.frame.size.height)
                b.tag = 10 + i
                b.addTarget(self, action: #selector(QuizViewController.touchUp(_:)), forControlEvents:.TouchUpInside)
                b.addTarget(self, action: #selector(QuizViewController.touchDown(_:)), forControlEvents:.TouchDown)
                
                let l = self.arrLabels[i] as! UILabel
                l.frame = CGRectMake(7,5,v.frame.size.width-14,v.frame.size.height-10)
                l.text = quiz.answers[i]
            } else {
                v.hidden = true
            }
        }
        
        self.lblTitle.text = "\(quizIx) van de \(AppInstance.quizSet.count)"
        self.imgProgress.image = UIImage(named: "progres-bar-\(quizIx-1)")
    }
    
    
    func touchUp(sender:UIButton){
        let ix = sender.tag - 10
        let v = self.arrViews[ix]
        v.backgroundColor = UIColor.whiteColor()
        
        let l = self.arrLabels[ix] as! UILabel
        l.textColor = UIColor.init(red: 85.0/256, green: 99.0/256, blue: 117.0/256, alpha: 1)
        
        curQuiz?.nSel = ix + 1
        
        if quizIx > 9 {
            self.performSegueWithIdentifier("toResult", sender:self)
        }
        else {
            quizIx += 1
            showQuizData()
        }
    }
    
    func touchDown(sender:UIButton){
        let ix = sender.tag - 10
        let v = self.arrViews[ix]
        v.backgroundColor = UIColor.init(red: 63.0/256, green: 170.0/256, blue: 216.0/256, alpha: 1)
        
        let l = self.arrLabels[ix] as! UILabel
        l.textColor = UIColor.whiteColor()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.navigationItem.title = ""
        
        if segue.identifier == "toResult" {
        }
    }
    
    func popToRoot(){
        self.navigationController!.popViewControllerAnimated(true);
    }
}
