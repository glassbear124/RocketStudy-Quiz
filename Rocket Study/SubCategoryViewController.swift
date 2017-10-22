//
//  SubCategoryViewController.swift
//  Rocket Study
//
//  Created by Admin on 8/11/16.
//  Copyright © 2016 roman. All rights reserved.
//

import Foundation
import UIKit

class SubCategoryViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var btnStart: UIButton!
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.lblTitle.text = AppInstance.curThema.title
        
        for category in AppInstance.curThema.categories {
            category.isSelected = false
            category.shuffleQuiz()
        }
      
        let logo = UIImage(named:"icon_rocket")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView

        let button: UIButton = UIButton(type: UIButtonType.Custom)
        button.setImage(UIImage(named: "icon_info"), forState: UIControlState.Normal)
        button.addTarget(self, action: #selector(SubCategoryViewController.infoButtonPressed), forControlEvents: .TouchUpInside)
        button.frame = CGRectMake(0, 0, 41, 41)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.rightBarButtonItem = barButton
        
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        let myBackButton:UIButton = UIButton(type: UIButtonType.Custom)
        myBackButton.setImage(UIImage(named: "icon_back"), forState: UIControlState.Normal)
        myBackButton.addTarget(self, action: #selector(SubCategoryViewController.popToRoot), forControlEvents: .TouchUpInside)
        myBackButton.frame = CGRectMake(0,0,30,30)
        
        let myCustomBackButtonItem:UIBarButtonItem = UIBarButtonItem(customView: myBackButton)
        self.navigationItem.leftBarButtonItem  = myCustomBackButtonItem
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(SubCategoryViewController.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        
        popToRoot()
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                print("Swiped down")
            case UISwipeGestureRecognizerDirection.Left:
                print("Swiped left")
            case UISwipeGestureRecognizerDirection.Up:
                print("Swiped up")
            default:
                break
            }
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.navigationItem.title = ""
        
        if segue.identifier == "toQuiz" {
//            let quizVC = segue.destinationViewController as! QuizViewController
            
 //           quizVC.categories.removeAll()
 //           for item in items {
 //               if item.isSelected == true {
 //                   quizVC.categories.append(item)
 //               }
 //           }
        }
        else if segue.identifier == "toInfo" {
            
        }
    }
    
    func popToRoot(){
        self.navigationController!.popViewControllerAnimated(true);
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppInstance.curThema.categories.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "SubCateogryCell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!
        
        let cd = AppInstance.curThema.categories[indexPath.row]
        let imageView = cell.viewWithTag(100) as? UIImageView
        imageView?.hidden = !cd.isSelected
        
        let nameLabel = cell.viewWithTag(101) as? UILabel
        nameLabel?.text = cd.name
        if cd.isSelected == true {
            nameLabel?.textColor = UIColor.init(colorLiteralRed: 102.0/256, green: 204.0/256, blue: 51.0/256, alpha: 1.0)
        } else {
            nameLabel?.textColor = UIColor.init(colorLiteralRed: 85.0/256, green: 99.0/256, blue: 117.0/256, alpha: 1.0)
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let cd = AppInstance.curThema.categories[indexPath.row]
        cd.isSelected = !cd.isSelected
        
        tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
    }
    
    func infoButtonPressed() {
        self.performSegueWithIdentifier("toInfo", sender: AppInstance.quizSet)
    }
    
    @IBAction func goQuizView(sender:UIButton) {
        
        var isSelect : Bool = false
        for item in AppInstance.curThema.categories {
            if item.isSelected == true {
                isSelect = true
                break
            }
        }
        
        if isSelect == true {
            self.performSegueWithIdentifier("toQuiz", sender:AppInstance.curThema.categories )
        } else {
            let alert = UIAlertController(title:"", message: "Rustig aan! Je moet wel wat aanvinken😀", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}
