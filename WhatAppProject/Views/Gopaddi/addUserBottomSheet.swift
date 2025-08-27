//
//  addUserBottomSheet.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 25/08/2025.
//

import SwiftUI

struct User1: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let handle: String
    let imageName: String
}


struct AddUsersBottomSheet: View {
    @State private var selectedUsers: [User1] = []
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    
  private let users = [
        User1(name: "Busayo B", handle: "@busayo", imageName: "person1"),
        User1(name: "Ade Oluwak", handle: "@adeoluwa", imageName: "person2"),
        User1(name: "Matthew Lawrence", handle: "@busayo", imageName: "person3"),
        User1(name: "Sarah King", handle: "@sarah", imageName: "person4"),
        User1(name: "James Doe", handle: "@james", imageName: "person5")
    ]
    
    var filteredUsers: [User1] {
        if searchText.isEmpty {
            return users
        } else {
            return users.filter {
                $0.name.localizedCaseInsensitiveContains(searchText) ||
                $0.handle.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
      VStack{
        HStack{
          Spacer()
          Image("handleDrag")
          Spacer()
        }
        VStack(spacing: 16) {
          if !selectedUsers.isEmpty {
            ScrollView(.horizontal, showsIndicators: false) {
              HStack {
                ForEach(selectedUsers, id: \.id) { user in
                  HStack(spacing: 8) {
                    Image(user.imageName)
                      .resizable()
                      .scaledToFill()
                      .frame(width: 24, height: 24)
                      .clipShape(Circle())
                    
                    Text(user.name)
                      .font(Font(UIFont.satoshi( weight: .medium, size: 14)))
                      .lineLimit(1)
                    
                    Button(action: {
                      removeUser(user)
                    }) {
                      Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .font(.system(size: 14))
                    }
                  }
                  .padding(.horizontal, 10)
                  .padding(.vertical, 6)
                  .background(Color.gray.opacity(0.2))
                  .cornerRadius(16)
                }
              }
              .padding(.horizontal)
            }
            .padding(.top)
          }
          
          // Title
          HStack{
            Text("Add users")
              .font(Font(UIFont.satoshi( weight: .semibold, size: 16)))
              .frame(maxWidth: .infinity, alignment: .leading)
              
            Spacer()
            
            Image("DMPlaceCloseButton")
              .resizable()
              .frame(width: 30, height: 30)
            
          }
          .padding(.horizontal)
          Divider()
            .padding(8)
          
          // Search Field
          HStack {
            Image(systemName: "magnifyingglass")
              .foregroundColor(.gray)
            
            TextField("Search users", text: $searchText)
              .focused($isSearchFocused)
              .textFieldStyle(.plain)
          }
          .padding(10)
          .background(
            RoundedRectangle(cornerRadius: 8)
              .stroke(isSearchFocused ? Color.blue : Color.gray.opacity(0.3), lineWidth: 1)
          )
          .padding(.horizontal)
          
          // User list
          List {
            ForEach(filteredUsers) { user in
              HStack {
                Image(user.imageName)
                  .resizable()
                  .scaledToFill()
                  .frame(width: 40, height: 40)
                  .clipShape(Circle())
                
                VStack(alignment: .leading) {
                  Text(user.name)
                    .font(Font(UIFont.satoshi( weight: .medium, size: 14)))
                  Text(user.handle)
                    .font(Font(UIFont.satoshi( weight: .medium, size: 10)))
                    .foregroundColor(.gray)
                }
                Spacer()
                
                if selectedUsers.contains(user) {
                  Image(systemName: "checkmark.square.fill")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
                } else {
                  Image(systemName: "square")
                    .resizable()
                    .foregroundColor(.gray)
                    .frame(width: 24, height: 24)
                  
                }
              }
              .contentShape(Rectangle())
              .onTapGesture {
                toggleSelection(for: user)
              }
              .listRowSeparator(.hidden)
            }
          }
          .listStyle(.plain)
          
          // Next button
          Button(action: {
            print("Selected users: \(selectedUsers.map { $0.name })")
          }) {
            Text("Next")
              .frame(maxWidth: .infinity)
              .padding()
              .foregroundColor(.white)
              .background(Color.blue)
              .cornerRadius(10)
          }
          .padding(.horizontal)
        }
        .padding(.top)
      }
    }
    private func toggleSelection(for user: User1) {
        if let index = selectedUsers.firstIndex(of: user) {
            selectedUsers.remove(at: index)
        } else {
            selectedUsers.append(user)
        }
    }
    
    private func removeUser(_ user: User1) {
        if let index = selectedUsers.firstIndex(of: user) {
            selectedUsers.remove(at: index)
        }
    }
}

#Preview {
    AddUsersBottomSheet()
}
