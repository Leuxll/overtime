//
//  User.swift
//  Overtime
//
//  Created by YFL on 20/6/2020.
//  Copyright © 2020 YFL. All rights reserved.
//

import Foundation

//Structure within array that contains users data
struct User {
    
    private(set) var firstName: String?
    private(set) var lastName: String?
    private(set) var points: Int!
    private(set) var questionsAnswered: Int!
    
}

struct History {
    
    private(set) var quizInfo: String?
    private(set) var score: String?
    
    
}
