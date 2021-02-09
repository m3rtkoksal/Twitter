//
//  ProfileHeader.swift
//  TwitterTutorial
//
//  Created by Mert Köksal on 2.02.2021.
//

import UIKit

protocol ProfileHeaderDelegate: class {
    func handleDismissal()
}

class ProfileHeader: UICollectionReusableView {
    
    // MARK: - Properties
    
    var user: User? {
        didSet {
            configure()
        }
    }
    
    weak var delegate: ProfileHeaderDelegate?
    
    private let filterBar = ProfileFilterView()
    
    private lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        view.addSubview(backButton)
        backButton.anchor(
            top: view.topAnchor,
            left: view.leftAnchor,
            paddingTop: 42,
            paddingLeft: 16)
        return view
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "baseline_arrow_back_white_24dp").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        return button
    }()
    
    private lazy var profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleToFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 24
        iv.backgroundColor = .lightGray
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderWidth = 4
        iv.layer.cornerRadius = 80 / 2
        return iv
    }()
    
    private lazy var editProfileButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitle("Loading", for: .normal)
        button.layer.borderColor = UIColor.twitterBlue.cgColor
        button.layer.borderWidth = 1.25
        button.layer.cornerRadius = 36 / 2
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.twitterBlue, for: .normal)
        button.addTarget(self, action: #selector(handleEditProfileFollow), for: .touchUpInside)
        return button
    }()
    
    private let bioLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.numberOfLines = 3
        label.text = "This is a user bio that will span more than one line for test purposes"
        return label
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .lightGray
        return label
    }()
    
    private let underlineView: UIView = {
        let view = UIView()
        view.backgroundColor = .twitterBlue
        return view
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowingTapped))
        label.addGestureRecognizer(followTap)
        return label
    }()
    
    private let followersLabel: UILabel = {
        let label = UILabel()
        let followTap = UITapGestureRecognizer(target: self, action: #selector(handleFollowersTapped))
        label.addGestureRecognizer(followTap)
        return label
    }()
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        filterBar.delegate = self
        
        addSubview(containerView)
        containerView.anchor(
            top: topAnchor,
            left: leftAnchor,
            right: rightAnchor,
            height: 108
        )
        addSubview(profileImageView)
        profileImageView.anchor(
            top: containerView.bottomAnchor,
            left: leftAnchor,
            paddingTop: -24,
            paddingLeft: 8
        )
        profileImageView.setDimensions(width: 80, height: 80)
        
        
        addSubview(editProfileButton)
        editProfileButton.anchor(
            top: containerView.bottomAnchor,
            right: rightAnchor,
            paddingTop: 12,
            paddingRight: 12
        )
        editProfileButton.setDimensions(width: 100, height: 36)
        
        let userDetailStack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel, bioLabel])
        userDetailStack.axis = .vertical
        userDetailStack.distribution = .fillProportionally
        userDetailStack.spacing = 4
        
        addSubview(userDetailStack)
        userDetailStack.anchor(
            top: profileImageView.bottomAnchor,
            left:leftAnchor,
            right: rightAnchor,
            paddingTop: 8,
            paddingLeft: 12,
            paddingRight: 12)
        
        let followStack = UIStackView(arrangedSubviews: [followingLabel, followersLabel])
        followStack.axis = .horizontal
        followStack.spacing = 8
        followStack.distribution = .fillEqually
        
        addSubview(followStack)
        followStack.anchor(
            top: userDetailStack.bottomAnchor,
            left: leftAnchor,
            paddingTop: 8,
            paddingLeft: 12
        )
        
        addSubview(filterBar)
        filterBar.anchor(
            left: leftAnchor,
            bottom: bottomAnchor,
            right: rightAnchor,
            height: 50
        )
        
        addSubview(underlineView)
        underlineView.anchor(
            left: leftAnchor,
            bottom: bottomAnchor,
            width: frame.width / CGFloat(ProfileFilterOptions.allCases.count),
            height: 2
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleDismissal() {
        delegate?.handleDismissal()
    }
    
    @objc func handleEditProfileFollow() {
        
    }
    
    @objc func handleFollowingTapped() {
        
    }
    
    @objc func handleFollowersTapped() {
        
    }
    
    // MARK: - Helpers
    
    func configure() {
        guard let user = user else {return}
        let viewModel = ProfileHeaderViewModel(user: user)
        profileImageView.sd_setImage(with: user.profileImageUrl, completed: nil)
        followersLabel.attributedText = viewModel.followersString
        followingLabel.attributedText = viewModel.followingString
        editProfileButton.setTitle(viewModel.actionButtonTitle, for: .normal)
        fullnameLabel.text = user.fullname
        usernameLabel.text = viewModel.usernameText
    }
}

    // MARK: - ProfileFilterViewDelegate

extension ProfileHeader: ProfileFilterViewDelegate {
    func filterView(_ view: ProfileFilterView, didSelect indexPath: IndexPath) {
        guard let cell = view.collectionView.cellForItem(at: indexPath) as? ProfileFilterCell else {return}
        let xPosition = cell.frame.origin.x
        UIView.animate(withDuration: 0.3) {
            self.underlineView.frame.origin.x = xPosition
        }
    }
}
