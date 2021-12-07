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
    
    duplicateImageCount = 0
    
    var count = 0
 
    
    for idx in 0..<fetchResult.count {
        
        guard let asset: PHAsset = fetchResult?.object(at: idx) else {
            return
        }
        
        
        imageManager.requestImage(for: asset, targetSize: CGSize(width: 300, height: 300), contentMode: .aspectFit, options: nil) { image, _ in
            
            if count >= fetchResult.count {
                let imgData = (image?.pngData())!
                
                
                if imageDataList.contains(imgData) {
                    
                    representImage = UIImage(data: imgData)!
                    duplicateImageCount += 1
                        
                    if !duplicateImageData.contains(imgData) {
                        duplicateImageData.append(imgData)
                        duplicateLists[imgData] = [asset]
                        
                    } else {
                        
                        var dupData = duplicateLists[imgData]
                        dupData?.append(asset)
                        duplicateLists[imgData] = dupData
                    }
                        
                } else {
                    imageDataList.append(imgData)
                }
            }
            
            
            count += 1
  
        }
   
    }
//
//    if duplicateImageCount >= 1  {
//        representImage = UIImage(data: duplicateImageData[0])!
//    } else {
//        representImage = UIImage(named: "defaultImage")!
//    }
 
}
