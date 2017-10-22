//
//  InfoVC.swift
//  Rocket Study
//
//  Created by Admin on 8/16/16.
//  Copyright © 2016 roman. All rights reserved.
//

import Foundation
import UIKit

class InfoVC : UIViewController {
    
    @IBOutlet var lblText : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named:"icon_rocket")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let myBackButton:UIButton = UIButton(type: UIButtonType.Custom)
        myBackButton.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        myBackButton.addTarget(self, action: #selector(InfoVC.popToRoot), forControlEvents: .TouchUpInside)
        myBackButton.frame = CGRectMake(0,0,30,30)
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        self.lblText.text = AppInstance.curThema.comment
        lblText.sizeToFit()
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(InfoVC.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)

    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        popToRoot()
    }
    
    func popToRoot(){
        self.navigationController!.popViewControllerAnimated(true);
    }
}