// github.com/ccorn90/Spec

import Nimble
import XCTest

open class Spec: XCTestCase, Nimble.AssertionHandler {
    private var test : [String] = []
    private var function: String?
    private var logString : String = ""
    private var beforeBlock: ((Void) -> Void)?
    private var afterBlock: ((Void) -> Void)?


    // MARK: Fail the test at a specific line:
    private func fail(messages: [String], _ file: String, _ line: UInt, _ expected: Bool) {
        let testString = self.test.reduce("") { $0.0 + " " + $0.1 }
        self.continueAfterFailure = true
        self.recordFailure(withDescription: testString, inFile: file, atLine: line, expected: expected)
        let allMessages = messages.reduce("") { $0 + "\n\t" + $1 }
        self.log("\(testString)\(allMessages)", file: file, line: line)
    }

    public func assert(_ assertion: Bool, message: Nimble.FailureMessage, location: Nimble.SourceLocation) {
      if !assertion {
        fail(messages: [message.stringValue], location.file.description, location.line, true)
      }
    }

    // MARK: Echo information during the test if verbose is set to true
    public var verbose = false
    public func log(_ s: @autoclosure () -> String, file: String = #file, line: UInt = #line) {
        let str = s()
        self.logString += "line \(line) :" + str + "\n\n"
        if(self.verbose) {
            print("****** \(file) -- \(line) : \(str)")
        }
    }

    // The Nimble matcher framework calls on an assertion handler.  Set it as
    // self for now:
    private var cachedAssertionHandler: Nimble.AssertionHandler!
    open override func setUp() {
      cachedAssertionHandler = NimbleAssertionHandler
      NimbleAssertionHandler = self
    }

    // This is overridden from XCTest.  It's called at the end of every method.
    open override func tearDown() {
        var str = ""
        str += "\n\n"
        str += "****************************************************************************\n"
        str += "\(#file)\nSummary of call to \(self.function ?? "")\n\n\(self.logString)\n"
        str += "End of summary for call to \(self.function ?? "")\n"
        str += "****************************************************************************\n"
        str += "\n\n"

        if self.logString.characters.count > 0 { print(str) }

        self.logString = ""
        self.test = []
        NimbleAssertionHandler = cachedAssertionHandler
    }

    // MARK: Helpers for more rspec-like tests
    public func describe(_ msg: String, file: String = #file, line: UInt = #line, function: String = #function, block: (Void) -> Void) {
        self.test += [msg]
        block()
        self.test = Array(self.test.dropLast(1))
    }

    public func it(_ msg: String, file: String = #file, line: UInt = #line, function: String = #function, block: (Void) -> Void ) {
        self.test += ["it \(msg)"]
        self.function = function

        self.before()
        if self.beforeBlock != nil { self.beforeBlock!() }

        block()

        if self.afterBlock != nil { self.afterBlock!() }
        self.after()
        self.test = Array(self.test.dropLast(1))
    }

    // This is run before every it() -- override to set up or configure
    open func before() { }

    // Call this to set the before block
    public func before(file: String = #file, line: UInt = #line, block: @escaping (Void) -> Void) {
        self.beforeBlock = block
    }

    // Call this to set the before block
    public func after(file: String = #file, line: UInt = #line, block: @escaping (Void) -> Void) {
        self.afterBlock = block
    }

    // This is run after every it() -- override to tear down or reset
    open func after() { }

}

