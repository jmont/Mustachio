//
//  Parser.swift
//  Mustachio
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

import Foundation

public class Parser {
    public class func parse(template: String) -> [Tag] {
        return self.toTags(template)
    }

    class func toTags(template: String) -> [Tag] {
        var words = template.componentsSeparatedByString(" ")
        return words.map(toTag)
    }

    class func toTag(s: String) -> Tag {
        var maybeTag: Tag?
        if s.hasPrefix("{{{") || s.hasPrefix("{{&") {
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
        return .Variable(String(seq: name).trimWhitespace())
    }

    class func mkTagUnescapedVariable(s: String) -> Tag? {
        let prefix = "{{{"
        let suffix = "}}}"
        if !s.hasPrefix(prefix) || !s.hasSuffix(suffix) {
            // Try the alternate version (`{{& name }}`)
            return self.mkTagAlternateUnescapedVariable(s)
        }

        var nameArray = Array(s).dropWhile({(char: Character) -> Bool in char == "{" }).takeWhile({(char: Character) -> Bool in char != "}" })
        var name = String(seq: nameArray).trimWhitespace()
        return .UnescapedVariable(name)
    }

    class func mkTagAlternateUnescapedVariable(s: String) -> Tag? {
        let prefix = "{{&"
        let suffix = "}}"
        if !s.hasPrefix(prefix) || !s.hasSuffix(suffix) {
            return nil
        }

        var name = Array(s).dropWhile({(char: Character) -> Bool in char == "{" || char == "&" }).takeWhile({(char: Character) -> Bool in char != "}" })
        return .UnescapedVariable(String(seq: name).trimWhitespace())
    }
}