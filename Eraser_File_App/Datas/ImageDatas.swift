//
//  ImageDatas.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/04.
//

import UIKit
import Photos


var imageDataList: [Data] = []

var duplicateImageData: [Data] = []

var duplicateLists: [Data:[PHAsset]] = [:]

var fetchResult: PHFetchResult<PHAsset>!

var fileURLLists : [Data] = []

var duplicateFileData: [Data] = []

var duplicateFileLists: [Data:[URL]] = [:]


var rootURL: URL!
