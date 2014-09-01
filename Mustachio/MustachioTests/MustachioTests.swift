//
//  MustachioTests.swift
//  MustachioTests
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

import UIKit
import XCTest
import Mustachio

class MustachioTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testVariable() {
        var result = Mustache.render("{{name}}", context: ["name" : ContextType.Str("JC")])
        XCTAssertEqual(result, "JC")
    }

    func testVariableWithHTML() {
        var result = Mustache.render("{{name}}", context: ["name" : ContextType.Str("<b>JC</b>")])
        XCTAssertEqual(result, "&lt;b&gt;JC&lt;/b&gt;")
    }

    func testUnescapedVariableWithNoHTML() {
        var result = Mustache.render("{{{name}}}", context: ["name" : ContextType.Str("JC")])
        XCTAssertEqual(result, "JC")
    }

    func testUnescapedVariableWithHTML() {
        var result = Mustache.render("{{{name}}}", context: ["name" : ContextType.Str("<b>JC</b>")])
        XCTAssertEqual(result, "<b>JC</b>")
    }

    func testAlternateUnescapedVariableWithNoHTML() {
        var result = Mustache.render("{{&name}}", context: ["name" : ContextType.Str("JC")])
        XCTAssertEqual(result, "JC")
    }

    func testAlternateUnescapedVariableWithHTML() {
        var result = Mustache.render("{{&name}}", context: ["name" : ContextType.Str("<b>JC</b>")])
        XCTAssertEqual(result, "<b>JC</b>")
    }

    func testMiss() {
        var result = Mustache.render("{{{nope}}}", context: ["name" : ContextType.Str("<b>JC</b>")])
        XCTAssertEqual(result, "")
    }

    func testSection() {
        var result = Mustache.render("{{#aSection}} Text here {{/aSection}}", context: ["aSection" : ContextType.Dict(["name" : ContextType.Str("JC")])])
        XCTAssertEqual(result, "Text here ")
    }

    func testNoSection() {
        var result = Mustache.render("{{#aSection}} Text here {{/aSection}}", context: ["name" : ContextType.Str("JC")])
        XCTAssertEqual(result, "")
    }

    func testInvertedSection() {
        var result = Mustache.render("{{^aSection}} Text here {{/aSection}}", context: ["aSection" : ContextType.Dict(["name" : ContextType.Str("JC")])])
        XCTAssertEqual(result, "")
    }

    func testInvertedNoSection() {
        var result = Mustache.render("{{^aSection}} There was a problem {{/aSection}}", context: ["name" : ContextType.Str("JC")])
        XCTAssertEqual(result, "There was a problem ")
    }

//    func testWhitespaceInNames() {
//        var result = Mustache.render("Hello {{    name   }}", context: ["name" : ContextType.Str("JC")])
//        XCTAssertEqual(result, "Hello JC")
//    }
}
