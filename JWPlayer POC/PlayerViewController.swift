//
//  PlayerViewController.swift
//  JWPlayer POC
//
//  Created by Rahul Golwalkar  on 09/05/19.
//  Copyright © 2019 ONE Championship. All rights reserved.
//

import UIKit
import GoogleCast

class PlayerViewController: UIViewController, JWCastingDelegate {
    
    @IBOutlet weak var playerContainerView: UIView!
    var player: JWPlayerController?
    var castController: JWCastController?

    
    func onCastingDevicesAvailable(_ devices: [JWCastingDevice]!) {
        let chosenDevice = devices.first
        castController?.connect(to: chosenDevice)
    }
    
    func onConnected(to device: JWCastingDevice?) {
        castController?.cast()
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let config: JWConfig  = JWConfig(contentURL: "http://qthttp.apple.com.edgesuite.net/1010qwoeiuryfg/sl.m3u8")
        player = JWPlayerController(config: config)
        castController = JWCastController(player: player);
        castController?.chromeCastReceiverAppID = kGCKDefaultMediaReceiverApplicationID;
        castController?.delegate = self;
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
            self.castController?.scanForDevices()
        })

        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let playerView: UIView = player!.view
        playerContainerView.addSubview(playerView)
        playerView.constrainToSuperview()
    }
}

extension UIView {
    /// Constrains the view to its superview, if it exists, using Autolayout.
    /// - precondition: For player instances, JWP SDK 3.3.0 or higher.
    @objc func constrainToSuperview() {
        translatesAutoresizingMaskIntoConstraints = false
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: "H:|[thisView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["thisView": self])
        
        let verticalConstraints   = NSLayoutConstraint.constraints(withVisualFormat: "V:|[thisView]|",
                                                                   options: [],
                                                                   metrics: nil,
                                                                   views: ["thisView": self])
        
        NSLayoutConstraint.activate(horizontalConstraints + verticalConstraints)
    }
}
