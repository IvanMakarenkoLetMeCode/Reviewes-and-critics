//
//  KeyboardToolbarButton.swift
//  Reviewes and critics
//
//  Created by Ivan on 27.08.2020.
//  Copyright © 2020 Ivan. All rights reserved.
//

import UIKit

enum KeyboardToolbarButton: Int {

    case done = 0
    case cancel
    case back, backDisabled
    case forward, forwardDisabled

    func createButton(target: Any?, action: Selector?) -> UIBarButtonItem {
        var button: UIBarButtonItem!
        switch self {
            case .back: button = .init(title: "back", style: .plain, target: target, action: action)
            case .backDisabled:
                button = .init(title: "back", style: .plain, target: target, action: action)
                button.isEnabled = false
            case .forward: button = .init(title: "forward", style: .plain, target: target, action: action)
            case .forwardDisabled:
                button = .init(title: "forward", style: .plain, target: target, action: action)
                button.isEnabled = false
            case .done: button = .init(title: "done", style: .plain, target: target, action: action)
            case .cancel: button = .init(title: "cancel", style: .plain, target: target, action: action)
        }
        button.tag = rawValue
        return button
    }

    static func detectType(barButton: UIBarButtonItem) -> KeyboardToolbarButton? {
        return KeyboardToolbarButton(rawValue: barButton.tag)
    }
    
    
}
