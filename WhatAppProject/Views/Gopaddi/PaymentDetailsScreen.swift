import SwiftUI

struct PaymentDetailsScreen: View {
    // Inputs
    let amount: String
    let onProceed: () -> Void
    var createdAt: Date = Date()

    @Environment(\.dismiss) private var dismiss

    private var timeString: String {
        let df = DateFormatter()
        df.dateFormat = "hh:mm a"
        return df.string(from: createdAt)
    }

    var body: some View {
        ZStack {
            // Subtle bluish background similar to the screenshot
            Color(red: 0.94, green: 0.97, blue: 1.0)
                .ignoresSafeArea()
            VStack(alignment: .leading, spacing:15) {
    
                HStack(spacing: 12) {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundColor(Color.black.opacity(0.75))
                            .padding(10)
                        
                        
                    }
                    // Message
                    Text("Your order has been created, please proceed to payment")
                        .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                        .foregroundColor(Color.black.opacity(0.65))
                        .padding(.top, 4)
                }

                VStack(spacing: 0) {
                    PaymentDetailsCard(amount: amount)

                }
                .padding(14)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                .shadow(color: Color.black.opacity(0.06), radius: 12, x: 0, y: 4)
                .padding(.top, 4)
                
                Button(action: onProceed) {
                    Text("Proceed to payment")
                        .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .contentShape(Rectangle())
                }
                .background(Color(red: 0.12, green: 0.45, blue: 1.0)) // vibrant blue
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .shadow(color: Color(red: 0.12, green: 0.45, blue: 1.0).opacity(0.25), radius: 10, x: 0, y: 4)

                // Timestamp bottom-left
                Text(timeString)
                    .font(.footnote)
                    .foregroundColor(.secondary)
                Spacer()
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .navigationBarBackButtonHidden(true)
    }
}

private struct PaymentDetailsCard: View {
    let amount: String

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack(spacing: 10) {
                Image(systemName: "creditcard")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color.black.opacity(0.75))
                Text("Payment details")
                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                    .foregroundColor(Color.black.opacity(0.85))
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 12)
            .padding(.vertical, 12)
            .background(Color.black.opacity(0.04))
            .clipShape(RoundedRectangle(cornerRadius: 0, style: .continuous))
          
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text("Total amount")
                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                    .foregroundColor(.secondary)
                Text(amount)
                    .font(Font(UIFont.satoshi( weight: .regular, size: 14)))
                    .foregroundColor(Color.black.opacity(0.9))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color.white)
        )
        
        
    }
}

#Preview {
    NavigationStack {
        PaymentDetailsScreen(amount: "₦1200", onProceed: {})
    }
}
