import SwiftUI

struct OrderStatusBottomSheetView: View {
    enum Status: String, CaseIterable {
        case requestReceived = "Request received"
        case assigned = "Assigned"
        case inProgress = "In progress"
        case completed = "Completed"
        
        var color: Color {
            switch self {
            case .requestReceived:
                return Color(red: 0.75, green: 0.85, blue: 1.0) // soft blue
            case .assigned:
                return Color(red: 0.88, green: 0.81, blue: 1.0) // soft purple
            case .inProgress:
                return Color(red: 1.0, green: 0.89, blue: 0.73) // soft orange
            case .completed:
                return Color(red: 0.84, green: 0.97, blue: 0.88) // soft green
            }
        }
        
        var foreground: Color {
            switch self {
            case .requestReceived:
                return Color(red: 0.16, green: 0.32, blue: 0.60) // blue text
            case .assigned:
                return Color(red: 0.46, green: 0.21, blue: 0.84) // purple text
            case .inProgress:
                return Color(red: 0.75, green: 0.50, blue: 0.09) // orange text
            case .completed:
                return Color(red: 0.22, green: 0.57, blue: 0.31) // green text
            }
        }
    }
    
    struct Item: Identifiable {
        let id = UUID()
        let name: String
        let price: String
    }
    
    let orderNumber: String
    let status: Status
    let items: [Item]
    let onClose: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            // Handle bar
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.18))
                .frame(width: 56, height: 6)
                .padding(.top, 8)
                .padding(.bottom, 12)

            HStack {
                Text("Order details - #\(orderNumber)")
                    .font(.headline)
                Spacer()
                Button(action: onClose) {
                    Image(systemName: "xmark")
                        .padding(10)
                        .background(Color.gray.opacity(0.10))
                        .clipShape(Circle())
                }
                .accessibilityLabel("Close")
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
            
            Divider()
                .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 14) {
                // Status badge
                Text(status.rawValue)
                    .font(.subheadline.weight(.semibold))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(status.color)
                    .foregroundColor(status.foreground)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                    .padding(.top, 16)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(items) { item in
                        HStack {
                            Text("• \(item.name)")
                                .font(.body.weight(.medium))
                                .foregroundColor(.black.opacity(status == .requestReceived ? 0.7 : 0.95))
                            Spacer()
                            Text(item.price)
                                .font(.body.weight(.semibold))
                                .foregroundColor(.black.opacity(status == .requestReceived ? 0.7 : 0.85))
                        }
                    }
                }
                .padding(.bottom, 10)
            }
            .padding(18)
            
            
            Spacer(minLength: 0)
        }
        .background(Color.white)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    VStack {
        Spacer()
        OrderStatusBottomSheetView(
            orderNumber: "1012374682",
            status: .requestReceived,
            items: [
                .init(name: "1 x Linen", price: "₦1200"),
                .init(name: "2 x Toppers", price: "₦1200")
            ],
            onClose: {}
        )
        
      
    }
    .background(Color.gray.opacity(0.22))
    .ignoresSafeArea()
}
