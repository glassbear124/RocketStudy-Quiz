//
//  ViewController.swift
//  Rocket Study
//
//  Created by Admin on 8/10/16.
//  Copyright © 2016 roman. All rights reserved.
//

import Foundation
import UIKit
import YYWebImage

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet var scrlView:UIScrollView!
    @IBOutlet var pageCtrl:UIPageControl!
    
    @IBOutlet var header: UIView!
    
    var indicator: UIActivityIndicatorView!
    
    var gallerys: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        var height:Int = 0
        if screenSize.height == 480 {
            height = 440
        } else if screenSize.height == 568  {
            height = 440
        } else if screenSize.height == 667 {
            height = 667
        } else { // if screenSize.height == 540 {
            height = 960
        }

        let date: NSDate = NSDate()
        
        for i in 1...3 {
            let url:String = "https://rocketstudy.herokuapp.com/\(i)_\(height).jpg?v=" + date.description.stringByReplacingOccurrencesOfString(" ", withString: "")
            gallerys.append(url)
        }
        
        let indicator = UIActivityIndicatorView(activityIndicatorStyle: .Gray)
        indicator.center = view.center
        indicator.hidesWhenStopped = true
        view.addSubview(indicator)
        indicator.startAnimating()

        // Do any additional setup after loading the view, typically from a nib.
        let logo = UIImage(named:"icon_rocket")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        pageCtrl.hidden = true
        
        var url:String = "https://rocketstudy.herokuapp.com/meta.txt?v=" + date.description
        url = url.stringByReplacingOccurrencesOfString(" ", withString: "")
        let messageURL = NSURL(string:url)
        let sharedSession = NSURLSession.sharedSession()
        
        let downloadTask: NSURLSessionDownloadTask = sharedSession.downloadTaskWithURL(messageURL!) { (location, response, error) in
            
            if (error == nil) {
                do {
                    let metaContents = try String(contentsOfURL: location!, encoding: NSUTF8StringEncoding)
                    let lineInfo = metaContents.componentsSeparatedByString("\n")
                    self.readMetaData(lineInfo)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                    
                    // download second file
                    var url:String = "https://rocketstudy.herokuapp.com/quiz.txt?v=" + date.description
                    url = url.stringByReplacingOccurrencesOfString(" ", withString: "")
                   
                    let messageURL1 = NSURL(string:url )
                    let sharedSession1 = NSURLSession.sharedSession()
                    
                    let downloadTask1: NSURLSessionDownloadTask = sharedSession1.downloadTaskWithURL(messageURL1!) { (location, response, error) in
                        
                        if (error == nil) {
                            do {
                                let metaContents = try String(contentsOfURL: location!, encoding: NSUTF8StringEncoding)
                                let lineInfo = metaContents.componentsSeparatedByString("\r\n")
                                self.readQuizData(lineInfo)
                                dispatch_async(dispatch_get_main_queue(), {
                                    indicator.stopAnimating()
                                })
                            }
                            catch {
                                print(error)
                            }
                        }
                    }
                    downloadTask1.resume()
                }
                catch {
                    print(error)
                }
            }
        }
        downloadTask.resume()
        

        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        let px = 1 / UIScreen.mainScreen().scale
        let frame = CGRectMake(0, header.frame.size.height-px, self.tableView.frame.size.width, px)
        let line: UIView = UIView(frame: frame)
        header.addSubview(line)
        line.backgroundColor = self.tableView.separatorColor
        
        NSTimer.scheduledTimerWithTimeInterval(2.5, target:self, selector: #selector(selectIteminCarousel), userInfo: nil, repeats: true)
        
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        let screenWidth = screenSize.width
        //        let screenHeight = screenSize.height
        
        scrlView.contentSize = CGSizeMake(screenWidth*3, 0);
        
        var x : CGFloat = 0
        for i in 0...2 {
            
            let imageView = UIImageView()
            imageView.frame = CGRectMake( x, -64, scrlView.frame.size.width, scrlView.frame.size.height)
            imageView.contentMode = UIViewContentMode.ScaleAspectFit
            let param:String = self.gallerys[i]
            imageView.yy_setImageWithURL(NSURL(string:param), options: .SetImageWithFadeAnimation)
            scrlView.addSubview(imageView);
            
            x += screenWidth
        }
    }
    
    func selectIteminCarousel()
    {
        if scrlView.contentOffset.x < scrlView.frame.size.width * 2  {
            scrlView.setContentOffset(CGPointMake(scrlView.contentOffset.x+scrlView.frame.size.width, scrlView.contentOffset.y), animated: true)
        }
        else {
            scrlView.setContentOffset(CGPointMake(0, scrlView.contentOffset.y), animated: true)
        }
    }
    
    func readQuizData( lines: [String] ) {
        
        for thema in AppInstance.themas {
            for category in thema.categories {
                category.quizDB.removeAll()
            }
        }
        
        for line in lines {
            if line.characters.count < 5 {
                continue
            }
            let quiz = QuizData()
            quiz.readQuiz(line)
            
            let thema = AppInstance.themas[quiz.thema-1]
            let category = thema.categories[quiz.category-1]
            
            category.quizDB.append(quiz)
        }
    }
    
    func readMetaData( lines: [String] ) {
        
        AppInstance.themas.removeAll()
        
        var isTitle : Bool = false
        var isDetail : Bool = false
        var isUrl : Bool = false
        var isComment : Bool = false
        
        for line in lines {

            if isTitle == false {
                let meta = MetaData()
                meta.title = line
                isTitle = true
                AppInstance.themas.append(meta)
                continue
            }
                
            if isTitle == true && isDetail == false {
                AppInstance.themas.last?.detail = line
                isDetail = true
                continue
            }
                
            if isDetail == true && isTitle == true && isUrl == false {
                let date:NSDate = NSDate()
                let param:String = date.description.stringByReplacingOccurrencesOfString(" ", withString: "")
                AppInstance.themas.last?.url = line + "?v=" + param
                isUrl = true
                continue
            }
            
            if isDetail == true && isTitle == true && isComment == false {
                AppInstance.themas.last?.comment = line
                isComment = true
                continue
            }
            
            if line == "#" {
                isTitle = false
                isDetail = false
                isUrl = false
                isComment = false
                continue
            }
            
            let cd = CategoryData()
            cd.name = line
            AppInstance.themas.last?.categories.append(cd)
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        self.navigationItem.title = ""
        
        if segue.identifier == "toSubCategory" {
//            let subVC = segue.destinationViewController as! SubCategoryViewController
            
            let indexPath = self.tableView.indexPathForSelectedRow
            AppInstance.curThema = AppInstance.themas[indexPath!.row]
        }
    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AppInstance.themas.count;
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "Cell"
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier)!

        let imageView = cell.viewWithTag(200) as? UIImageView
        
        let meta = AppInstance.themas[indexPath.row]
        
        
        imageView?.contentMode = UIViewContentMode.ScaleAspectFill
        imageView?.yy_setImageWithURL(NSURL(string: meta.url), options: .SetImageWithFadeAnimation)
        
        let title = cell.viewWithTag(201) as? UILabel
        title!.text = meta.title
        
       let subLabel = cell.viewWithTag(202) as? UILabel
       subLabel!.text = meta.detail
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    @IBAction func shareButtonPress(sender: UIBarButtonItem) {
        let textToShare = "Hey! Deze app is echt relaxt! Je kunt tentamens oefenen voor allerlei vakken op hbo niveau. Nog gratis ook!\n\nhttps://itunes.apple.com/us/app/rocket-study/id1146160150?ls=1&mt=8"
        
        let objectsToShare = [textToShare]
        let activityVC = UIActivityViewController(activityItems: objectsToShare, applicationActivities: nil)
        
        activityVC.popoverPresentationController?.sourceView = self.view
        self.presentViewController(activityVC, animated: true, completion: nil)
   }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

