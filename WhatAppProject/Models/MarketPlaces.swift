//
//  MarketPlaces.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 18/06/2025.
//


import Foundation


protocol SectionItem {
   
}


struct MarketPlaces: Codable,SectionItem {
    let agentSlug: String
    var noOfRatings: Int?
    let id: Int
    let isOpen: Int
    var restaurantGallery: [Gallery]?
    let vendorAccount: VendorAccount
    let averageRating: Double?
    var cuisineData: [Cuisine]?
    var isLiked: Bool?
    
    enum CodingKeys: String, CodingKey {
        case agentSlug = "agent_slug"
        case noOfRatings = "no_of_ratings"
        case id
        case isOpen = "is_open"
        case restaurantGallery = "restaurant_gallery"
        case vendorAccount = "vendor_account"
        case averageRating = "average_rating"
        case cuisineData = "cuisine_data"
        case isLiked = "isLiked"
    }
}
    
    
    struct Cuisine: Codable {
        let id: Int
        let updatedAt: String
        let name: String
        let createdAt: String
        
        enum CodingKeys: String, CodingKey {
            case id, name
            case updatedAt = "updated_at"
            case createdAt = "created_at"
        }
    }
    struct Gallery: Codable {
        let imageURL: String
        enum CodingKeys: String, CodingKey {
        case imageURL = "image_url"
        }
    }

struct CityAgent: Codable,SectionItem {
    let id: Int
    let agentSlug: String
    let isOpen: Int?
    let vendorAccount: VendorAccount
    enum CodingKeys: String, CodingKey {
        case id
        case agentSlug = "agent_slug"
        case isOpen = "is_open"
        case vendorAccount = "vendor_account"
    }
}

struct VendorAccount: Codable {
    let id, userID, agentID: Int?
    let agentRoleID: Int?
    let accountTypeID, businessID: Int?
    let businessName, businessEmail, businessAddress: String?
    let businessCertificate: String?
    let agentURL: String?
    let businessBannerImage: String?
    let businessLogoImage: String?
    let businessDescription: String?
    let restaurantPriceRange: String?
    let operatingHours: [OperatingHour]?
    var restaurantType: String?
    let organizationTypeID: Int?
  let agentOnboardedAt: String?
  let onlineStatus: String?
  let chatBotStatus: Int?

//    let travelServices, googlePageLink, socialAccounts: String?
//    let accountStatus: Int
//    let propertyOwnershipCertificate: String?
//    let additionalDocuments: [String]?
//    let hotelStarRating, hotelChannelManager: String?
//    let buildingNumber, street: String?
//    let countryID, stateID, cityID: Int
//    let zipCode: String?
//
    
    
//    let restaurantOptions: [Int]
//    let restaurantReservationRequired, isBoarded, boardingStage: Int
//    let createdAt, updatedAt, deletedAt, suspendedAt: String?
//    let suspendedUntil: String?
//    let businessPhone: String
//    let agentSecretKey: String?
//    let agentType: String
//    let agentVerifiedAt: Bool
//    let businessVerificationStatus, agentOnboardedAt: String
//    let businessWebsite: String
//    let cuisines, dietaryRestrictions: [Int]
  
//    let channelManagerID, channelHotelID: String?
//    let userRole: String?
//    let businessEmailVerifiedAt, businessPhoneVerifiedAt: String?

    enum CodingKeys: String, CodingKey {
        case id
        case userID = "user_id"
        case agentID = "agent_id"
        case agentRoleID = "agent_role_id"
        case accountTypeID = "account_type_id"
        case businessID = "business_id"
        case businessName = "business_name"
        case businessEmail = "business_email"
        case businessAddress = "business_address"
        case businessCertificate = "business_certificate"
        case agentURL = "agent_url"
        case businessBannerImage = "business_banner_image"
        case businessLogoImage = "business_logo_image"
        case businessDescription = "business_description"
        case restaurantPriceRange = "restaurant_price_range"
        case operatingHours = "operating_hours"
        case restaurantType  =  "restaurant_type"
        case organizationTypeID = "organization_type_id"
      case agentOnboardedAt = "agent_onboarded_at"
      case onlineStatus = "online_status"
      case chatBotStatus = "chat_bot_status"

//        case travelServices = "travel_services"
//        case googlePageLink = "google_page_link"
//        case socialAccounts = "social_accounts"
//        case accountStatus = "account_status"
//        case propertyOwnershipCertificate = "property_ownership_certificate"
//        case additionalDocuments = "additional_documents"
//        case hotelStarRating = "hotel_star_rating"
//        case hotelChannelManager = "hotel_channel_manager"
//        case buildingNumber = "building_number"
//        case street
//        case countryID = "country_id"
//        case stateID = "state_id"
//        case cityID = "city_id"
//        case zipCode = "zip_code"
//        case coreService = "core_service"
//        case restaurantType = "restaurant_type"
      
//        case restaurantOptions = "restaurant_options"
//        case restaurantReservationRequired = "restaurant_reservation_required"
//        case isBoarded = "is_boarded"
//        case boardingStage = "boarding_stage"
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case deletedAt = "deleted_at"
//        case suspendedAt = "suspended_at"
//        case suspendedUntil = "suspended_until"
//        case businessPhone = "business_phone"
//        case agentSecretKey = "agent_secret_key"
//        case agentType = "agent_type"
//        case agentVerifiedAt = "agent_verified_at"
//        case businessVerificationStatus = "business_verification_status"
//        case businessWebsite = "business_website"
//        case cuisines
//        case dietaryRestrictions = "dietary_restrictions"
     
//        case channelManagerID = "channel_manager_id"
//        case channelHotelID = "channel_hotel_id"
//        case userRole = "user_role"
//        case businessEmailVerifiedAt = "business_email_verified_at"
//        case businessPhoneVerifiedAt = "business_phone_verified_at"
       
    }
}

struct OperatingHour: Codable,SectionItem {
    let name: String
    let isOpen: Bool
    let checkIn: CheckIn

    enum CodingKeys: String, CodingKey {
        case name
        case isOpen = "isOpen"
        case checkIn = "checkIn"
    }
}

struct CheckIn: Codable {
    let to: String?
    let from: String?
}
