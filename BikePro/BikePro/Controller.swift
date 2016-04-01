//
//  Controller.swift
//  BikePro
//
//  Created by Jared Williams on 3/31/16.
//  Copyright © 2016 Jared Williams. All rights reserved.
//

import Foundation

class Controller {
    var location: locationLogic;
    var view: ViewController;
    
    init() {
        self.location = locationLogic()
        self.view = ViewController()
    }
}
