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
        VStack(alignment: .leading, spacing: 10) {
            Text("TRACK CONDITIONS")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.gray)
                .tracking(1)
                .padding(.horizontal, 4)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(weatherConditions, id: \.name) { condition in
                        Button(action: { selected = condition.name }) {
                            VStack(spacing: 8) {
                                Image(systemName: condition.icon)
                                    .font(.system(size: 24))
                                    .foregroundColor(selected == condition.name ? condition.color : Color(white: 0.5))
                                    .frame(width: 48, height: 48)
                                    .background(
                                        selected == condition.name ?
                                        condition.color.opacity(0.15) :
                                        Color(white: 0.1)
                                    )
                                    .cornerRadius(14)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 14)
                                            .stroke(
                                                selected == condition.name ? condition.color : Color.clear,
                                                lineWidth: 1.5
                                            )
                                    )
                                Text(condition.name)
                                    .font(.system(size: 10, weight: selected == condition.name ? .bold : .regular))
                                    .foregroundColor(selected == condition.name ? .white : Color(white: 0.5))
                            }
                            .frame(width: 70)
                        }
                    }
                }
                .padding(.horizontal, 4)
            }
        }
        .padding()
        .background(Color(white: 0.06))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color(white: 0.12), lineWidth: 1)
        )
    }
}
