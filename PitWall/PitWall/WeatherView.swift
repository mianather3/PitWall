import SwiftUI

struct WeatherCondition {
    let name: String
    let emoji: String
    let color: Color
}

let weatherConditions = [
    WeatherCondition(name: "Dry", emoji: "☀️", color: .yellow),
    WeatherCondition(name: "Cloudy", emoji: "☁️", color: .gray),
    WeatherCondition(name: "Light Rain", emoji: "🌦️", color: .blue),
    WeatherCondition(name: "Heavy Rain", emoji: "🌧️", color: .indigo),
    WeatherCondition(name: "Safety Car", emoji: "🚗", color: .orange),
]

struct WeatherSelector: View {
    @Binding var selected: String

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("TRACK CONDITIONS")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(white: 0.4))
                .tracking(0.5)
                .padding(.horizontal, 4)

            HStack(spacing: 8) {
                ForEach(weatherConditions, id: \.name) { condition in
                    Button(action: { selected = condition.name }) {
                        VStack(spacing: 6) {
                            Text(condition.emoji)
                                .font(.system(size: 22))
                                .frame(width: 48, height: 48)
                                .background(
                                    selected == condition.name
                                    ? Color(red: 0.12, green: 0.23, blue: 0.37)
                                    : Color(white: 0.1)
                                )
                                .cornerRadius(12)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(
                                            selected == condition.name ? Color(red: 0.29, green: 0.62, blue: 1) : Color.clear,
                                            lineWidth: 1.5
                                        )
                                )
                            Text(condition.name)
                                .font(.system(size: 10, weight: selected == condition.name ? .bold : .regular))
                                .foregroundColor(selected == condition.name ? .white : Color(white: 0.5))
                                .multilineTextAlignment(.center)
                                .lineLimit(2)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
            }
        }
        .padding(16)
        .background(Color(white: 0.06))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(white: 0.12), lineWidth: 1)
        )
    }
}
