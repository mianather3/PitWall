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
    "Monaco": CircuitInfo(laps: 78, circuitLength: "3.337 km", lapRecord: "1:12.909", lapRecordHolder: "Rubens Barrichello", lapRecordYear: 2004, drsZones: 1, firstGP: 1950),
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

    var circuitInfo: CircuitInfo? {
        circuitDatabase[session.circuitShortName] ?? circuitDatabase[session.location]
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 16) {

                    // Header
                    ZStack(alignment: .bottomLeading) {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(LinearGradient(
                                colors: [Color.red.opacity(0.3), Color.black],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ))
                            .frame(height: 120)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(session.circuitShortName)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                            HStack {
                                Text(session.countryName)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(session.dateStart.prefix(10))
                                    .font(.caption.bold())
                                    .foregroundColor(.red)
                            }
                        }
                        .padding()
                    }

                    if let info = circuitInfo {
                        // Stats grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                            statCard(title: "Laps", value: "\(info.laps)", icon: "repeat.circle.fill")
                            statCard(title: "Circuit Length", value: info.circuitLength, icon: "road.lanes")
                            statCard(title: "DRS Zones", value: "\(info.drsZones)", icon: "bolt.fill")
                            statCard(title: "First GP", value: "\(info.firstGP)", icon: "calendar")
                        }

                        // Lap record card
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Image(systemName: "stopwatch.fill")
                                    .foregroundColor(.red)
                                Text("LAP RECORD")
                                    .font(.caption.bold())
                                    .foregroundColor(.red)
                                    .tracking(1)
                            }
                            Text(info.lapRecord)
                                .font(.system(size: 36, weight: .bold, design: .monospaced))
                                .foregroundColor(.white)
                            HStack {
                                Text(info.lapRecordHolder)
                                    .foregroundColor(.gray)
                                Spacer()
                                Text(String(info.lapRecordYear))
                                    .foregroundColor(.gray)
                            }
                            .font(.subheadline)
                        }
                        .padding()
                        .background(Color(white: 0.1))
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.red.opacity(0.3), lineWidth: 1)
                        )
                    } else {
                        Text("Circuit data not available")
                            .foregroundColor(.gray)
                            .padding()
                    }

                    // Navigate to drivers button
                    NavigationLink(destination: DriverDashboardView(session: session)) {
                        HStack {
                            Image(systemName: "person.3.fill")
                            Text("View Driver Standings")
                                .font(.headline)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
        }
        .navigationTitle("Race Info")
        .navigationBarTitleDisplayMode(.inline)
    }

    func statCard(title: String, value: String, icon: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .foregroundColor(.red)
                .font(.system(size: 22))
            Text(value)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.white)
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(white: 0.1))
        .cornerRadius(12)
    }
}
