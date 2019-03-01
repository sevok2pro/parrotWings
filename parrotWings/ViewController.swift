//
//  ViewController.swift
//  parrotWings
//
//  Created by Vsevolod Liberov on 01/03/2019.
//  Copyright © 2019 Seva. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        _ = Observable.just("lol")
            .subscribe(onNext: {next in
                print(next);
            })
        // Do any additional setup after loading the view, typically from a nib.
    }
    
}

