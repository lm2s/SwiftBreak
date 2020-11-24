//
//  LineBreaker.swift
//  SwiftBreakExtension
//
//  Created by Luís Silva on 23/11/2020.
//

import Foundation

class LineBreaker {
    static let regularExpression = try? NSRegularExpression(pattern: "(\\blet .+ = )|(\\bvar .+ = )", options: [])

    static func components(textLine: String) -> [String] {

        var maybeFirstParenthesisIndex: String.Index?

        let regularExpressionMatch = regularExpression?.firstMatch(in: textLine, options: [], range: NSRange(location: 0, length: textLine.utf8.count))

        if let match = regularExpressionMatch {
            let attStatementEndIndex = textLine.index(textLine.startIndex, offsetBy: match.range.location + match.range.length)

            if let index = textLine[attStatementEndIndex..<textLine.endIndex].firstIndex(of: "(") {
                let distanceToAttr = textLine.distance(from: textLine.startIndex, to: attStatementEndIndex)
                let distanceToParen = textLine.distance(from: attStatementEndIndex, to: index)

                maybeFirstParenthesisIndex = textLine.index(textLine.startIndex, offsetBy: distanceToAttr + distanceToParen)
            }
        }
        else {
            maybeFirstParenthesisIndex = textLine.firstIndex(of: "(")
        }

        guard let firstParenthesisIndex = maybeFirstParenthesisIndex else { return [] }

        let searchStartIndex = textLine.index(firstParenthesisIndex, offsetBy: 1)

        var parenthesesLevel = 1
        var isInsideStringDefinition = false
        var isEscapingString = false

        var componentsRanges: [Range<String.Index>] = []

        componentsRanges.append(textLine.startIndex..<searchStartIndex)

        var lastUpperBound = searchStartIndex

        for (i, c) in textLine[searchStartIndex..<textLine.endIndex].enumerated() {

            if c == "(" {
                parenthesesLevel += 1
            }
            else if c == ")" {
                parenthesesLevel -= 1
            }

            if c == "\"" && !isEscapingString {
                if isInsideStringDefinition {
                    isInsideStringDefinition = false
                }
                else {
                    isInsideStringDefinition = true
                }
            }

            if c == "," && parenthesesLevel == 1 && !isInsideStringDefinition {
                let newRange = lastUpperBound..<textLine.index(searchStartIndex, offsetBy: i+1)

                componentsRanges.append(newRange)

                lastUpperBound = newRange.upperBound
            }

            if c == ")" && parenthesesLevel == 0 {
                let newRange = lastUpperBound..<textLine.index(searchStartIndex, offsetBy: i)
                componentsRanges.append(newRange)

                lastUpperBound = newRange.upperBound
            }

            isEscapingString = c == "\\"
        }

        componentsRanges.append(lastUpperBound..<textLine.endIndex)

        guard componentsRanges.first?.upperBound != componentsRanges.last?.lowerBound else {
            return []
        }

        let components: [String] = componentsRanges.map { textLine[$0.lowerBound..<$0.upperBound].trimmingCharacters(in: .whitespaces) }.map { .init($0) }

        return components
    }
}

class Helper {
    enum IndentationType {
        case spaces
        case tabs
    }

    private init() { }

    static func parameterIndentation(line: String, indentationWidth: Int, usesTabsForIndentation: Bool) -> String {
        switch detectTabsOrSpaces(line: line, usesTabsForIndentation: usesTabsForIndentation) {
        case .spaces:
            let indentation = line.prefix(while: \.isWhitespace).count
            return String(repeating: " ", count: indentation + indentationWidth)

        case .tabs:
            let indentation = line.prefix(while: {$0 == "\t"}).count
            return String(repeating: "\t", count: indentation + 1)
        }
    }

    static func functionIndentation(line: String, usesTabsForIndentation: Bool) -> String {
        switch detectTabsOrSpaces(line: line, usesTabsForIndentation: usesTabsForIndentation) {
        case .spaces:
            let indentation = line.prefix(while: \.isWhitespace).count
            return String(repeating: " ", count: indentation)

        case .tabs:
            let indentation = line.prefix(while: {$0 == "\t"}).count
            return String(repeating: "\t", count: indentation)
        }
    }

    static func detectTabsOrSpaces(line: String, usesTabsForIndentation: Bool) -> IndentationType {
        var detectedType: IndentationType?

        let tabsCount = line.prefix(while: {$0 == "\t"}).count
        if 0 < tabsCount {
            detectedType = .tabs
        }

        let spacesCount = line.prefix(while: \.isWhitespace).count
        if 0 < spacesCount {
            detectedType = .spaces
        }

        if let type = detectedType, UserDefaultsConfig.automaticallyDetectIndentationStyle {
            return type
        }

        return usesTabsForIndentation ? .tabs : .spaces
    }
}
