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
        var tags: [Tag] = Parser.parse(template)
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
            return renderSection(sname, contents: contents, context: context)
        case .InvertedSection(let iname, let contents):
            return renderInvertedSection(iname, contents: contents, context: context)
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

    class func renderSection(sectionName: String, contents: ContextType, context: [String : ContextType]) -> String {
        var maybeSectionContext: ContextType? = context[sectionName]
        if maybeSectionContext == nil {
            return ""
        }

        var sectionContext: [String : ContextType] = Dictionary<String, ContextType>()
        switch maybeSectionContext! {
        case .Dict(let c):
            sectionContext = c
        default:
            println("%@ - Unexpected content type - Should not happen")
        }

        var sectionContent: Array<Tag>?
        switch contents {
        case .List (let list):
            sectionContent = list
        default:
            println("%@ - Unexpected content type - Should not happen")
        }

        var newContext = context
        newContext += sectionContext

        return sectionContent?.map(renderTag(newContext)).reduce("", +) ?? ""
    }

    class func renderInvertedSection(sectionName: String, contents: ContextType, context: [String : ContextType]) -> String {
        var maybeSectionContext: ContextType? = context[sectionName]
        if maybeSectionContext != nil {
            return ""
        }

        var sectionContent: Array<Tag>?
        switch contents {
        case .List (let list):
            sectionContent = list
        default:
            println("%@ - Unexpected content type - Should not happen")
        }

        return sectionContent?.map(renderTag(context)).reduce("", +) ?? ""
    }
}
