import SwiftUI

struct CircuitInfo {
    let laps: Int
    let circuitLength: String
    let lapRecord: String
    let lapRecordHolder: String
    let lapRecordYear: Int
    let drsZones: Int
    let firstGP: Int
}

let circuitDatabase: [String: CircuitInfo] = [
    "Melbourne": CircuitInfo(laps: 58, circuitLength: "5.278 km", lapRecord: "1:20.235", lapRecordHolder: "Charles Leclerc", lapRecordYear: 2022, drsZones: 4, firstGP: 1996),
    "Shanghai": CircuitInfo(laps: 56, circuitLength: "5.451 km", lapRecord: "1:32.238", lapRecordHolder: "Michael Schumacher", lapRecordYear: 2004, drsZones: 2, firstGP: 2004),
    "Suzuka": CircuitInfo(laps: 53, circuitLength: "5.807 km", lapRecord: "1:30.983", lapRecordHolder: "Valtteri Bottas", lapRecordYear: 2019, drsZones: 1, firstGP: 1987),
    "Sakhir": CircuitInfo(laps: 57, circuitLength: "5.412 km", lapRecord: "1:31.447", lapRecordHolder: "Pedro de la Rosa", lapRecordYear: 2005, drsZones: 3, firstGP: 2004),
    "Jeddah": CircuitInfo(laps: 50, circuitLength: "6.174 km", lapRecord: "1:30.734", lapRecordHolder: "Lewis Hamilton", lapRecordYear: 2021, drsZones: 3, firstGP: 2021),
    "Miami Gardens": CircuitInfo(laps: 57, circuitLength: "5.412 km", lapRecord: "1:29.708", lapRecordHolder: "Max Verstappen", lapRecordYear: 2023, drsZones: 3, firstGP: 2022),
    "Imola": CircuitInfo(laps: 63, circuitLength: "4.909 km", lapRecord: "1:15.484", lapRecordHolder: "Rubens Barrichello", lapRecordYear: 2004, drsZones: 2, firstGP: 1980),
    "Monte Carlo": CircuitInfo(laps: 78, circuitLength: "3.337 km", lapRecord: "1:12.909", lapRecordHolder: "Rubens Barrichello", lapRecordYear: 2004, drsZones: 1, firstGP: 1950),
    "Catalunya": CircuitInfo(laps: 66, circuitLength: "4.657 km", lapRecord: "1:18.149", lapRecordHolder: "Max Verstappen", lapRecordYear: 2021, drsZones: 2, firstGP: 1991),
    "Montreal": CircuitInfo(laps: 70, circuitLength: "4.361 km", lapRecord: "1:13.078", lapRecordHolder: "Valtteri Bottas", lapRecordYear: 2019, drsZones: 2, firstGP: 1978),
    "Spielberg": CircuitInfo(laps: 71, circuitLength: "4.318 km", lapRecord: "1:05.619", lapRecordHolder: "Carlos Sainz", lapRecordYear: 2020, drsZones: 3, firstGP: 1970),
    "Silverstone": CircuitInfo(laps: 52, circuitLength: "5.891 km", lapRecord: "1:27.097", lapRecordHolder: "Max Verstappen", lapRecordYear: 2020, drsZones: 2, firstGP: 1950),
    "Hungaroring": CircuitInfo(laps: 70, circuitLength: "4.381 km", lapRecord: "1:16.627", lapRecordHolder: "Lewis Hamilton", lapRecordYear: 2020, drsZones: 2, firstGP: 1986),
    "Spa-Francorchamps": CircuitInfo(laps: 44, circuitLength: "7.004 km", lapRecord: "1:46.286", lapRecordHolder: "Valtteri Bottas", lapRecordYear: 2018, drsZones: 2, firstGP: 1950),
    "Zandvoort": CircuitInfo(laps: 72, circuitLength: "4.259 km", lapRecord: "1:11.097", lapRecordHolder: "Lewis Hamilton", lapRecordYear: 2021, drsZones: 2, firstGP: 1952),
    "Monza": CircuitInfo(laps: 53, circuitLength: "5.793 km", lapRecord: "1:21.046", lapRecordHolder: "Rubens Barrichello", lapRecordYear: 2004, drsZones: 2, firstGP: 1950),
    "Baku": CircuitInfo(laps: 51, circuitLength: "6.003 km", lapRecord: "1:43.009", lapRecordHolder: "Charles Leclerc", lapRecordYear: 2019, drsZones: 2, firstGP: 2016),
    "Marina Bay": CircuitInfo(laps: 62, circuitLength: "4.940 km", lapRecord: "1:35.867", lapRecordHolder: "Lewis Hamilton", lapRecordYear: 2023, drsZones: 3, firstGP: 2008),
    "Austin": CircuitInfo(laps: 56, circuitLength: "5.513 km", lapRecord: "1:36.169", lapRecordHolder: "Charles Leclerc", lapRecordYear: 2019, drsZones: 2, firstGP: 2012),
    "Mexico City": CircuitInfo(laps: 71, circuitLength: "4.304 km", lapRecord: "1:17.774", lapRecordHolder: "Valtteri Bottas", lapRecordYear: 2021, drsZones: 3, firstGP: 1963),
    "Interlagos": CircuitInfo(laps: 71, circuitLength: "4.309 km", lapRecord: "1:10.540", lapRecordHolder: "Valtteri Bottas", lapRecordYear: 2018, drsZones: 2, firstGP: 1973),
    "Las Vegas": CircuitInfo(laps: 50, circuitLength: "6.201 km", lapRecord: "1:35.490", lapRecordHolder: "Oscar Piastri", lapRecordYear: 2024, drsZones: 2, firstGP: 2023),
    "Lusail": CircuitInfo(laps: 57, circuitLength: "5.380 km", lapRecord: "1:24.319", lapRecordHolder: "Max Verstappen", lapRecordYear: 2023, drsZones: 2, firstGP: 2021),
    "Yas Island": CircuitInfo(laps: 58, circuitLength: "5.281 km", lapRecord: "1:26.103", lapRecordHolder: "Max Verstappen", lapRecordYear: 2021, drsZones: 2, firstGP: 2009),
]

