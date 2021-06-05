//
//  ExponentialCurveFitter.swift
//  Florio
//
//  Created by Stephen O'Connor (MHP) on 03.06.21.
//  Copyright © 2021 Florio GmbH. All rights reserved.
//
/**
 A Swift Wrapper for the ChordSheet.js javascript library, used to curve fit and predict values.
 
 // A bit of background:  https://nshipster.com/javascriptcore/
 // Also using this lib:  https://github.com/martijnversluis/ChordSheetJS
 
 Apparently, it's not straightforward to import a javascript module into Swift using JavaScriptCore.
 
 some background reading:
 https://stackoverflow.com/questions/48354804/how-to-import-modules-in-swifts-javascriptcore
 https://stackoverflow.com/questions/60214245/can-i-load-js-es6-modules-in-modern-swift-s-javascriptcore
 

 Then I discovered this:
 
 https://medium.com/the-smyth-group/how-to-use-npm-packages-in-native-ios-apps-9af7e31d8345
 
 And adjusted the Sentamentalist nomenclature to ChordSheetJS.
 
 I did have build errors associated with handlebars when building "npm run build", and there is a discussion here:
 
 https://github.com/handlebars-lang/handlebars.js/issues/1174
 
 The solution was to add the resolve clause in the webpage.config.js
 
 To update all this, go to the JS folder and run "npm run build"
 
 Then make sure the ChordSheet.bundle.js file is in the iOS bundle
 
 Then you can continue with the tutorial.
 
 You'll see that we have to export the functionality from ChordSheetJS we want, given in the  /JS/index.js file.
 
 */

import Foundation
import JavaScriptCore


public class ChordSheet {
    
    public static let shared = ChordSheet()
    
    let context: JSContext
    
    public enum Error: Swift.Error {
        case executionFailed(details: String)
    }
    
    // Method names that are defined in /JS/index.js folder
    struct Methods {
        static let parsePlainTextChordSheetFormatToHTML = "parseChordSheetToHTML"
        static let parseUltimateGuitarFormatToHTML = "parseUltimateGuitarToHTML"
        static let parseChordProFormatToHTML = "parseChordProToHTML"
        static let getCSSTemplateWithScope = "cssTemplateForHTMLFormatter"
    }
    
    init() {
        guard let context = ChordSheet.basicConfiguration() else {
            fatalError("Could not create a context")
        }
        self.context = context
        
        context.exceptionHandler = { [weak self] (_, exception) in
            self?.error = .executionFailed(details: exception!.toString())
        }
    }
    
    private var error: Error?
    
    /// returns true if succeeds
    private static func basicConfiguration() -> JSContext? {
        
        guard let context = JSContext() else {
            logger.error("Could not create Javascript Context")
            return nil
        }
        
        context.exceptionHandler = { context, exception in
            logger.error(exception!.toString())
        }
        
        guard let url = Bundle(for: ChordSheet.self).url(forResource: "ChordSheet.bundle", withExtension: "js") else {
            logger.error("Could not find the .js file")
            return nil
        }
        
        guard let jsCode = try? String.init(contentsOf: url) else {
            logger.error("Could not load the contents of the .js file")
            return nil
        }
        
        let nativeLog: @convention(block) (String) -> Void = { message in
            logger.debug("[ChordSheetJS]: \(message)")
        }
        
        context.setObject(nativeLog, forKeyedSubscript: ("nativeLog" as NSString))
        
        // load the library into memory
        context.evaluateScript(jsCode, withSourceURL: url)
        
        return context
    }
}

// MARK: - Methods

extension ChordSheet {
    
    public func parseChordSheetToHTML(textFileContents: String,
                               completion: @escaping (Result<String, ChordSheet.Error>) -> Void) {
        
        let method = Methods.parsePlainTextChordSheetFormatToHTML
        callMethod(method: method, arguments: [textFileContents], completion: completion)
    }
    
    public func parseChordProFormatToHTML(textFileContents: String,
                                   completion: @escaping (Result<String, ChordSheet.Error>) -> Void) {
        
        let method = Methods.parseChordProFormatToHTML
        callMethod(method: method, arguments: [textFileContents], completion: completion)
    }
    
    /// You can use this in a test environment or wherever to get the CSS template that you can save/modify and then apply to the HTML body that the parse methods will produce.
    public func getCSSTemplate(with scope: String?,
                        completion: @escaping (Result<String, ChordSheet.Error>) -> Void) {
     
        let method = Methods.getCSSTemplateWithScope
        let arguments = scope != nil ? [scope!] : []
        callMethod(method: method, arguments: arguments, completion: completion)
    }
    
    private func callMethod(method: String,
                            arguments: [String],
                            completion: @escaping (Result<String, ChordSheet.Error>) -> Void) {
        
        DispatchQueue.global(qos: .userInitiated).async {
            
            let jsModule = self.context.objectForKeyedSubscript("ChordSheet")  // what we named it in webpack.config.js
            let jsAnalyzer = jsModule?.objectForKeyedSubscript("TextParser")  // what we named it in index.js
            
            if let result = jsAnalyzer?.objectForKeyedSubscript(method).call(withArguments: arguments), !result.isUndefined {
                DispatchQueue.main.async {
                    completion(.success(result.toString()))
                }
            } else {
                let error = self.error
                DispatchQueue.main.async {
                    if let e = error {
                        completion(.failure(e))
                    } else {
                        completion(.failure(.executionFailed(details: "Parsing Failed.  No further details available")))
                    }
                }
            }
            
            self.error = nil  // reset him.
        }
    }
}
