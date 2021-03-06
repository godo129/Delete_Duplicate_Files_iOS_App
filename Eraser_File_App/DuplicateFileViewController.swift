//
//  DuplicateFileViewController.swift
//  Eraser_File_App
//
//  Created by hong on 2021/12/06.
//

import UIKit
import Lottie

class DuplicateFileViewController: UIViewController {
    
    var arrSelectedIndex = [IndexPath]()
    var arrSelectedData = [Data]()
    
    private let filemg = FileManager.default
    
    private var collectionView: UICollectionView!
    
    private let deleteButton: UIButton = {
        let deleteButton = UIButton()
        deleteButton.setTitle("삭제", for: .normal)
        deleteButton.setTitleColor(.black, for: .normal)
        deleteButton.backgroundColor = .white
        deleteButton.layer.borderWidth = 2
        deleteButton.layer.borderColor = UIColor.black.cgColor
        deleteButton.layer.cornerRadius = 10
        deleteButton.layer.opacity = 0.7
        return deleteButton
    }()
    
    private let deleteAllButton: UIButton = {
        let deleteAllButton = UIButton()
        deleteAllButton.setTitle("전부 삭제", for: .normal)
        deleteAllButton.setTitleColor(.black, for: .normal)
        deleteAllButton.backgroundColor = .white
        deleteAllButton.layer.borderWidth = 2
        deleteAllButton.layer.borderColor = UIColor.black.cgColor
        deleteAllButton.layer.cornerRadius = 10
        deleteAllButton.layer.opacity = 0.7
        return deleteAllButton
    }()
    
    private let emptyAnimaton: AnimationView = {
        var emptyAnimation = AnimationView()
        emptyAnimation = .init(name: "emptyBox")
        emptyAnimation.loopMode = .loop
        emptyAnimation.contentMode = .scaleAspectFit
        emptyAnimation.animationSpeed = 1.2
        emptyAnimation.play()
        return emptyAnimation
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(duplicateLists)

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        // 셀 크기 정하기
        layout.itemSize = CGSize(width: view.frame.size.width/2-2, height: view.frame.size.width/2-2+100)
        // 셀마다 공간 정하기
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        collectionView.frame = view.bounds
        
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        collectionView.register(ImagesCollectionViewCell.self, forCellWithReuseIdentifier: "fileCell")
        
        collectionView.backgroundColor = .white
        
        view.addSubview(collectionView)
//
//        getData(fileUrl: rootURL)
        
        deleteAllButton.addTarget(self, action: #selector(deleteAllButtonTapped), for: .touchUpInside)
        
        if duplicateFileData.isEmpty {
            emptyAnimaton.isHidden = false
            deleteAllButton.isHidden = true
            deleteButton.isHidden = true
        } else {
            emptyAnimaton.isHidden = true
            deleteAllButton.isHidden = false
            deleteButton.isHidden = false
        }
        
        view.addSubview(deleteButton)
        deleteButton.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        view.addSubview(deleteAllButton)
        view.addSubview(emptyAnimaton)
        emptyAnimaton.backgroundBehavior = .pauseAndRestore
    

    }
    
    @objc private func deleteButtonTapped() {
        
        let alert = UIAlertController(title: "", message: "삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
            
            self.arrSelectedIndex.sort(by: >)
            for indexPath in self.arrSelectedIndex {
                
                let toDeleteURLs = duplicateFileLists[duplicateFileData[indexPath.row]]!
            
                duplicateFileCount -= toDeleteURLs.count
            
                for toDeleteURL in toDeleteURLs {
                    do{
                        try self.filemg.removeItem(at: toDeleteURL)
            
                    } catch {
                        print("delete errored")
                    }
                }
            
                duplicateFileLists.removeValue(forKey: duplicateFileData[indexPath.row])

            
                duplicateFileLists[duplicateFileData[indexPath.row]] = [URL]()
            
                duplicateFileData.remove(at: indexPath.row)
            
            
                self.collectionView.deleteItems(at: [indexPath])
            
                self.collectionView.reloadData()
            
                if duplicateFileData.isEmpty {
                    self.emptyAnimaton.isHidden = false
                    self.deleteAllButton.isHidden = true
                    self.deleteButton.isHidden = true
                }
                
                self.arrSelectedData.removeAll()
                self.arrSelectedIndex.removeAll()
            }}))
  
        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
        
