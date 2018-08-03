//
//  StoryboardSupport.swift
//  Fitness
//
//  Created by Atay Sultangaziev on 8/1/18.
//  Copyright © 2018 Atay Sultangaziev. All rights reserved.
//
import Foundation
import UIKit

protocol SegueHandlerType {
    associatedtype SegueIdentifier: RawRepresentable
}

extension SegueHandlerType where Self: UIViewController, SegueIdentifier.RawValue == String {
    
    func performSegue(withIdentifier identifier: SegueIdentifier, sender: Any?) {
        performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
    
    func segueIdentifier(for segue: UIStoryboardSegue) -> SegueIdentifier {
        guard
            let identifier = segue.identifier,
            let segueIdentifier = SegueIdentifier(rawValue: identifier)
            else {
                fatalError("Invalid segue identifier: \(String(describing: segue.identifier))")
        }
        
        return segueIdentifier
    }
    
}
