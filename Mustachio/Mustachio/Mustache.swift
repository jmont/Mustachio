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
            return renderVariable(vname, context: context).escapeHTML()
        case .UnescapedVariable(let uname):
            return renderVariable(uname, context: context)
        case .Section(let sname, let contents):
            return "unsupported"
        case .InvertedSection(let iname, let contents):
            return "unsupported"
        }
    }

    class func renderVariable(name: String, context: [String : ContextType]) -> String {
        var type = context[name]
        if type == nil {
            return ""
        }

        var result: String
        switch type! {
        case .Str(let s):
            result = s
        default:
            println("%@ - Unexpected type - Should not happen")
            result = ""
        }
        return result

    }

    class func toTags(template: String) -> [Tag] {
        var words = template.componentsSeparatedByString(" ")
        return words.map(toTag)
    }

    class func toTag(s: String) -> Tag {
        var maybeTag: Tag?
        if s.hasPrefix("{{{") {
            maybeTag = self.mkTagUnescapedVariable(s)
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

    class func mkTagUnescapedVariable(s: String) -> Tag? {
        let prefix = "{{{"
        let suffix = "}}}"
        if !s.hasPrefix(prefix) || !s.hasSuffix(suffix) {
            return nil
        }

        var name = Array(s).dropWhile({(char: Character) -> Bool in char == "{" }).takeWhile({(char: Character) -> Bool in char != "}" })
        return .UnescapedVariable(String(seq: name))
    }
}
