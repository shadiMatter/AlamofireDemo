//
//  PhotoCell.swift
//  AFSample
//
//  Created by Shadi Matter on 11/27/17.
//  Copyright © 2017 Shadi Matter. All rights reserved.
//

import UIKit
import Alamofire

class PhotoCell: UICollectionViewCell {

    @IBOutlet weak var imageView: UIImageView!
    var photo:photos? {
        didSet{
            guard let photo = photo else {return}
          imageView.image = #imageLiteral(resourceName: "gg")
          
            
            Alamofire.request(photo.url).response { response in
                if let data = response.data , let image = UIImage(data: data){
                    self.imageView.image = image
               print(photo.url)
                }
            }
        }
    }

}
