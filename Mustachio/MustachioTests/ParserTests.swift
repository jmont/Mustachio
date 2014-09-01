//
//  ParserTests.swift
//  Mustachio
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

import UIKit
import XCTest
import Mustachio

class ParserTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testVariableParser() {
        var result = Parser.parse("{{name}}")
        XCTAssertEqual(result, [Tag.Variable("name")])
    }

    func testStringParser() {
        var result = Parser.parse("Hello")
        XCTAssertEqual(result, [Tag.Str("Hello")])
    }

    func testMultiplesParser() {
        var result = Parser.parse("Hello {{name}}")
        XCTAssertEqual(result, [Tag.Str("Hello "), Tag.Variable("name")])
    }

    func testAltUnescapedVarParserWithVarNameSpaces() {
        var result = Parser.parse("Hello {{& name}}")
        XCTAssertEqual(result, [Tag.Str("Hello "), Tag.UnescapedVariable("name")])
    }

    func testAltUnescapedVarParserWithCrazyVarNameSpaces() {
        var result = Parser.parse("Hello {{& name    }}")
        XCTAssertEqual(result, [Tag.Str("Hello "), Tag.UnescapedVariable("name")])
    }

    func testParserWithVarNameSpaces() {
        var result = Parser.parse("Hello {{name    }}")
        XCTAssertEqual(result, [Tag.Str("Hello "), Tag.Variable("name")])
    }

    func testSectionParserSimple() {
        var result = Parser.parse("{{#section}}Some text{{/section}}")
        XCTAssertEqual(result, [Tag.Section("section", ContextType.List([Tag.Str("Some text")]))])
    }
}
