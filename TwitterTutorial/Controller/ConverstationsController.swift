//
//  ConverstationsController.swift
//  TwitterTutorial
//
//  Created by Mert Köksal on 26.01.2021.
//

import UIKit

class ConverstationsController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

    }
    
    // MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
