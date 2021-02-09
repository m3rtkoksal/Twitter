//
//  ProfileHeaderViewModel.swift
//  TwitterTutorial
//
//  Created by Mert Köksal on 4.02.2021.
//

import Foundation

enum ProfileFilterOptions: Int, CaseIterable {
    case tweets
    case replies
    case likes
    
    var description: String {
        switch self {
        case .tweets: return "Tweets"
        case .replies: return "Tweets & Replies"
        case .likes: return "Likes"
        }
    }
}
