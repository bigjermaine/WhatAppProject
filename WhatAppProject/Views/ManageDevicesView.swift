import SwiftUI

struct ManageDevicesView: View {
    @State private var showAddTrustedSheet = false
    @State private var showRemoveLoginSheet = false

    var body: some View {
        List {
            Button {
                showAddTrustedSheet = true
            } label: {
                HStack {
                    Text("Add as trusted device")
                        .foregroundStyle(.primary)
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))

            Button {
                showRemoveLoginSheet = true
            } label: {
                HStack(alignment: .firstTextBaseline) {
                    Text("Remove login access and delete this device from your approved devices")
                        .foregroundStyle(.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Spacer()
                }
                .contentShape(Rectangle())
            }
            .listRowInsets(EdgeInsets(top: 12, leading: 16, bottom: 12, trailing: 16))
        }
        .listStyle(.plain)
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
        .sheet(isPresented: $showAddTrustedSheet) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center) {
                    Text("Add as trusted device")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: { showAddTrustedSheet = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    .buttonStyle(.plain)
                }

                Text("This shows the device currently signed in to your account.")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)

                Button {
                    // Handle Add action
                    showAddTrustedSheet = false
                } label: {
                    Text("Add")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.blue)
                        )
                }
            }
            .padding(20)
            .presentationDetents([.height(240), .medium])
            .presentationDragIndicator(.visible)
        }
        .sheet(isPresented: $showRemoveLoginSheet) {
            VStack(alignment: .leading, spacing: 16) {
                HStack(alignment: .center) {
                    Text("Remove login")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Button(action: { showRemoveLoginSheet = false }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 8, style: .continuous)
                                    .fill(Color(.systemGray6))
                            )
                    }
                    .buttonStyle(.plain)
                }

                Text("Remove login access and delete this device from your approved devices")
                    .font(.system(size: 15))
                    .foregroundStyle(.secondary)

                Button {
                    // Handle Remove action
                    showRemoveLoginSheet = false
                } label: {
                    Text("Remove")
                        .font(.system(size: 16, weight: .semibold))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .foregroundStyle(.white)
                        .background(
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(Color.red)
                        )
                }
            }
            .padding(20)
            .presentationDetents([.height(260), .medium])
            .presentationDragIndicator(.visible)
        }
    }
    
    }

#Preview {
    NavigationStack { ManageDevicesView() }
}
