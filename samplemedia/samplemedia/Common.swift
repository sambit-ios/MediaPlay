//
//  Common.swift
//  samplemedia
//
//  Created by TechExactlyMAC4 on 09/01/21.
//  Copyright © 2021 TechExactlyMAC4. All rights reserved.
//

import Foundation
import SystemConfiguration
import UIKit


func isNetworkAvailable() -> Bool{
    
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
            SCNetworkReachabilityCreateWithAddress(nil, $0)
        }
    }) else {
        return false
    }
    
    var flags: SCNetworkReachabilityFlags = []
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
        return false
    }
    
    let isReachable = flags.contains(.reachable)
    let needsConnection = flags.contains(.connectionRequired)
    
    return (isReachable && !needsConnection)
}
extension UIViewController {
func showAlert(withTitle title: String?, andMessage msg: String?) {
       let alertController = UIAlertController(title: title, message: msg, preferredStyle: .alert)
       //let firstView: UIView? = alertController.view.subviews.first
       //let secView: UIView? = firstView?.subviews.first
       //secView?.backgroundColor = UIColor(red: CGFloat(0.996), green: CGFloat(0.996), blue: CGFloat(0.980), alpha: CGFloat(1.00))
       //secView?.layer.cornerRadius = 3.0
       //alertController.view.tintColor = kAlertTintColor
       let actionOk = UIAlertAction(title: "Ok", style: .cancel, handler: {(_ action: UIAlertAction) -> Void in
           alertController.dismiss(animated: true, completion: { ()-> Void in })
       })
       alertController.addAction(actionOk)
       DispatchQueue.main.async(execute: {() -> Void in
           if !(self.presentedViewController is (UIAlertController)) {
               self.present(alertController, animated: true, completion: {()-> Void in })
           }
       })
   }
}
