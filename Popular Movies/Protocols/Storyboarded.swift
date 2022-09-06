//
//  Storyboarded.swift
//  Popular Movies
//
//  Created by Алексей Павленко on 05.09.2022.
//

import UIKit

protocol Storyboarded {
    static var storyboardName: String { get }
    static var identifier: String { get }
    static func instantiate() -> UIViewController
}

extension Storyboarded where Self: UIViewController {
    static func instantiate() -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: .main)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}

