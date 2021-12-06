//
//  ImageDatas.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit
import Photos


// 이미지 데이터
var imageDataList: [Data] = []

var duplicateImageData: [Data] = []

var duplicateLists: [Data:[PHAsset]] = [:]

var fetchResult: PHFetchResult<PHAsset>!

var duplicateImageCount: Int = 0

var representImage: UIImage = UIImage(named: "defaultImage")!


// 파일 데이터
var fileURLLists : [Data] = []

var duplicateFileData: [Data] = []

var duplicateFileLists: [Data:[URL]] = [:]


var rootURL: URL!