        present(alert, animated: false, completion: nil)
        

        
        
        
    }
    
    @objc private func deleteAllButtonTapped() {
        
        let alert = UIAlertController(title: "", message: "정말로 삭제하시겠습니까?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            
            var indexPath: [IndexPath] = []
            for i in 0..<duplicateFileData.count {
                
                let index = IndexPath(row: i, section: 0)
                indexPath.append(index)
                
                let toDeleteURLs = duplicateFileLists[duplicateFileData[i]]!
                
                for toDeleteURL in toDeleteURLs {
                    do{
                        try self.filemg.removeItem(at: toDeleteURL)
                        
                    } catch {
                        print("delete errored")
                    }
                }
            }
            
                
            self.collectionView.deleteItems(at: indexPath)
                
            self.collectionView.reloadData()
                
            self.emptyAnimaton.isHidden = false
            self.deleteAllButton.isHidden = true
            self.deleteButton.isHidden = true 
            
            self.collectionView.removeFromSuperview()
            
            duplicateFileCount = 0
               
                
            
        }))
        present(alert, animated: true) {
            
            
        }
        
    }
    
    
    private func getData(fileUrl: URL) {
        
        
        // 이걸 해 줘야 접근 가능
        if fileUrl.startAccessingSecurityScopedResource() {
            
            do {
                
                let items = try filemg.contentsOfDirectory(atPath: fileUrl.path)
                
                for item in items {
                    print("Found \(item)")
                }
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            
            do {
                
                
                let contensts = try filemg.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
                
                for content in contensts {
                    if let item = filemg.contents(atPath: content.path) {
                        print(item.description)
                        let fileData = File(url: content, data: item)
                        
                        if !fileURLLists.contains(fileData.data) {
                            
                            fileURLLists.append(fileData.data)
                            let empty: [URL] = []
                            duplicateFileLists[fileData.data] = empty
                        } else {
                            
                            var urlLists: [URL] = duplicateFileLists[fileData.data]!
                            
                            if urlLists.count == 0 {
                                duplicateFileData.append(fileData.data)
                            }
                            urlLists.append(fileData.url)
                            duplicateFileLists[fileData.data] = urlLists
                            
                        }
                        
                    } else {
                        // 자동으로 하위 디렉토리 정리해줌
                        getData(fileUrl: content)
                    }
                    
                }
                
                
                
            } catch {
                print(error.localizedDescription)
            }
            
            print(duplicateFileLists)
            
            
            // 매체 없는 파일 삭제
            
     
            
            do {
                
                let contents = try filemg.contentsOfDirectory(at: fileUrl, includingPropertiesForKeys: nil)
                
                if contents.isEmpty {
                    try filemg.removeItem(at: fileUrl)
                }
                
            } catch {
                do {
                    try filemg.removeItem(at: fileUrl)
                } catch{
                    print("nonono")
                }
                
            }
            
           

        }
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        emptyAnimaton.frame = view.bounds
        deleteAllButton.frame = CGRect(x: view.frame.width-100, y: 0, width: 100, height: 40)
        deleteButton.frame = CGRect(x: deleteAllButton.frame.origin.x-100, y: 0, width: 100, height: 40)
    }
    


}
extension DuplicateFileViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return duplicateFileData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "fileCell", for: indexPath) as! ImagesCollectionViewCell
        
        if arrSelectedIndex.contains(indexPath) {
            cell.selectedIndicator.isHidden = false
            
        } else {
            cell.selectedIndicator.isHidden = true
        }
        
        cell.ExerciseImage.image = UIImage(data: duplicateFileData[indexPath.row])
        let fileName = duplicateFileLists[duplicateFileData[indexPath.row]]![0].lastPathComponent.description
        cell.ExerciseLabel.text = "\(fileName)"
        cell.CountLabel.text = "\(duplicateFileLists[duplicateFileData[indexPath.row]]!.count)"
        
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        
        return cell
    }

//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        
//        let alert = UIAlertController(title: "", message: "삭제하시겠습니까?", preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "네", style: .default, handler: { _ in
//            let toDeleteURLs = duplicateFileLists[duplicateFileData[indexPath.row]]!
//            
//            duplicateFileCount -= toDeleteURLs.count
//            
//            for toDeleteURL in toDeleteURLs {
//                do{
//                    try self.filemg.removeItem(at: toDeleteURL)
//                    
//                } catch {
//                    print("delete errored")
//                }
//            }
//            
//            duplicateFileLists.removeValue(forKey: duplicateFileData[indexPath.row])
//            
//            var empty: [URL] = []
//            
//            duplicateFileLists[duplicateFileData[indexPath.row]] = empty
//            
//            duplicateFileData.remove(at: indexPath.row)
//            
//            
//            collectionView.deleteItems(at: [indexPath])
//            
//            collectionView.reloadData()
//            
//            if duplicateFileData.isEmpty {
//                self.emptyAnimaton.isHidden = false
//                self.deleteAllButton.isHidden = true
//            }
//        }))
//        alert.addAction(UIAlertAction(title: "아니요", style: .cancel, handler: nil))
//        
//        present(alert, animated: false, completion: nil)
//        
//        
//
//    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("you selected cell \(indexPath.item)")
        
        let strData = duplicateFileData[indexPath.row]
        
        if arrSelectedIndex.contains(indexPath) {
            arrSelectedIndex = arrSelectedIndex.filter{$0 != indexPath}
            arrSelectedData = arrSelectedData.filter{$0 != strData}
        } else {
            arrSelectedIndex.append(indexPath)
            arrSelectedData.append(strData)
        }
        collectionView.reloadData()
    }
    
}
