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
    let cameraRoll: PHFetchResult<PHAssetCollection> = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: nil)
    
    guard let cameraRollCollection = cameraRoll.firstObject else {
        return
    }
    
    let fetchOption = PHFetchOptions()
    fetchOption.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    
    fetchResult = PHAsset.fetchAssets(in: cameraRollCollection, options: fetchOption)

    // 초기화
    duplicateLists = [:]
    duplicateImageData = []
    imageDataList = []
    
    for idx in 0..<fetchResult.count {
        
        
        let asset = fetchResult.object(at: idx)
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, _ in
            
            if imageDataList.contains((image?.pngData())!) {
                WatchDuplicateViewButton.setImage(image, for: .normal)
                
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
            
            OperationQueue.main.addOperation {
                print(fetchResult.count)
            }

            
        }
   
    }
    
}
