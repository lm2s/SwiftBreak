//
//  SwiftBreakTests.swift
//  SwiftBreakTests
//
//  Created by Luís Silva on 24/11/2020.
//

import XCTest
@testable import SwiftBreak

class SwiftBreakTests: XCTestCase {
    
    func testCallSimple() throws {
        let code = """
        f(a: 0, b: 1)
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "f(",
            "a: 0,",
            "b: 1",
            ")"
        ]

        XCTAssert(comps == expected)
    }

    func testCallWithClosure1() throws {
        let code = """
        f(a: 0, b: 1, completion: { xy in
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "f(",
            "a: 0,",
            "b: 1,",
            "completion: { xy in"
        ]

        XCTAssert(comps == expected)
    }

    func testCallWithClosure2() throws {
        let code = """
        f(a: 0, b: 1) { xy in
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "f(",
            "a: 0,",
            "b: 1",
            ") { xy in"
        ]

        XCTAssert(comps == expected)
    }

    func testGuardAssignment() throws {
        let code = """
        guard let x = f(a: 0, b: 1) else { return }
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "guard let x = f(",
            "a: 0,",
            "b: 1",
            ") else { return }"
        ]

        XCTAssert(comps == expected)
    }

    func testLetAssignment() throws {
        let code = """
        let x = f(a: 0, b: 1)
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "let x = f(",
            "a: 0,",
            "b: 1",
            ")"
        ]

        XCTAssert(comps == expected)
    }

    func testVarAssignment() throws {
        let code = """
        var x = f(a: 0, b: 1)
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "var x = f(",
            "a: 0,",
            "b: 1",
            ")"
        ]

        XCTAssert(comps == expected)
    }

    func testEmptyDeclaration() throws {
        let code = """
        func f() -> Void {
        """

        let comps = LineBreaker.components(textLine: code)

        let expected: [String] = []

        XCTAssert(comps == expected)
    }

    func testMalformedEmptyDeclaration() throws {
        let code = """
        func f(  ) -> Void {
        """

        let comps = LineBreaker.components(textLine: code)

        let expected: [String] = []

        XCTAssert(comps == expected)
    }

    func testDeclaration() throws {
        let code = """
        func f(a: Int, b: Int) -> Void {
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "func f(",
            "a: Int,",
            "b: Int",
            ") -> Void {"
        ]

        XCTAssert(comps == expected)
    }

    func testDeclarationWithClosure() throws {
        let code = """
        func f(a: Int, b: Int, closure: (() -> Void)) -> Void {
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "func f(",
            "a: Int,",
            "b: Int,",
            "closure: (() -> Void)",
            ") -> Void {"
        ]

        XCTAssert(comps == expected)
    }

    func testDeclarationWithComplexClosure() throws {
        let code = """
        func f(a: Int, b: Int, closure: ((_ x: Double, y: Double) -> String)?) -> Void {
        """

        let comps = LineBreaker.components(textLine: code)

        let expected = [
            "func f(",
            "a: Int,",
            "b: Int,",
            "closure: ((_ x: Double, y: Double) -> String)?",
            ") -> Void {"
        ]

        XCTAssert(comps == expected)
    }
}
