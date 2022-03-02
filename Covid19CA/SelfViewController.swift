//
//  SelfViewController.swift
//  Covid19CA
//
//  Created by Arturo on 11/12/21.
//

import UIKit
import WebKit

class SelfViewController: UIViewController {

    @IBOutlet weak var webview: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        webview.load(URLRequest(url: URL(string: "https://covid-19.ontario.ca/self-assessment/")!))
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
