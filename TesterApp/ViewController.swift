//
//  ViewController.swift
//  TesterApp
//
//  Created by Stephen O'Connor on 05.06.21.
//

import UIKit
import WebKit
import ChordSheetSwift

class ViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    let chordSheet = ChordSheet.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.webview.navigationDelegate = self
        
        loadContent()
    }
    
    private func loadContent() {
        guard let file = Bundle.main.url(forResource: "TestSongChordSheet.txt", withExtension: nil),
              let contents = try? String(contentsOf: file) else {
            logger.error("Couldn't Load test content file")
            return
        }
        
        chordSheet.getCSSTemplate(with: nil) { [unowned self] result in
            switch result {
            case .success(let css):
                chordSheet.parseChordSheetToHTML(textFileContents: contents) { htmlResult in
                    switch htmlResult {
                    case .success(let html):
                        self.buildAndLoadWebpage(from: html, and: css)
                    case .failure(let error):
                        logger.error("Failed getting HTML: \(String(describing: error))")
                    }
                }
            case .failure(let error):
                logger.error("Failed getting CSS: \(String(describing: error))")
            }
        }
        
    }
    
    private func buildAndLoadWebpage(from html: String, and css: String) {
        
        let webpage = """
            <!DOCTYPE html>
            <html>
            <head>
            <style>
            body {
              font-family: Helvetica, sans-serif;
              font-size: 32px;
            }
            \(css)
            </style>
            </head>
            <body>
            \(html)
            </body>
            </html>
            """
     
        self.webview.loadHTMLString(webpage, baseURL: nil)
    }
    
}

extension ViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView,
                 didFail navigation: WKNavigation!,
                 withError error: Error) {
        
    }
    
    func webView(_ webView: WKWebView,
                 didFinish navigation: WKNavigation!) {
        
    }
}

