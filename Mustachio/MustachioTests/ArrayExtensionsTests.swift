//
//  ArrayExtensionsTests.swift
//  Mustachio
//
//  Created by Montemayor Elosua, Juan Carlos on 8/31/14.
//  Copyright (c) 2014 jmont. All rights reserved.
//

import UIKit
import XCTest
import Mustachio

class ArrayExtensionTests: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testDropWhile() {
        var resultArray = Array("{{name}}").dropWhile({(char: Character) -> Bool in char == "{" })
        var result = String(seq: resultArray)
        XCTAssertEqual(result, "name}}")
    }

    func testTrimWhitespace() {
        var result = "  all this whitespace     ".trimWhitespace()
        XCTAssertEqual(result, "all this whitespace")
    }
}
