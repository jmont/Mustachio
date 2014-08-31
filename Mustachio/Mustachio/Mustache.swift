//
//  Mustache.swift
//  Mustachio
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

import Foundation

public class Mustache {
    public class func render(template: String, context: [String : ContextType]) -> String {
        var tags = self.toTags(template)
        var rendered = tags.map(self.renderTag(context))

        return rendered.combine(" ")
    }

    class func renderTag(context: [String : ContextType])(t: Tag) -> String {
        switch t {
        case .Str(let sname):
            return sname

        case .Variable(let vname):
            var type = context[vname]
            if type == nil {
                return "NIL TYPE"
            }

            var result: String
            switch type! {
            case .Str(let s):
                result = s
            default:
                result = "unsupported"
            }
            return result

        case .UnescapedVariable(let uname):
            return "unsupported"
        case .Section(let sname, let contents):
            return "unsupported"
        case .InvertedSection(let iname, let contents):
            return "unsupported"
        }
    }

    class func toTags(template: String) -> [Tag] {
        var words = template.componentsSeparatedByString(" ")
        return words.map(toTag)
    }

    class func toTag(s: String) -> Tag {
        var maybeTag: Tag?
        if s.hasPrefix("{{{") {
            maybeTag = .UnescapedVariable("")
        } else if s.hasPrefix("{{#") {
            maybeTag = .Section("", "")
        } else if s.hasPrefix("{{^") {
            maybeTag = .InvertedSection("","")
        } else if s.hasPrefix("{{") {
            maybeTag = self.mkTagVariable(s)
        }

        return maybeTag ?? .Str(s)
    }

    class func mkTagVariable(s: String) -> Tag? {
        if !s.hasPrefix("{{") || !s.hasSuffix("}}") {
            return nil
        }

        var name = Array(s).dropWhile({(char: Character) -> Bool in char == "{" }).takeWhile({(char: Character) -> Bool in char != "}" })
        return .Variable(String(seq: name))
    }
}
