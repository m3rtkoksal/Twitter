//
//  FeedController.swift
//  TwitterTutorial
//
//  Created by Mert Köksal on 26.01.2021.
//

import UIKit
import SDWebImage

private let reuseIdentifier = "TweetCell"

class FeedController: UICollectionViewController {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            print("DEBUG: Did set user in feed controller")
            // bunu viewdidload icinde cagirirsak api yuklemesi uzun surecegi icin resim gozukmez o yuzden didset icerisinde cagirip userin geldigine emin oluyoruz.
            configureLeftBarButton()
        }
    }
    
    private var tweets = [Tweet]() {
        didSet {
            // first tweets is 0 element array. It takes time to fetch tweets. But at that time ui is already visible. So with reload didset we are showing it
            collectionView.reloadData()
        }
    }
    
    // MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets { (tweets) in
            print("DEBUG: Tweets are \(tweets)")
            print("DEBUG: Number of Tweets are \(tweets.count)")
            self.tweets = tweets
        }
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchTweets()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // saat ve pil beyaz text
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.backgroundColor = .white
        
        let imageView = UIImageView(image: UIImage(named: "twitter_logo_blue"))
        imageView.contentMode = .scaleAspectFit
        imageView.setDimensions(width: 44, height: 44)
        navigationItem.titleView = imageView
        
    }
    
    func configureLeftBarButton() {
        //make sure user exists
        guard let user = user else {return}
        
        let profileImageView = UIImageView()
        profileImageView.setDimensions(width: 32, height: 32)
        profileImageView.layer.cornerRadius = 32 / 2
        profileImageView.layer.masksToBounds = true
        //maintabcontrollerdan gelen userin profileimageurli
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: profileImageView)
    }
}

// MARK: - UICollectionViewDelegate/Datasource

extension FeedController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TweetCell", for: indexPath) as! TweetCell
        
        // bunu yapmazsak nanay
        cell.delegate = self
        
        
        cell.tweet = tweets[indexPath.row]
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
    }
}


// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 120)
    }
}

extension FeedController: TweetCellDelegate {
    func handleProfileImageTapped(_ cell: TweetCell) {
        print("DEBUG: Handle profile image tapped in controller")
//        let controller = ProfileController(collectionViewLayout: UICollectionViewFlowLayout())
        
        // feedcontrollerdan profilecontrollera user data transferi burada
        
        guard let user = cell.tweet?.user else {return}
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}


