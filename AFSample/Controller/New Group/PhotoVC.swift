//
//  PhotoVC.swift
//  AFSample
//
//  Created by Shadi Matter on 11/27/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit

class PhotoVC: UIViewController {
    
    var imgArr = [photos]()

    
    fileprivate let cellIdentfire = "PhotoCell"
    
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var addButton :UIBarButtonItem = {
        let button = UIBarButtonItem(barButtonSystemItem:.add, target: self, action: #selector(handleAdd))
    return button
    }()
    // add refresher
    lazy var refresher:UIRefreshControl = {
       let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
    }()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
     //   imgArr = Array.init(repeating: #imageLiteral(resourceName: "gg"), count: 5)
        navigationItem.rightBarButtonItem = addButton
        view.backgroundColor = .white
        collectionView.backgroundColor = .clear
        
        collectionView.delegate = self
      collectionView.dataSource = self
        
        collectionView!.addSubview(refresher)
        
      // self.collectionView!.alwaysBounceVertical = true
//        let refresher = UIRefreshControl()
//        refresher.addTarget(self, action: #selector(PhotoVC.handleRefresh), for: .valueChanged)
//
//       // refreshControl = refresher
//        collectionView!.addSubview(refresher)

        
        collectionView.register(UINib.init(nibName: cellIdentfire, bundle: nil), forCellWithReuseIdentifier: cellIdentfire)
        // Do any additional setup after loading the view.
  handleRefresh()
    }

    
    var picker_image:UIImage? {
        didSet{
            // do som code
            guard let image = picker_image else {return}
            // add temporary to array
          //  imgArr.append(image)
            
            
            // Send to server
            API.createPhoto(photo: image) { (error:Error?,  success:Bool?) in
                if success!{
                    // updata collection view
                }
            }
        
    }
    }
    var isloading = false
    var current_page = 1
    var last_page = 1
    @objc private func handleRefresh(){
        self.refresher.endRefreshing()
        guard !isloading else {
            return
        }
        isloading = true
        API.photo { (error:Error?, photo:[photos]?,last_page:Int ) in
            self.isloading = false
            if let photo = photo {
                self.imgArr = photo
                self.collectionView.reloadData()
                
                self.current_page = 1
                self.last_page = last_page
            }
        }
    
    }   
//
   @objc private func handleAdd(){
    
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.sourceType = .photoLibrary
    picker.delegate = self
    
    self.present(picker, animated: true, completion: nil)
    }
}

extension PhotoVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let editImage = info[UIImagePickerControllerEditedImage] as? UIImage {
          self.picker_image = editImage
        }else if let orginalImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
          self.picker_image = orginalImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

extension PhotoVC:UICollectionViewDelegateFlowLayout{
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    let screenWidth = UIScreen.main.bounds.width
        var width = (screenWidth-30)/2
        
        width = width > 200 ? 200 : width
       
        return CGSize.init(width: width, height: width)
    }

}

extension PhotoVC:UICollectionViewDataSource{
 
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imgArr.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell" , for: indexPath) as? PhotoCell
        else {return UICollectionViewCell()}
        
      // cell.imageView.image = imgArr[indexPath.row] as? UIImage
     //  cell.imageView.image = imgArr[indexPath.item] as? UIImage
       cell.photo = imgArr[indexPath.item]
    return cell
    }
   
}





