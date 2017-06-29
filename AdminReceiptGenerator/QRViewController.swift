//
//  QRViewController.swift
//  AdminReceiptGenerator
//
//  Created by Artem Misesin on 5/7/17.
//  Copyright © 2017 Artem Misesin. All rights reserved.
//

import UIKit

class QRViewController: UIViewController {

    @IBOutlet weak var imgQRCode: UIImageView!
    
    var data: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(self.data)
        let data = self.data.data(using: .utf8)
        let filter = CIFilter(name: "CIQRCodeGenerator")
        filter!.setValue(data, forKey: "inputMessage")
        //filter!.setValue("Q", forKey: "inputCorrectionLevel")
        var qrcodeImage = filter!.outputImage
        let transformedImage = qrcodeImage?.applying(CGAffineTransform(scaleX: 150, y: 150))
        imgQRCode.image = UIImage(ciImage: transformedImage!)
    }

    func generateQRCode(from string: String) -> UIImage? {
        
        let data = string.data(using: String.Encoding.ascii)
        
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            
            if let output = filter.outputImage?.applying(transform) {
                return UIImage(ciImage: output)
            }
        }
        
        return nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
