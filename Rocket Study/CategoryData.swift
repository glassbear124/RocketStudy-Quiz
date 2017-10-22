//
//  CategoryData.swift
//  Rocket Study
//
//  Created by Admin on 8/12/16.
//  Copyright © 2016 roman. All rights reserved.
//

import Foundation

class CategoryData : NSObject {
    var name:String = ""
    var isSelected:Bool = false
//    var index:Int = -1
    
    var quizDB:[QuizData] = [QuizData]()
    var tmpArray:[QuizData] = [QuizData]()
    
    var selectedQuiz : Int = 0
    
    func shuffleQuiz() {

        selectedQuiz = 0
        tmpArray.removeAll()
        for quiz in quizDB {
            quiz.isUsed = false
            tmpArray.append(quiz)
        }
        
        quizDB.removeAll()
        while( tmpArray.count > 0 ) {
            let ix = Int(arc4random_uniform(UInt32(tmpArray.count)))
            quizDB.append(tmpArray[ix])
            tmpArray.removeAtIndex(ix)
        }
    }
}