//
//  Tags.swift
//  Mustachio
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

import Foundation

public enum ContextType {
    case Str (String)
    case Dict ([String : Tag])
    case List ([Tag])
    case True
    case False
}

public func == (lhs: ContextType, rhs: ContextType) -> Bool {
    switch (lhs, rhs) {
    case (.Str (let s1), .Str (let s2)):
        return s1 == s2
    case (.Dict (let d1), .Dict (let d2)):
        return d1 == d2
    case (.List (let l1), .List (let l2)):
        return l1.count == l2.count && l1 == l2
    case (.True, .True):
        return true
    case (.False, .False):
        return true
    default:
        return false
    }
}

public enum Tag : Equatable {
    case Str (String)
    case Variable (String)
    case UnescapedVariable (String)
    case Section (String, ContextType)
    case InvertedSection (String, String)
}

public func == (lhs: Tag, rhs: Tag) -> Bool {
    switch (lhs, rhs) {
    case (.Str (let s1), .Str (let s2)):
        return s1 == s2

    case (.Variable (let v1), .Variable (let v2)):
        return v1 == v2

    case (.UnescapedVariable (let u1), .UnescapedVariable (let u2)):
        return u1 == u2

    case (.Section (let s1, let c1), .Section (let s2, let c2)):
        return s1 == s2 && c1 == c2

    case (.InvertedSection (let s1, let c1), .InvertedSection (let s2, let c2)):
        return s1 == s2 && c1 == c2

    default:
        return false
    }
}
