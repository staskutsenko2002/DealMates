//
//  TabBarItem.swift
//  dealMates
//
//  Created by Stanislav on 06.05.2023.
//

import UIKit

struct TabBarItem {
    enum Page {
        case home
        case favourites
        case create
        case deals
        case profile
        
        var image: UIImage? {
            switch self {
            case .home: return AppImage.home()
            case .favourites: return AppImage.like()
            case .create: return AppImage.plus()
            case .deals: return AppImage.chat()
            case .profile: return AppImage.profile()
            }
        }
        
        var imageSelected: UIImage? {
            switch self {
            case .home: return AppImage.homeFill()
            case .favourites: return AppImage.likeFill()
            case .create: return AppImage.plusFill()
            case .deals: return AppImage.chatFill()
            case .profile: return AppImage.profileFill()
            }
        }
    }
    
    let controller: UIViewController
    let page: Page
}

