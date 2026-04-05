import SwiftUI

struct WeatherCondition {
    let name: String
    let icon: String
    let description: String
    let color: Color
}

let weatherConditions = [
    WeatherCondition(name: "Dry", icon: "sun.max.fill", description: "Track is dry", color: .yellow),
    WeatherCondition(name: "Cloudy", icon: "cloud.fill", description: "Overcast, no rain", color: .gray),
    WeatherCondition(name: "Light Rain", icon: "cloud.drizzle.fill", description: "Light drizzle", color: .blue),
    WeatherCondition(name: "Heavy Rain", icon: "cloud.heavyrain.fill", description: "Heavy rain", color: .indigo),
    WeatherCondition(name: "Safety Car", icon: "car.fill", description: "Safety car deployed", color: .orange),
]

struct WeatherSelector: View {
    @Binding var selected: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Track Conditions")
                .font(.caption)
                .foregroundColor(.gray)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(weatherConditions, id: \.name) { condition in
                        Button(action: { selected = condition.name }) {
                            VStack(spacing: 6) {
                                Image(systemName: condition.icon)
                                    .font(.system(size: 22))
                                    .foregroundColor(selected == condition.name ? condition.color : .gray)
                                Text(condition.name)
                                    .font(.caption2)
                                    .foregroundColor(selected == condition.name ? .white : .gray)
                            }
                            .frame(width: 70, height: 70)
                            .background(selected == condition.name ? Color(white: 0.2) : Color(white: 0.1))
                            .cornerRadius(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(selected == condition.name ? condition.color : Color.clear, lineWidth: 1.5)
                            )
                        }
                    }
                }
                .padding(.horizontal, 2)
            }
        }
        .padding()
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }
}
