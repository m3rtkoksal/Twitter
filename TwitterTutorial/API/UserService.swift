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
    
    func fetchUser(uid: String, completion: @escaping(User) -> Void) {
        // bu sadece kullanan kisinin uid si
//        guard let uid = Auth.auth().currentUser?.uid else {return}
        REF_USERS.child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            //uid dict icinde olmadigi icin boyle cagirdik
            let user = User(uid: uid, dictionary: dictionary)
            // completion koymazsan fetchUser tamamlanmaz ve burada kalir app
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([User]) -> Void){
        var users = [User]()
        REF_USERS.observe(.childAdded) { (snapshot) in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String: AnyObject] else {return}
            let user = User(uid: uid, dictionary: dictionary)
            users.append(user)
            completion(users)
        }
    }
}
