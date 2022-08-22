//
//  ViewController.swift
//  PagoAssignment
//
//  Created by Claudiu Miron on 22.08.2022.
//

import UIKit
import PagoUIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        debugPrint(PagoUIKit().text)
    }


}

