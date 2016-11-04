//
//  ImagePickerController.swift
//  Research
//
//  Created by Lance Blue on 2016/11/2.
//  Copyright © 2016年 Lance Blue. All rights reserved.
//

import UIKit
import Photos
import AssetsLibrary

class PhotoMetadataController: BaseViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.title = "Photo Metadata"
        
        button.setTitle("Show Image Picker", for: .normal)
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
    
    
    // MARK: - UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let assetURL = info[UIImagePickerControllerReferenceURL] as! URL

        if UIDevice.current.systemVersion.compare("9.0", options: .numeric) == .orderedAscending {
            if (picker.sourceType != .camera) {
                // 图片是从相册所选，否则url不能使用
                ALAssetsLibrary().asset(for: assetURL, resultBlock: { (asset) in
                    let metadata = asset!.defaultRepresentation().metadata()!
                    let alertController = UIAlertController(title: nil, message: "\(metadata)", preferredStyle: .alert)
                    alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                    picker.present(alertController, animated: true, completion: nil)
                }, failureBlock: { (error) in
                    print("\(error)")
                })
            }
        } else {
            let assets = PHAsset.fetchAssets(withALAssetURLs: [assetURL], options: nil)
            let asset = assets.firstObject!
            
            asset.requestContentEditingInput(with: nil) { (contentEditingInput, info) in
                let fullImage = CIImage(contentsOf: (contentEditingInput?.fullSizeImageURL)!)
                
                let metadata = fullImage?.properties
                
                let alertController = UIAlertController(title: nil, message: "\(metadata)", preferredStyle: .alert)
                alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
                picker.present(alertController, animated: true, completion: nil)
            }
        }
    }
    
    
    // MARK: - Action
    
    func button_touch() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
//        if UIImagePickerController.isSourceTypeAvailable(.camera) {
//            imagePickerController.sourceType = .camera
//        }
        self.present(imagePickerController, animated: true, completion: nil)
    }

}
