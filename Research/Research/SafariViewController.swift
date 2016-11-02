//
//  SafariViewController.swift
//  Research
//
//  Created by Lance Blue on 2016/11/1.
//  Copyright © 2016年 Lance Blue. All rights reserved.
//

import UIKit
import SafariServices

class SafariViewController: BaseViewController, SFSafariViewControllerDelegate {

    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "SFSafariViewController"
        
        button.setTitle("Present Safari", for: .normal)
        button.sizeToFit()
        button.center = self.view.center
        button.addTarget(self, action: #selector(button_touch), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    // MARK: - Action
    
    func button_touch() {
        let safariViewController = SFSafariViewController(url: URL(string: "http://www.baidu.com")!)
        safariViewController.delegate = self
        safariViewController.preferredBarTintColor = UIColor.red
        safariViewController.preferredControlTintColor = UIColor.blue
        self.present(safariViewController, animated: true, completion: nil)
    }

}
