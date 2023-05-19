//
//  TextFieldImageExtension.swift
//  Auth_Combine
//
//  Created by Edgar Cisneros on 18/05/23.
//

import UIKit


extension UITextField{
    
    func setupLeftSideImage (imageViewNamed:String){
        let imageView = UIImageView(frame: CGRect(x: 10, y: 10, width: 20, height: 20))
        imageView.image = UIImage(systemName: imageViewNamed)
        imageView.tintColor = .white
        let imageViewContainerView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageViewContainerView.addSubview(imageView)
        leftView = imageViewContainerView
        leftViewMode = .always
        self.tintColor = .lightGray
        
    }
    
}
