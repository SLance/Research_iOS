//
//  SocialController.swift
//  Research
//
//  Created by Lance Blue on 30/11/2016.
//  Copyright © 2016 Lance Blue. All rights reserved.
//

import UIKit
import Social

class SocialController: BaseViewController {

    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Social"
        
        button.setTitle("Share To Twitter", for: .normal)
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
        if SLComposeViewController.isAvailable(forServiceType: SLServiceTypeTwitter) {
            let controller = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
            controller?.setInitialText("Test Initial Text!!!")
            controller?.add(URL(string: "http://www.baidu.com"))
            
            self.present(controller!, animated: true, completion: nil)
        } else {
            print("not support!!!")
        }
    }

}
