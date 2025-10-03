import SwiftUI

// (Paste OrderStatusTrackerView here, same as in confirmation view)

struct FabricRequestFeedbackView: View {
    @State private var rating: Int = 0
    @State private var feedback: String = ""
    private let activeStarColor = Color(red: 1.0, green: 0.83, blue: 0.09)
    var body: some View {
        VStack(alignment: .leading, spacing: 18) {

            
            OrderStatusTrackerView(
                currentStep: 4,
                steps: [
                    .init(title: "Request received", icon: "doc.fill"),
                    .init(title: "Assigned", icon: "person.3.fill"),
                    .init(title: "In progress", icon: "gearshape.fill"),
                    .init(title: "Complete", icon: "checkmark.circle.fill"),
                    .init(title: "Complete", icon: "checkmark.circle.fill"),
                    .init(title: "Complete", icon: "checkmark.circle.fill")
                ]
            )
            
            // Time label at top
            HStack {
                Text("03:50 AM")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.leading, 2)
            
            // Feedback card container
            VStack(alignment: .leading, spacing: 16) {
                Text("Your fabrics offer has been completed and delivered. How was your experience?")
                    .font(.subheadline)
                    .foregroundColor(.black)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Header with question mark icon and title
                    HStack(spacing: 8) {
                        Image(systemName: "questionmark.circle")
                            .foregroundColor(.black)
                            .font(.system(size: 18, weight: .medium))
                        Text("How was your experience")
                            .font(.headline.weight(.semibold))
                            .foregroundColor(.black)
                    }
                    
                    HStack{
                        Spacer()
                        HStack(spacing: 8) {
                            
                            ForEach(1...5, id: \.self) { i in
                                Image(systemName: rating >= i ? "star.fill" : "star")
                                    .resizable()
                                    .frame(width: 15, height: 15)
                                    .foregroundColor(activeStarColor)
                                    .onTapGesture {
                                        rating = i
                                    }
                                    .allowsHitTesting(false) // static outline for now as requested
                            }
                        }
                        .padding(.top, 8)
                        Spacer()
                    }
                    HStack{
                        Spacer()
                        
                        Text("Click to rate")
                            .font(.caption)
                            .foregroundColor(.gray)
                            .padding(.bottom, 4)
                        Spacer()
                    }
                    
                    // Feedback TextEditor with placeholder
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.gray.opacity(0.18), lineWidth: 1)
                            .background(Color.white.cornerRadius(10))
                        TextEditor(text: $feedback)
                            .frame(height: 70)
                            .font(.subheadline)
                            .padding([.horizontal, .top], 8)
                            .background(Color.clear)
                        if feedback.isEmpty {
                            Text("Share your experience (optional)")
                                .foregroundColor(.gray)
                                .padding(.top, 12)
                                .padding(.horizontal, 14)
                                .font(.subheadline)
                        }
                    }
                }
                .padding(14)
                .background(Color(red: 248/255, green: 251/255, blue: 255/255))
                .cornerRadius(12)
                
                // Submit feedback button
                Button(action: {}) {
                    Text("Submit feedback")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
            }
            .padding(8)
            .background(Color(red: 232/255, green: 244/255, blue: 255/255))
            .cornerRadius(14)
            
            // Bottom time label
            HStack {
                Text("03:50 AM")
                    .font(.caption2)
                    .foregroundColor(.gray)
                Spacer()
            }
            .padding(.leading, 2)
        }
        .padding()
        .background(Color(red: 240/255, green: 246/255, blue: 255/255).ignoresSafeArea())
    }
}

#Preview {
    FabricRequestFeedbackView()
}
