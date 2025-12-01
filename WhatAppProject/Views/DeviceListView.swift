//
//  DeviceListView.swift
//  WhatAppProject
//
//  Created by Daniel Jermaine on 12/11/2025.
//


import SwiftUI

struct Device: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let status: String?
    let isActive: Bool
}

struct DeviceListView: View {
    private let devices: [Device] = [
        Device(title: "Google Chrome", subtitle: "Windows 10", status: "Currently Active", isActive: true),
        Device(title: "Samsung A23", subtitle: "Android 13", status: nil, isActive: false)
    ]

    var body: some View {
        NavigationStack {
            List {
                ForEach(devices) { device in
                    DeviceRowView(
                        title: device.title,
                        subtitle: device.subtitle,
                        status: device.status,
                        isActive: device.isActive
                    )
                    .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
                    .listRowSeparator(.visible)
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color(.systemBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    NavigationLink {
                        ManageDevicesView()
                    } label: {
                        HStack(spacing: 6) {
                            Image(systemName: "chevron.left")
                            Text("Manage Devices")
                        }
                    }
                }
            }
        }
    }
}

struct DeviceRowView: View {
    var title: String
    var subtitle: String
    var status: String?
    var isActive: Bool
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text(subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(.gray)
                
                if let status = status, isActive {
                    Text(status)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.green)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .padding(8)
                        .background(Color.green.opacity(0.1))
                        .cornerRadius(6)
                        
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
    }
}

#Preview {
    DeviceListView()
}
