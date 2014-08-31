//
//  Tags.swift
//  Mustachio
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

enum Tag {
    case Str (String)
    case Variable (String)
    case UnescapedVariable (String)
    case Section (String, String)
    case InvertedSection (String, String)
}

public enum ContextType {
    case Str (String)
    case Dict (Dictionary<String, ContextType>)
    case List (Array<ContextType>)
    case True
    case False
}
