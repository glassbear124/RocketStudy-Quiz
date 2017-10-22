//
//  ResultViewController.swift
//  Rocket Study
//
//  Created by Admin on 8/11/16.
//  Copyright © 2016 roman. All rights reserved.
//

import Foundation
import UIKit
import GoogleMobileAds
import KDCircularProgress

class ResultViewController : UIViewController {
    
    @IBOutlet var lblTitle: UILabel!
    
    @IBOutlet var lblScore: UILabel!
    @IBOutlet var imgProgress: UIImageView!
    
    @IBOutlet var btnReview: UIButton!
    @IBOutlet var btnNewSub: UIButton!
    @IBOutlet var btnHome: UIButton!
    @IBOutlet var btnStart: UIButton!
    
    var arrButtons = [UIButton]()
    
    @IBOutlet var vProgress: UIView!
    @IBOutlet weak var GoogleBannerView: GADBannerView!
    
    var progress:KDCircularProgress!
    
    var arrMsg : [String] = ["De keren dat je geleerd hebt?", "Even serieus…", "Op de gok gemaakt?", "​Sla je boek is open!", "​Jij kan beter!", "Oef… net niet!",
                             "​Het mooiste cijfer!", "Lekker bezig!", "#Badass", "You’re the sh*t!", "NERD Alert😀" ]
    var score:Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
 
        let logo = UIImage(named:"icon_rocket")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationItem.setHidesBackButton(true, animated:true);
        
        for quiz in AppInstance.quizSet {
            if quiz.nSel == quiz.nOK {
                score += 1
            }
        }
        
        lblTitle.text = arrMsg[score]
        lblScore.text = "\(score)"
        
        GoogleBannerView.adUnitID = "ca-app-pub-3876549689987737/5981925401"
        GoogleBannerView.rootViewController = self
        GoogleBannerView.loadRequest(GADRequest())
        
        progress = KDCircularProgress(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        progress.startAngle = -90
        progress.progressThickness = 0.1
        progress.trackThickness = 0
        progress.clockwise = true
        progress.center = vProgress.center
        progress.gradientRotateSpeed = 0.2
        progress.roundedCorners = true
        progress.glowMode = .NoGlow
        progress.setColors(UIColor.init(red:59.0/256, green:171.0/256, blue:210.0/256, alpha: 1),
                           UIColor.init(red:77.0/255, green:250.0/255, blue: 77.0/255, alpha: 0.8))
        view.addSubview(progress)
        
        var angle:Double
        angle = Double(score) * 36.0
        progress.animateFromAngle(0, toAngle:angle, duration:1.2) { completed in
            if completed {
                print("animation stopped, completed")
            } else {
                print("animation stopped, was interrupted")
            }
        }
        
        arrButtons.append(btnReview)
        arrButtons.append(btnNewSub)
        arrButtons.append(btnHome)
        arrButtons.append(btnStart)
        
        vProgress.hidden = true
        progress.hidden = true
        for button in arrButtons {
            button.hidden = true
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        vProgress.hidden = false
        progress.hidden = false
        for button in arrButtons {
            button.hidden = false
        }
    
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let width = screenSize.width
    
        var circleHeight:CGFloat = 0
        var buttonHeght:CGFloat = 0
        var diff:CGFloat = 0
        var outline:CGFloat = 0
        
        vProgress.translatesAutoresizingMaskIntoConstraints = true
        imgProgress.translatesAutoresizingMaskIntoConstraints = true
        lblScore.translatesAutoresizingMaskIntoConstraints = true

        if screenSize.height == 480 {
            circleHeight = 130.0
            buttonHeght = 30
            diff = 10
            outline = 15
            lblScore.font = UIFont.boldSystemFontOfSize(80)
            
        } else if screenSize.height == 568  {
            circleHeight = 150.0
            buttonHeght = 40
            diff = 20
            outline = 15
        } else if screenSize.height == 667 {
            circleHeight = 180.0
            buttonHeght = 50
            diff = 20
            outline = 20
        } else { // if screenSize.height == 540 {
            circleHeight = 200.0
            buttonHeght = 50
            diff = 40
            outline = 20
        }
        
        vProgress.frame = CGRectMake( (width-circleHeight)/2, vProgress.frame.origin.y, circleHeight, circleHeight )
        imgProgress.frame = CGRectMake( 0,0, circleHeight, circleHeight)
        progress.frame = CGRectMake(vProgress.frame.origin.x, vProgress.frame.origin.y,vProgress.frame.size.width+outline,vProgress.frame.size.width+outline)
        
        lblScore.center = imgProgress.center
        progress.center = vProgress.center
        
        var y = vProgress.frame.origin.y + vProgress.frame.size.height + diff
        for button in arrButtons {
            button.translatesAutoresizingMaskIntoConstraints = true;
            button.layer.cornerRadius = buttonHeght/2
            button.frame = CGRectMake( (width - btnReview.frame.size.width)/2, y, btnReview.frame.size.width, buttonHeght )
            y += (buttonHeght+5)
        }
    }
    
    @IBAction func goCategoryView(sender:UIButton) {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }
    
    @IBAction func goSubCategoryView(sender:UIButton) {
        let switchViewController = self.navigationController?.viewControllers[1] as! SubCategoryViewController
        self.navigationController?.popToViewController(switchViewController, animated: true)
    }
    
    @IBAction func goQuizView(sender:UIButton) {
        self.navigationController?.popViewControllerAnimated(true)
    }
}
