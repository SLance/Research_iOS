//
//  RunLoopController.swift
//  Research
//
//  Created by Lance Blue on 2016/11/9.
//  Copyright © 2016年 Lance Blue. All rights reserved.
//

import UIKit

class RunLoopController: BaseViewController {

    var threadA: Thread?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "RunLoop"
        
        threadA = Thread(target: self, selector: #selector(runA), object: nil)
        threadA!.start()
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
    
    
    func runA() {
        Thread.detachNewThreadSelector(#selector(runB), toTarget: self, with: nil)
        
        let lastDate = Date()
        while true {
            if RunLoop.current.run(mode: .defaultRunLoopMode, before: lastDate.addingTimeInterval(10)) {
//            RunLoop.current.run(until: lastDate.addingTimeInterval(10))
                print("线程B结束，运行了\(Date().timeIntervalSince(lastDate))秒")
//                break
            }
        }
    }
    
    func runB() {
        sleep(15)
        self.perform(#selector(setData), on: threadA!, with: nil, waitUntilDone: true, modes: [RunLoopMode.defaultRunLoopMode.rawValue])
    }
    
    func setData() {
        print("喵")
    }

}