struct RaceInfoView: View {
    let session: RaceSession

    var countryFlag: String {
        let flags: [String: String] = [
            "Australia": "🇦🇺", "China": "🇨🇳", "Japan": "🇯🇵",
            "Bahrain": "🇧🇭", "Saudi Arabia": "🇸🇦", "United States": "🇺🇸",
            "Italy": "🇮🇹", "Monaco": "🇲🇨", "Spain": "🇪🇸",
            "Canada": "🇨🇦", "Austria": "🇦🇹", "United Kingdom": "🇬🇧",
            "Belgium": "🇧🇪", "Hungary": "🇭🇺", "Netherlands": "🇳🇱",
            "Azerbaijan": "🇦🇿", "Singapore": "🇸🇬", "Mexico": "🇲🇽",
            "Brazil": "🇧🇷", "United Arab Emirates": "🇦🇪", "Qatar": "🇶🇦"
        ]
        return flags[session.countryName] ?? "🏁"
    }

    var circuitInfo: CircuitInfo? {
        circuitDatabase[session.circuitShortName] ?? circuitDatabase[session.location]
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {

                    // Gradient header — matches web
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [Color(red: 0.1, green: 0, blue: 0),
                                         Color(red: 0.18, green: 0, blue: 0),
                                         Color(white: 0.07)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .overlay(
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(Color.red.opacity(0.1), lineWidth: 1)
                            )

                        HStack(alignment: .top) {
                            VStack(alignment: .leading, spacing: 6) {
                                Text("RACE INFO")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.red)
                                    .tracking(1)
                                Text(session.circuitShortName)
                                    .font(.system(size: 26, weight: .heavy))
                                    .foregroundColor(.white)
                                HStack(spacing: 5) {
                                    Text(countryFlag)
                                        .font(.system(size: 14))
                                    Text(session.countryName)
                                        .font(.system(size: 14))
                                        .foregroundColor(Color(white: 0.6))
                                }
                            }
                            Spacer()
                            Text(String(session.dateStart.prefix(10)))
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundColor(.red)
                        }
                        .padding(20)
                    }

                    if let info = circuitInfo {
                        // Stats grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            statCard(icon: "🏁", label: "Laps", value: "\(info.laps)")
                            statCard(icon: "📐", label: "Circuit Length", value: info.circuitLength)
                            statCard(icon: "⚡", label: "DRS Zones", value: "\(info.drsZones)")
                            statCard(icon: "🏆", label: "First GP", value: "\(info.firstGP)")
                        }

                        // Lap record card
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(spacing: 6) {
                                Text("LAP RECORD")
                                    .font(.system(size: 11, weight: .bold))
                                    .foregroundColor(.red)
                                    .tracking(1.5)
                            }
                            Text(info.lapRecord)
                                .font(.system(size: 40, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                                .tracking(2)
                            HStack {
                                Text(info.lapRecordHolder)
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(white: 0.55))
                                Spacer()
                                Text(String(info.lapRecordYear))
                                    .font(.system(size: 13))
                                    .foregroundColor(Color(white: 0.55))
                            }
                        }
                        .padding(20)
                        .background(Color(white: 0.07))
                        .cornerRadius(14)
                        .overlay(
                            RoundedRectangle(cornerRadius: 14)
                                .stroke(Color.red.opacity(0.25), lineWidth: 1)
                        )
                    } else {
                        Text("Circuit data not available")
                            .foregroundColor(.gray)
                            .padding()
                    }

                    // View Driver Standings button
                    NavigationLink(destination: DriverDashboardView(session: session)) {
                        HStack {
                            Text("View Driver Standings")
                                .font(.system(size: 15, weight: .bold))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(14)
                    }
                }
                .padding(16)
            }
        }
        .navigationTitle("Race Info")
        .navigationBarTitleDisplayMode(.inline)
    }

    func statCard(icon: String, label: String, value: String) -> some View {
        VStack(spacing: 10) {
            Text(icon)
                .font(.system(size: 22))
            Text(value)
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.white)
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(Color(white: 0.4))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(Color(white: 0.07))
        .cornerRadius(14)
        .overlay(
            RoundedRectangle(cornerRadius: 14)
                .stroke(Color(white: 0.1), lineWidth: 1)
        )
    }
}
