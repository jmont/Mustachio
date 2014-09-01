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
            var didScan = self.scanUnescapedVariable(scanner, resultTag: &parsedTag) ||
                          self.scanAlternateUnescapedVariable(scanner, resultTag: &parsedTag) ||
                          self.scanSection(scanner, resultTag: &parsedTag) ||
                          self.scanVariable(scanner, resultTag: &parsedTag) ||
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


    class func scanVariable(scanner: NSScanner, inout resultTag: Tag?) -> Bool {
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

    class func scanUnescapedVariable(scanner: NSScanner, inout resultTag: Tag?) -> Bool {
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

    class func scanAlternateUnescapedVariable(scanner: NSScanner, inout resultTag: Tag?) -> Bool {
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

    class func scanSection(scanner: NSScanner, inout resultTag: Tag?) -> Bool {
        var maybeName: NSString?
        var didScanHead = scanner.scanString("{{#", intoString: nil) &&
                          scanner.scanCharactersFromSet(self.allowedChars(), intoString: &maybeName) &&
                          scanner.scanString("}}", intoString: nil)

        if !didScanHead || maybeName == nil || maybeName!.length == 0 {
            return false
        }
        var name: String = maybeName! as String!
        var status = scanner.string

        var contents: NSString?
        scanner.scanCharactersFromSet(self.allowedChars(), intoString: &contents)

        var didScanTail = scanner.scanString("{{/", intoString: nil) &&
                          scanner.scanString(name, intoString: nil) &&
                          scanner.scanString("}}", intoString: nil)

        var didScan = didScanHead && didScanTail
        if didScan {
            var tempContents: ContextType = ContextType.List([Tag.Str(contents ?? "")])
            resultTag = Tag.Section(name.trimWhitespace(), tempContents)
            return true
        }
        return false
    }
}
