//
//  SelectHotelRoomCell.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 17/06/2025.
//


import UIKit
import SDWebImage
import SwiftUI

class SelectHotelRoomCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  
  static let identifier = "SelectHotelRoomCell"
  
  var likeButtonAction: (() -> Void)?
  
  private var images: [UIImage] = []
  
  private var currentImageIndex = 0
  
  private var imagesGallery: [Gallery] = []
  
  var marketItems:[MarketPlaces] = []
  var marketItem:MarketPlaces?
  
  
  var isLiked:Bool = false {
      didSet {
          likeButton.setImage(isLiked ? UIImage(named: "like") : UIImage(named: "unlike_white"), for: .normal)
      }
  }
  private let horinzontalCollectionView: UICollectionView = {
      let layout = UICollectionViewFlowLayout()
      layout.scrollDirection = .horizontal
      layout.minimumLineSpacing = 0
      let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
      collectionView.translatesAutoresizingMaskIntoConstraints = false
      collectionView.showsHorizontalScrollIndicator = false
      collectionView.isPagingEnabled = true
      return collectionView
  }()
  

  let likeButton: UIButton = {
     let button = UIButton()
     button.setImage(UIImage(named: "unlike_white"), for: .normal)
     button.translatesAutoresizingMaskIntoConstraints = false
     return button
 }()
 
 public let likeBackgroundView: UIView = {
     let selectionView = UIView()
     selectionView.translatesAutoresizingMaskIntoConstraints = false
     selectionView.layer.cornerRadius = 23
     selectionView.clipsToBounds = true
     let blurEffect = UIBlurEffect(style: .light)
     let blurEffectView = UIVisualEffectView(effect: blurEffect)
     blurEffectView.frame = selectionView.bounds
     blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
     blurEffectView.layer.cornerRadius = 23
     blurEffectView.translatesAutoresizingMaskIntoConstraints = false
     blurEffectView.clipsToBounds = true
     selectionView.addSubview(blurEffectView)
     return selectionView
 }()

 
 let restaurantImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      imageView.layer.cornerRadius = 4
      imageView.layer.masksToBounds = true
      imageView.image = UIImage(named:"save_diary_3")
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
  }()
  
  let fowardButton: UIButton = {
      let button = UIButton()
      button.setImage(UIImage(named: "icn_next_arrow"), for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
  }()
  
  let backButton: UIButton = {
      let button = UIButton()
      button.setImage(UIImage(named: "icn_prev_arrow"), for: .normal)
      button.translatesAutoresizingMaskIntoConstraints = false
      return button
  }()
  var titleLabel: UILabel = {
      let label = UILabel()
      label.numberOfLines = 1
      label.text = "Ocean view suite"
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  
  
  var statusLabel: UILabel = {
      let label = UILabel()
      label.textAlignment = .right
      label.numberOfLines = 1
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  
  var descriptionLabel: UILabel = {
      let label = UILabel()
      label.textAlignment = .left
      label.numberOfLines = 1
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  
  var galleryImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.image = UIImage(systemName: "person")
      imageView.clipsToBounds = true
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
  }()
    
    var galleryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.text = "View gallery"
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
  
  var locationImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      imageView.image = UIImage(named: "mapMarketLocation")
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
  }()
  
  let placeIconImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFit
      imageView.clipsToBounds = true
      imageView.image = UIImage(named: "ForkKnife")
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
  }()
  
  
  let ratingImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      imageView.image = UIImage(named: "icn_star")
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
  }()

  
  let cultleryImageView: UIImageView = {
      let imageView = UIImageView()
      imageView.contentMode = .scaleAspectFill
      imageView.clipsToBounds = true
      imageView.image = UIImage(named: "ForkKnife")
      imageView.translatesAutoresizingMaskIntoConstraints = false
      return imageView
  }()
  
  let ratingLabel: UILabel = {
      let label = UILabel()
      label.textAlignment = .right
      label.text = ""
      label.numberOfLines = 1
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  
  let moneyLabel: UILabel = {
      let label = UILabel()
      label.textAlignment = .right
      label.numberOfLines = 1
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  let countryLabel: UILabel = {
      let label = UILabel()
      label.textAlignment = .left
      label.numberOfLines = 1
      label.translatesAutoresizingMaskIntoConstraints = false
      return label
  }()
  private let contentContainerView: UIView = {
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      view.clipsToBounds = true
      return view
  }()
  private var reserveButton: UIButton = {
      let button = UIButton()
      button.translatesAutoresizingMaskIntoConstraints = false
      button.setTitle("Reserve a Table", for: .normal)
      button.layer.cornerRadius = 4
      button.isUserInteractionEnabled = true
      return button
  }()
  
  public  let controlBackgroundView: UIView = {
      let selectionView = UIView()
      selectionView.translatesAutoresizingMaskIntoConstraints = false
      selectionView.clipsToBounds = true
      selectionView.layer.cornerRadius = 4
      let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.light)
      let blurEffectView = UIVisualEffectView(effect: blurEffect)
      blurEffectView.clipsToBounds = true
      blurEffectView.frame = selectionView.bounds
      blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
      blurEffectView.layer.cornerRadius = 4
      selectionView.addSubview(blurEffectView)
      selectionView.layer.cornerRadius = 4
      return selectionView
  }()
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
      setupCollectionView()
      addsubViews()
      configureHorizontalCollectionView()
      setupActions()
      reserveButton.addTarget(self, action: #selector(didTapReserve), for: .touchUpInside)
  }
  
  @objc private func didTapReserve() {
      if let viewModel = marketItem {
       
      }
    
  }
  @objc private func didTapLike() {
         likeButtonAction?()
       
     }
  
  func addsubViews() {
      contentView.addSubview(horinzontalCollectionView)
      contentView.addSubview(controlBackgroundView)
      contentView.addSubview(backButton)
      contentView.addSubview(fowardButton)
      contentView.addSubview(contentContainerView)
      contentView.addSubview(titleLabel)
      contentView.addSubview(galleryImageView)
      contentView.addSubview(galleryLabel)
//      contentView.addSubview(statusLabel)
//      contentView.addSubview(descriptionLabel)
//      contentView.addSubview(placeIconImageView)
//      contentView.addSubview(countryLabel)
//      contentView.addSubview(ratingLabel)
//      contentView.addSubview(moneyLabel)
//      contentView.addSubview(reserveButton)
//      contentView.addSubview(timeImageView)
//      contentView.addSubview(locationImageView)
//      contentView.addSubview(ratingImageView)
      
  }
  
  private func setupActions() {
      backButton.addTarget(self, action: #selector(previousButtonAction), for: .touchUpInside)
      fowardButton.addTarget(self, action: #selector(nextButtonAction), for: .touchUpInside)
  }
  
  func configureHorizontalCollectionView() {
      NSLayoutConstraint.activate([
          horinzontalCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
          horinzontalCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
          horinzontalCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
          horinzontalCollectionView.heightAnchor.constraint(equalToConstant: 206),
          
        
          controlBackgroundView.bottomAnchor.constraint(equalTo:horinzontalCollectionView.bottomAnchor,constant:-18),
          controlBackgroundView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor,constant:0),
          controlBackgroundView.widthAnchor.constraint(equalToConstant: 132),
          controlBackgroundView.heightAnchor.constraint(equalToConstant: 44),
          
          backButton.widthAnchor.constraint(equalToConstant: 32),
          backButton.leadingAnchor.constraint(equalTo: controlBackgroundView.leadingAnchor,constant: 13),
          backButton.heightAnchor.constraint(equalToConstant: 32),
          backButton.centerYAnchor.constraint(equalTo: controlBackgroundView.centerYAnchor),
          
          fowardButton.widthAnchor.constraint(equalToConstant: 32),
          fowardButton.trailingAnchor.constraint(equalTo: controlBackgroundView.trailingAnchor,constant: -13),
          fowardButton.heightAnchor.constraint(equalToConstant: 32),
          fowardButton.centerYAnchor.constraint(equalTo: controlBackgroundView.centerYAnchor),
          
          contentContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
          contentContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
          contentContainerView.heightAnchor.constraint(equalToConstant: 180),
          contentContainerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),

          titleLabel.topAnchor.constraint(equalTo:contentContainerView.topAnchor, constant: 14),
          titleLabel.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant:12),
          titleLabel.trailingAnchor.constraint(equalTo: contentContainerView.centerXAnchor, constant: -10),
          
          galleryImageView.centerYAnchor.constraint(equalTo:galleryLabel.centerYAnchor),
          galleryImageView.heightAnchor.constraint(equalToConstant: 12),
          galleryImageView.widthAnchor.constraint(equalToConstant: 12),
          galleryImageView.trailingAnchor.constraint(equalTo: galleryLabel.leadingAnchor,constant: -2),

          galleryLabel.topAnchor.constraint(equalTo:contentContainerView.topAnchor, constant: 14),
          galleryLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant:-12),
          galleryLabel.leadingAnchor.constraint(equalTo: galleryImageView.trailingAnchor, constant: 2),
      
          
         
//          
//          locationImageView.centerYAnchor.constraint(equalTo: descriptionLabel.centerYAnchor),
//          locationImageView.heightAnchor.constraint(equalToConstant: 32),
//          locationImageView.widthAnchor.constraint(equalToConstant: 32),
//          locationImageView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant:12),
//          
//          descriptionLabel.topAnchor.constraint(equalTo:titleLabel.bottomAnchor, constant: 11),
//          descriptionLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant:-12),
//          descriptionLabel.leadingAnchor.constraint(equalTo: locationImageView.trailingAnchor, constant: 10),
//          placeIconImageView.centerYAnchor.constraint(equalTo:countryLabel.centerYAnchor, constant: 0),
//          
//          placeIconImageView.heightAnchor.constraint(equalToConstant: 14),
//          placeIconImageView.widthAnchor.constraint(equalToConstant: 14),
//          placeIconImageView.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant:12),
//          placeIconImageView.centerYAnchor.constraint(equalTo:ratingLabel.centerYAnchor, constant: 0),
//          
//          countryLabel.topAnchor.constraint(equalTo:descriptionLabel.bottomAnchor, constant: 11),
//          countryLabel.trailingAnchor.constraint(equalTo: ratingImageView.leadingAnchor, constant:-3),
//          countryLabel.leadingAnchor.constraint(equalTo: placeIconImageView.trailingAnchor, constant: 4),
//      
//          ratingImageView.centerYAnchor.constraint(equalTo:ratingLabel.centerYAnchor, constant: 0),
//          ratingImageView.heightAnchor.constraint(equalToConstant: 16),
//          ratingImageView.widthAnchor.constraint(equalToConstant: 16),
//          ratingImageView.trailingAnchor.constraint(equalTo: ratingLabel.leadingAnchor, constant:-4),
//          
//          ratingLabel.topAnchor.constraint(equalTo:descriptionLabel.bottomAnchor, constant: 11),
//          ratingLabel.trailingAnchor.constraint(equalTo: moneyLabel.leadingAnchor, constant:-4),
//          ratingLabel.leadingAnchor.constraint(equalTo: ratingImageView.trailingAnchor, constant: 4),
//          
//          moneyLabel.topAnchor.constraint(equalTo:descriptionLabel.bottomAnchor, constant: 11),
//          moneyLabel.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant:-12),
//          moneyLabel.widthAnchor.constraint(equalToConstant: 48),
//          
//          reserveButton.topAnchor.constraint(equalTo:ratingImageView.bottomAnchor, constant: 11),
//          reserveButton.heightAnchor.constraint(equalToConstant: 48),
//          reserveButton.trailingAnchor.constraint(equalTo: contentContainerView.trailingAnchor, constant:-12),
//          reserveButton.leadingAnchor.constraint(equalTo: contentContainerView.leadingAnchor, constant:12),

      ])
  }
  required init?(coder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
    
  private func setupCollectionView() {
      horinzontalCollectionView.delegate = self
      horinzontalCollectionView.dataSource = self
      horinzontalCollectionView.register(MarketPlaceImageCell.self, forCellWithReuseIdentifier: "RestaurantImageCell")
  }
    
  func configure(with viewModel: MarketPlaces,type:MarketPlaceItemType) {
      marketItem = viewModel
      imagesGallery = viewModel.restaurantGallery ?? []
      horinzontalCollectionView.reloadData()
      countryLabel.text = viewModel.vendorAccount.businessName
      descriptionLabel.text = viewModel.vendorAccount.businessAddress
      ratingLabel.text = "\(viewModel.averageRating ?? 0) (\(viewModel.noOfRatings ?? 0)) ."
      titleLabel.text = viewModel.vendorAccount.businessName
      configurePriceRange(viewModel.vendorAccount.restaurantPriceRange)
      currentImageIndex = 0
      updateButtons()
      configureLike(viewModel: viewModel)
     
      
  }
  
  func configureLike(viewModel:MarketPlaces) {
      if marketItems.firstIndex(where: { $0.id == viewModel.id }) != nil {
          isLiked = true
      }else{
          isLiked =  false
      }
  }
  
 
  private func configurePriceRange(_ priceRange: String?) {
      let price: String
      switch priceRange {
      case "mid-range":
          price = "$$"
      case "budget-friendly":
          price = "$"
      default:
          price = "$$$"
      }
      moneyLabel.text = price
  }

  private func updateButtons() {
      backButton.isEnabled = currentImageIndex > 0
      fowardButton.isEnabled = currentImageIndex < imagesGallery.count - 1
  }
  
  // UICollectionView DataSource and Delegate Methods
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
      return 4
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      return CGSize(width: collectionView.frame.width, height: 206)
  }
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
      guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantImageCell", for: indexPath)  as? MarketPlaceImageCell else {return UICollectionViewCell()}
      cell.configure(imageUrl: "https://images.pexels.com/photos/414171/pexels-photo-414171.jpeg")
      return cell
  }
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
  }
  
  @objc private func previousButtonAction() {
      guard !imagesGallery.isEmpty else { return }
      let previousIndex = max(currentImageIndex - 1, 0)
      if previousIndex != currentImageIndex {
          currentImageIndex = previousIndex
          horinzontalCollectionView.scrollToItem(at: IndexPath(item: currentImageIndex, section: 0), at: .centeredHorizontally, animated: true)
          updateButtons()
      }
  }
  
  @objc private func nextButtonAction() {
      guard !imagesGallery.isEmpty else { return }
      let nextIndex = min(currentImageIndex + 1, imagesGallery.count - 1)
      if nextIndex != currentImageIndex {
          currentImageIndex = nextIndex
          horinzontalCollectionView.scrollToItem(at: IndexPath(item: currentImageIndex, section: 0), at: .centeredHorizontally, animated: true)
          updateButtons()
      }
  }
}

#Preview {
  SelectHotelRoomCell().showLivePreview()
}

enum MarketPlaceItemType: String {
  case flights = "Flights"
  case hotels = "Hotels"
  case restaurants = "Restaurants"
  case nightLife = "Night Life"
  case activities = "Activities"
  case vacationPackages = "Vacation Packages"
  case medical = "Medical"
  case visa = "Visa"
  case immigration = "Immigration"
  case study = "Study"
  case tourism = "Tourism"
  case agencies = "Agencies"
  
 
}
