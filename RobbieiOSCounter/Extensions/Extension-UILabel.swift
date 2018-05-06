//
//  Extension-UILabel.swift
//  RobbieiOSCounter
//
//  Created by Robbie Pritchard on 5/6/18.
//  Copyright © 2018 Robbie Pritchard. All rights reserved.
//

import UIKit

extension UILabel{
    func flashTextColor(from pastColor: UIColor, to color: UIColor, for time: Double){
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: {
            self.textColor = color
            
            //Does this on the background great becuase it will not bog down the UI
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + time) {
                //revert back to previous color
                self.textColor = pastColor
            }
        }, completion: nil)
    }
}
