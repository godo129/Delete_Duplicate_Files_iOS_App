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
    
    private let FileViewButton: UIButton = {
        let FileViewButton = UIButton()
        FileViewButton.backgroundColor = .systemPink
        return FileViewButton
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(WatchDuplicateButton)
        view.addSubview(WatchDuplicateViewButton)
        
        view.addSubview(FileViewButton)

        WatchDuplicateButton.addTarget(self, action: #selector(WatchDuplicateButtonTapped), for: .touchUpInside)
        
        WatchDuplicateViewButton.addTarget(self, action: #selector(WatchDuplicateViewButtonTapped), for: .touchUpInside)
        
        FileViewButton.addTarget(self, action: #selector(FileViewButtonTapped), for: .touchUpInside)
        
        
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
        
        FileViewButton.frame = CGRect(x: 30, y: 350, width: view.frame.width-60, height: 200)
    }
    
    @objc private func WatchDuplicateViewButtonTapped() {
        moveView(viewName: "DuplicateImageView")
    }
    
    @objc private func WatchDuplicateButtonTapped() {
        moveView(viewName: "DuplicateView")
    }
    
    @objc private func FileViewButtonTapped() {
        moveView(viewName: "FileView")
    }
    
    
    private func moveView(viewName: String) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: viewName)
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
