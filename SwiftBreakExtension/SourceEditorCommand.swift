//
//  SourceEditorCommand.swift
//  SwiftBreakExtension
//
//  Created by Luís Silva on 19/11/2020.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    enum Constants {
        static let supportedUTIs = [ // Thank You X-SwiftFormat (https://github.com/ruiaureliano/X-SwiftFormat)
            "public.swift-source",
            "com.apple.dt.playground",
            "com.apple.dt.playgroundpage",
            "com.apple.dt.swiftpm-package-manifest",
        ]
    }

    enum MyError: Error, CustomStringConvertible {
        case castingError
        case couldntFindParentheses
        case noParameters
        case unsupportedFileType

        var description: String {
            switch self {
            case .castingError: return "Internal error"
            case .couldntFindParentheses: return "Couldn't find parentheses"
            case .noParameters: return "No parameters to split"
            case .unsupportedFileType: return "Unsupported file type"
            }
        }

        var asNSError: NSError {
            return NSError(domain: "co.hellobit.ParamSplit", code: 0, userInfo: [NSLocalizedDescriptionKey: description])
        }
    }

    // MARK: - Methods
    
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
        guard Self.Constants.supportedUTIs.contains(invocation.buffer.contentUTI) else {
            return completionHandler(errorToDisplay(.unsupportedFileType))
        }

        guard let selections = invocation.buffer.selections as? [XCSourceTextRange] else {
            completionHandler(errorToDisplay(.castingError))
            return
        }

        guard var lines = invocation.buffer.lines as? [String] else {
            completionHandler(errorToDisplay(.castingError))
            return
        }

        var maybeError: MyError?
        var bufferChanged: Bool = false

        for selection in selections {
            let line = lines[selection.start.line]

            let processResult = processLine(line: line, indentationWidth: invocation.buffer.indentationWidth, usesTabsForIndentation: invocation.buffer.usesTabsForIndentation)

            switch processResult {
            case let .success(newLines):
                bufferChanged = true
                lines.remove(at: selection.start.line)
                lines.insert(contentsOf: newLines, at: selection.start.line)

            case let .failure(error):
                maybeError = error
                break
            }
        }

        if let error = maybeError {
            completionHandler(errorToDisplay(error))

            return
        }

        if bufferChanged {
            invocation.buffer.lines.setArray(lines)
        }

        completionHandler(nil)
    }

    private func processLine(line: String, indentationWidth: Int, usesTabsForIndentation: Bool) -> Result<[String], MyError> {

        let functionIndent = Helper.functionIndentation(
            line: line,
            usesTabsForIndentation: usesTabsForIndentation
        )

        let parameterIndent = Helper.parameterIndentation(
            line: line,
            indentationWidth: indentationWidth,
            usesTabsForIndentation: usesTabsForIndentation
        )

        let comps = LineBreaker.components(textLine: line)

        guard 2 < comps.count else {
            return .failure(.noParameters)
        }

        guard let firstLine = comps.first, let lastLine = comps.last else {
            return .failure(.noParameters)
        }

        var lines: [String] = ["\(functionIndent)\(firstLine)"]

        let innerComps = comps[1..<comps.count-1]

        innerComps.enumerated().forEach {

            let element = $0.element.trimmingCharacters(in: .whitespaces)

            let parameter = "\(parameterIndent)\(element)"

            lines.append("\(parameter)")
        }

        lines.append(String("\(functionIndent)\(lastLine)"))

        return .success(lines)

    }

    private func errorToDisplay(_ error: MyError) -> NSError? {
        switch error {
        case .noParameters:
            return UserDefaultsConfig.displayMissingParametersError ? error.asNSError : nil

        case .couldntFindParentheses:
            return UserDefaultsConfig.displayMissingParenthesesError ? error.asNSError : nil

        case .unsupportedFileType:
            return UserDefaultsConfig.displayOtherErrors ? error.asNSError : nil

        case .castingError:
            return UserDefaultsConfig.displayOtherErrors ? error.asNSError : nil
        }
    }
}
