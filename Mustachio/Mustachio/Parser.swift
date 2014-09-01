//
//  Parser.swift
//  Mustachio
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

import Foundation

public class Parser {
    class func allowedChars() -> NSCharacterSet {
        return NSCharacterSet(charactersInString: "{}").invertedSet
    }

    public class func parse(template: String) -> [Tag] {
        var scanner = NSScanner(string: template)
        var results = Array<Tag>()
        while !scanner.atEnd {
            var parsedTag: Tag?
            var didScan = self.scanUnescapedVariableName(scanner, resultTag: &parsedTag) ||
                          self.scanAlternateUnescapedVariableName(scanner, resultTag: &parsedTag) ||
                          self.scanVariableName(scanner, resultTag: &parsedTag) ||
                          self.scanText(scanner, resultTag: &parsedTag)

            if didScan && parsedTag != nil {
                results.append(parsedTag!)
            }
        }
        return results
    }

    class func scanText(scanner: NSScanner, inout resultTag: Tag?) -> Bool {
        var text: NSString?
        var didScan = scanner.scanCharactersFromSet(self.allowedChars(), intoString: &text)

        if didScan && text != nil {
            var str: String = text! as String!
            resultTag = Tag.Str(str) // Don't trim whitespace!
            return true
        }
        return false
    }


    class func scanVariableName(scanner: NSScanner, inout resultTag: Tag?) -> Bool {
        var name: NSString?
        var didScan = scanner.scanString("{{", intoString: nil) &&
            scanner.scanCharactersFromSet(self.allowedChars(), intoString: &name) &&
            scanner.scanString("}}", intoString: nil)

        if didScan && name != nil {
            var str: String = name! as String!
            resultTag = Tag.Variable(str.trimWhitespace())
            return true
        }
        return false
    }

    class func scanUnescapedVariableName(scanner: NSScanner, inout resultTag: Tag?) -> Bool {
        var name: NSString?
        var didScan = scanner.scanString("{{{", intoString: nil) &&
            scanner.scanCharactersFromSet(self.allowedChars(), intoString: &name) &&
            scanner.scanString("}}}", intoString: nil)

        if didScan && name != nil {
            var str: String = name! as String!
            resultTag = Tag.UnescapedVariable(str.trimWhitespace())
            return true
        }
        return false
    }

    class func scanAlternateUnescapedVariableName(scanner: NSScanner, inout resultTag: Tag?) -> Bool {
        var name: NSString?
        var didScan = scanner.scanString("{{&", intoString: nil) &&
            scanner.scanCharactersFromSet(self.allowedChars(), intoString: &name) &&
            scanner.scanString("}}", intoString: nil)

        if didScan && name != nil {
            var str: String = name! as String!
            resultTag = Tag.UnescapedVariable(str.trimWhitespace())
            return true
        }
        return false
    }
}
