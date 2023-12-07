//
//  DetailViewController.swift
//  HWS-Project-7
//
//  Created by Ade Dwi Prayitno on 07/12/23.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    var webview: WKWebView!
    var detailItem: Petition?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        webview = WKWebView()
        view = webview
        
        guard let detailItem else { return }
        
        let html = """
        <html>
        <head>
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <style> body { font-size: 150%; } </style>
        </head>
        <body>
        \(detailItem.body)
        </body>
        </html>
        """
        
        webview.loadHTMLString(html, baseURL: nil)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
