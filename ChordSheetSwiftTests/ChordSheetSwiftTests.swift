//
//  ChordSheetSwiftTests.swift
//  ChordSheetSwiftTests
//
//  Created by Stephen O'Connor on 05.06.21.
//

import XCTest
@testable import ChordSheetSwift

enum TestError: Error {
    case failedLoadingResource
}

class ChordSheetSwiftTests: XCTestCase {

    var chordSheet: ChordSheet!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        chordSheet = ChordSheet()
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testParsing() throws {
        guard let url = Bundle(for: ChordSheetSwiftTests.self).url(forResource: "TestSong.txt", withExtension: nil) else {
            throw TestError.failedLoadingResource
        }
        
        let contents = try String(contentsOf: url)
        
        let expectation = self.expectation(description: "Parsing completes")
        
        chordSheet.parseChordSheetToHTML(textFileContents: contents) { result in
            switch result {
            case .failure(let error):
                XCTFail("Parsing failed.  Details: \(String(describing: error))")
            case .success(let html):
                print(html)
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testCSSTemplateWithNoScope() throws {
        
        let expectation = self.expectation(description: "Method completes")
        chordSheet.getCSSTemplate(with: nil) { result in
            
            switch result {
            case .failure(let error):
                XCTFail("Parsing failed.  Details: \(String(describing: error))")
            case .success(let css):
                print(css)
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
    
    func testCSSTemplateWithScope() throws {
        
        let expectation = self.expectation(description: "Method completes")
        chordSheet.getCSSTemplate(with: "songbook") { result in
            
            switch result {
            case .failure(let error):
                XCTFail("Parsing failed.  Details: \(String(describing: error))")
            case .success(let css):
                print(css)
            }
            expectation.fulfill()
        }
        self.wait(for: [expectation], timeout: 5)
    }
}
