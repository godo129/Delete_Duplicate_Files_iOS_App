//
//  HomeViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit

class HomeViewController: UIViewController {
    
    
    private let WatchDuplicateButton: UIButton = {
        let WatchDuplicateButton = UIButton()
        WatchDuplicateButton.backgroundColor = .purple
        return WatchDuplicateButton
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(WatchDuplicateButton)
        
        WatchDuplicateButton.addTarget(self, action: #selector(WatchDuplicateButtonTapped), for: .touchUpInside)

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        WatchDuplicateButton.frame = CGRect(x: 30, y: 200, width: view.frame.width-60, height: 300)
    }
    
    @objc private func WatchDuplicateButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DuplicateView")
        vc?.modalTransitionStyle = .coverVertical
        present(vc!, animated: true, completion: nil)
    }

}
