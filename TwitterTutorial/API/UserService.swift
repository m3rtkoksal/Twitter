//
//  UserService.swift
//  TwitterTutorial
//
//  Created by Mert Köksal on 29.01.2021.
//

import UIKit
import Firebase

struct UserService {
    static let shared = UserService()
    
    func fetchUser(completion: @escaping(User) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            //uid dict icinde olmadigi icin boyle cagirdik
            let user = User(uid: uid, dictionary: dictionary)
            // completion koymazsan fetchUser tamamlanmaz ve burada kalir app
            completion(user)
        }
    }
}
