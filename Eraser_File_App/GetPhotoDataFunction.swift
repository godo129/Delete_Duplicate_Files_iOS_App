//
//  GetPhotoDataFunction.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/05.
//

import UIKit
import Photos


// 썸네일 만들기
let imageManager: PHCachingImageManager = PHCachingImageManager()

func reqeustsPhotoPermission() {
    
    
    let photoAutorizationStatus = PHPhotoLibrary.authorizationStatus()
    
    switch photoAutorizationStatus {
    case .authorized:
        print("allowed")
        requestCollection()
    case .denied :
        print("denied")
    case .notDetermined:
        print("Photo Authorization status is not determined")
        
        PHPhotoLibrary.requestAuthorization() {
            (status) in
            switch status {
            case .authorized:
                print("User permiited.")
                requestCollection()
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

func requestCollection() {
    print("gogogogo")
    let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
    
    guard let cameraRollCollection = cameraRoll.firstObject else {
        return
    }
    
    let fetchOption = PHFetchOptions()
    fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOption)

    // 초기화
    
//    var imageDataList: [Data] = []
//
//    var duplicateImageData: [Data] = []
//
//    var duplicateLists: [Data:[PHAsset]] = [:]
//
    var empty: [Data] = []
    var empty2: [Data] = []
    var emptyList: [Data:[PHAsset]] = [:]
    
    duplicateLists = emptyList
    duplicateImageData = empty
    imageDataList = empty2
 
    
    for idx in 0..<fetchResult.count {
        
        let asset = fetchResult.object(at: idx)
        
        
    
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 150, height: 150), contentMode: .aspectFit, options: nil) { image, _ in
            
            guard let imgData = image?.pngData() else {return}
            
   
            if imageDataList.contains(imgData) {
                WatchDuplicateViewButton.setImage(image, for: .normal)
                    
                if !duplicateImageData.contains(imgData) {
                    duplicateImageData.append(imgData)
                    duplicateLists[imgData] = [asset]
                    print(imgData)
                } else {
                    var dupData = duplicateLists[imgData]
                    dupData?.append(asset)
                    duplicateLists[imgData] = dupData
                }
                    
                print(idx)
            } else {
                imageDataList.append(imgData)
            }
                
    //            OperationQueue.main.addOperation {
    //                print(fetchResult.count)
    //            }

            
        }
   
    }
    
}
