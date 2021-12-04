//
//  ViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit
import Photos

class ViewController: UIViewController {
    

    
    let tableView = UITableView()
    
    
    
    let imageView = UIImageView()
    
    let deleteButton = UIButton()
    
    
    
//
//    let layout: UICollectionViewFlowLayout = {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 150, height: 150)
//        layout.scrollDirection = .horizontal
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        return layout
//    }()
//
//    let cells = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout())
//
    
    
    // 썸네일 만들기
    let imageManager: PHCachingImageManager = PHCachingImageManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 초기화
        duplicateLists = [:]
        duplicateImageData = []
        imageDataList = []
        
        deleteButton.frame = CGRect(x: 400, y: 50, width: 50, height: 50)
        deleteButton.backgroundColor = .systemRed
        
        
        tableView.dataSource = self
        tableView.delegate = self
        
        
//
//        cells.dataSource = self
//        cells.delegate = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        cells.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell2")
        
        view.addSubview(tableView)
        
        
        view.addSubview(imageView)
        
 
        //view.addSubview(cells)
        
        reqeustsPhotoPermission()
        registerPhotoLibrary()
        
        print(duplicateImageData)
        print(duplicateLists)
        
        view.addSubview(deleteButton)
        
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

        
    }
    
    @objc private func deleteButtonTapped() {
        for datum in duplicateImageData {
            
            for asset in duplicateLists[datum]! {
                
                
                PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)}, completionHandler: nil)
                
            }
            
        }
        duplicateLists.removeAll()
        duplicateImageData.removeAll()

        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        tableView.frame = view.bounds
        imageView.frame = CGRect(x: 200, y: 200, width: 300, height: 300)
        
    }
    
    private func reqeustsPhotoPermission() {
        
        
        let photoAutorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch photoAutorizationStatus {
        case .authorized:
            print("allowed")
            self.requestCollection()
        case .denied :
            print("denied")
        case .notDetermined:
            print("Photo Authorization status is not determined")
            
            PHPhotoLibrary.requestAuthorization() {
                (status) in
                switch status {
                case .authorized:
                    print("User permiited.")
                    self.requestCollection()
                case .denied:
                    print("User denied.")
                    break
                default:
                    break
                }
            }
        case .restricted :
            print("Photo Authorization status is restricted ")
 
        default:
            break
        }
        
    }
    
    private func requestCollection() {
        let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
        
        guard let cameraRollCollection = cameraRoll.firstObject else {
            return
        }
        
        let fetchOption = PHFetchOptions()
        fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOption)
   
        
        for idx in 0..<fetchResult.count {
            
            
            let asset = fetchResult.object(at: idx)
            
            imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, _ in
                
                if imageDataList.contains((image?.pngData())!) {
                    self.imageView.image = image
                    
                    if !duplicateImageData.contains((image?.pngData())!) {
                        duplicateImageData.append((image?.pngData())!)
                        duplicateLists[(image?.pngData())!] = [asset]
                    } else {
                        var dupData = duplicateLists[(image?.pngData())!]
                        dupData?.append(asset)
                        duplicateLists[(image?.pngData())!] = dupData
                    }
                    
                    print(idx)
                } else {
                    imageDataList.append((image?.pngData())!)
                }

                
            }
       
        }
        
  
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
    }


}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchResult.count
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell") else {
            fatalError("The cell name not exist.")
        }
        
        guard let asset: PHAsset = fetchResult?.object(at: indexPath.row) else {
            return cell
        }
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, _ in
            cell.imageView?.image = image
        }
        
        return cell
    }
    
    // 삭제
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let asset = fetchResult?[indexPath.row]
            PHPhotoLibrary.shared().performChanges({PHAssetChangeRequest.deleteAssets([asset] as NSFastEnumeration)}, completionHandler: nil)
            
        }
    }
    
}

//extension ViewController:UICollectionViewDataSource,UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return self.fetchResult.count
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "cell2", for: indexPath) as! ImagesCollectionViewCell
//
//        guard let asset: PHAsset = self.fetchResult?.object(at: indexPath.row) else {
//            return cell2
//        }
//
//        imageManager.requestImage(for: asset, targetSize: CGSize(width: 100, height: 100), contentMode: .aspectFill, options: nil) { image, _ in
//            cell2.ExerciseImage.image = image
//        }
//
//        return cell2
//    }
//
//
//}

extension ViewController: PHPhotoLibraryChangeObserver {

    func registerPhotoLibrary() {
        PHPhotoLibrary.shared().register(self)
    }

    func photoLibraryDidChange(_ changeInstance: PHChange) {
        guard let asset = fetchResult, let changes = changeInstance.changeDetails(for: asset) else {
            return
        }

        fetchResult = changes.fetchResultAfterChanges

        OperationQueue.main.addOperation {
            self.tableView.reloadSections(IndexSet(0...0), with: .automatic)
        }
    }
}
