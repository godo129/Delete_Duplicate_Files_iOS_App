//
//  HomeViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit
import Photos

let WatchDuplicateViewButton: UIButton = {
    let WatchDuplicateButton = UIButton()
    WatchDuplicateButton.backgroundColor = .purple
    return WatchDuplicateButton
}()

class HomeViewController: UIViewController {
    
    
   
    
    private let WatchDuplicateButton: UIButton = {
        let WatchDuplicateButton = UIButton()
        WatchDuplicateButton.backgroundColor = .purple
        return WatchDuplicateButton
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(WatchDuplicateButton)
        view.addSubview(WatchDuplicateViewButton)

        WatchDuplicateButton.addTarget(self, action: #selector(WatchDuplicateButtonTapped), for: .touchUpInside)
        
        WatchDuplicateViewButton.addTarget(self, action: #selector(WatchDuplicateViewButtonTapped), for: .touchUpInside)
        
        
        // 백그라운드에서 다시 앱으로 돌아오는 것을 알아 채게 하기
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appCameToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        registerPhotoLibrary()
    

        
    }
    
    @objc func appCameToForeground() {
        reqeustsPhotoPermission()
    }
    
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        WatchDuplicateButton.frame = CGRect(x: 30, y: 100, width: view.frame.width-60, height: 300)
        
        WatchDuplicateViewButton.frame = CGRect(x: 30, y: 600, width: view.frame.width-60, height: 300)
    }
    
    @objc private func WatchDuplicateViewButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DuplicateImageView")
        vc?.modalTransitionStyle = .coverVertical
        present(vc!, animated: true, completion: nil)
    }
    
    @objc private func WatchDuplicateButtonTapped() {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DuplicateView")
        vc?.modalTransitionStyle = .coverVertical
        present(vc!, animated: true, completion: nil)
    }

}



extension HomeViewController: PHPhotoLibraryChangeObserver {

    func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset = fetchResult, let changes = changeInstance.changeDetails(for: asset) else {
            return
        }

        fetchResult = changes.fetchResultAfterChanges

        OperationQueue.main.addOperation {
            
        }
    }
}
