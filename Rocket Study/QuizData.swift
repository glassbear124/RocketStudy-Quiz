//
//  QuizData.swift
//  Rocket Study
//
//  Created by Admin on 8/13/16.
//  Copyright © 2016 roman. All rights reserved.
//

import Foundation

class QuizData : NSObject {
    
    var thema:Int = -1
    var category:Int = -1
    
    var quiz:String = ""
    
    var answers:[String] = ["", "", "", ""]
    
    var nOK:Int = -1
    var nAnsCnt:Int = 0;
    
    var nIx:Int = 0
    
    var nSel:Int = -1
    
    var isUsed : Bool = false
    
    func shuffleAnswer() {
        
        var tmpArr = [AnyObject]()
        var okStr : String = ""
        for i in 0...nAnsCnt-1 {
            tmpArr.append(answers[i])
            if i + 1 == nOK {
                okStr = answers[i]
            }
        }
        
        answers.removeAll()
        while (tmpArr.count > 0) {
            let index = Int(arc4random_uniform(UInt32(tmpArr.count)))
            answers.append(tmpArr[index] as! String)
            tmpArr.removeAtIndex(index)
        }
        
        for i in 0...nAnsCnt-1 {
            if okStr == answers[i] {
                nOK = i+1
            }
        }
    }
    
    func readQuiz( line : String ) {
        
        let quizInfo = line.componentsSeparatedByString("\t")
        
        self.nIx = Int(quizInfo[0])!
        self.thema = Int(quizInfo[1])!
        self.category = Int(quizInfo[2])!
        
        self.quiz = quizInfo[3]
        
        if quizInfo[4] != "" {
            self.answers[0] = quizInfo[4]
            nAnsCnt+=1
        }
        
        if quizInfo[5] != "" {
            self.answers[1] = quizInfo[5]
            nAnsCnt+=1
        }
        
        if quizInfo[6] != "" {
            self.answers[2] = quizInfo[6]
            nAnsCnt+=1
        }
        
        if quizInfo[7] != "" {
            self.answers[3] = quizInfo[7]
            nAnsCnt += 1
        }
        
        let trimmedString = quizInfo[8].stringByTrimmingCharactersInSet(
            NSCharacterSet.newlineCharacterSet()
        )
        self.nOK = Int(trimmedString)!
        
    }
}