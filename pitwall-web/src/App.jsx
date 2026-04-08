import { useState, useEffect } from "react";
import axios from "axios";

const API = "https://pitwallapi.azurewebsites.net";

const tireColors = {
  Soft: "#e8002d",
  Medium: "#ffd600",
  Hard: "#ffffff",
  Intermediate: "#39b54a",
  Wet: "#0067ff",
};

const weatherOptions = [
  { name: "Dry", icon: "☀️" },
  { name: "Cloudy", icon: "☁️" },
  { name: "Light Rain", icon: "🌦️" },
  { name: "Heavy Rain", icon: "🌧️" },
  { name: "Safety Car", icon: "🚗" },
];

function SessionList({ onSelect }) {
  const [sessions, setSessions] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios.get(`${API}/api/session`).then((res) => {
      const unique = res.data.filter(
        (s, i, arr) =>
          s.session_type === "Race" &&
          arr.findIndex((x) => x.circuit_short_name === s.circuit_short_name) === i
      );
      setSessions(unique);
      setLoading(false);
    });
  }, []);

  if (loading) return (
    <div style={styles.center}>
      <div style={styles.spinner} />
      <p style={{ color: "#888", marginTop: 16 }}>Loading race calendar...</p>
    </div>
  );

  return (
    <div>
      <p style={styles.subtitle}>2025 Race Calendar — Select a race to view drivers</p>
      <div style={styles.grid}>
        {sessions.map((s) => (
          <div key={s.session_key} style={styles.card} onClick={() => onSelect(s)}
            onMouseEnter={e => e.currentTarget.style.borderColor = "#e8002d"}
            onMouseLeave={e => e.currentTarget.style.borderColor = "#222"}>
            <div style={styles.cardFlag}>🏁</div>
            <div style={styles.cardName}>{s.circuit_short_name}</div>
            <div style={styles.cardCountry}>{s.country_name}</div>
            <div style={styles.cardDate}>{s.date_start?.slice(0, 10)}</div>
          </div>
        ))}
      </div>
    </div>
  );
}

const circuitDatabase = {
  "Melbourne": { laps: 58, length: "5.278 km", lapRecord: "1:20.235", holder: "Charles Leclerc", year: 2022, drs: 4, firstGP: 1996 },
  "Shanghai": { laps: 56, length: "5.451 km", lapRecord: "1:32.238", holder: "Michael Schumacher", year: 2004, drs: 2, firstGP: 2004 },
  "Suzuka": { laps: 53, length: "5.807 km", lapRecord: "1:30.983", holder: "Valtteri Bottas", year: 2019, drs: 1, firstGP: 1987 },
  "Sakhir": { laps: 57, length: "5.412 km", lapRecord: "1:31.447", holder: "Pedro de la Rosa", year: 2005, drs: 3, firstGP: 2004 },
  "Jeddah": { laps: 50, length: "6.174 km", lapRecord: "1:30.734", holder: "Lewis Hamilton", year: 2021, drs: 3, firstGP: 2021 },
  "Miami Gardens": { laps: 57, length: "5.412 km", lapRecord: "1:29.708", holder: "Max Verstappen", year: 2023, drs: 3, firstGP: 2022 },
  "Imola": { laps: 63, length: "4.909 km", lapRecord: "1:15.484", holder: "Rubens Barrichello", year: 2004, drs: 2, firstGP: 1980 },
  "Monaco": { laps: 78, length: "3.337 km", lapRecord: "1:12.909", holder: "Rubens Barrichello", year: 2004, drs: 1, firstGP: 1950 },
  "Catalunya": { laps: 66, length: "4.657 km", lapRecord: "1:18.149", holder: "Max Verstappen", year: 2021, drs: 2, firstGP: 1991 },
  "Montreal": { laps: 70, length: "4.361 km", lapRecord: "1:13.078", holder: "Valtteri Bottas", year: 2019, drs: 2, firstGP: 1978 },
  "Spielberg": { laps: 71, length: "4.318 km", lapRecord: "1:05.619", holder: "Carlos Sainz", year: 2020, drs: 3, firstGP: 1970 },
  "Silverstone": { laps: 52, length: "5.891 km", lapRecord: "1:27.097", holder: "Max Verstappen", year: 2020, drs: 2, firstGP: 1950 },
  "Hungaroring": { laps: 70, length: "4.381 km", lapRecord: "1:16.627", holder: "Lewis Hamilton", year: 2020, drs: 2, firstGP: 1986 },
  "Spa-Francorchamps": { laps: 44, length: "7.004 km", lapRecord: "1:46.286", holder: "Valtteri Bottas", year: 2018, drs: 2, firstGP: 1950 },
  "Zandvoort": { laps: 72, length: "4.259 km", lapRecord: "1:11.097", holder: "Lewis Hamilton", year: 2021, drs: 2, firstGP: 1952 },
  "Monza": { laps: 53, length: "5.793 km", lapRecord: "1:21.046", holder: "Rubens Barrichello", year: 2004, drs: 2, firstGP: 1950 },
  "Baku": { laps: 51, length: "6.003 km", lapRecord: "1:43.009", holder: "Charles Leclerc", year: 2019, drs: 2, firstGP: 2016 },
  "Marina Bay": { laps: 62, length: "4.940 km", lapRecord: "1:35.867", holder: "Lewis Hamilton", year: 2023, drs: 3, firstGP: 2008 },
  "Austin": { laps: 56, length: "5.513 km", lapRecord: "1:36.169", holder: "Charles Leclerc", year: 2019, drs: 2, firstGP: 2012 },
  "Mexico City": { laps: 71, length: "4.304 km", lapRecord: "1:17.774", holder: "Valtteri Bottas", year: 2021, drs: 3, firstGP: 1963 },
  "Interlagos": { laps: 71, length: "4.309 km", lapRecord: "1:10.540", holder: "Valtteri Bottas", year: 2018, drs: 2, firstGP: 1973 },
  "Las Vegas": { laps: 50, length: "6.201 km", lapRecord: "1:35.490", holder: "Oscar Piastri", year: 2024, drs: 2, firstGP: 2023 },
  "Lusail": { laps: 57, length: "5.380 km", lapRecord: "1:24.319", holder: "Max Verstappen", year: 2023, drs: 2, firstGP: 2021 },
  "Yas Island": { laps: 58, length: "5.281 km", lapRecord: "1:26.103", holder: "Max Verstappen", year: 2021, drs: 2, firstGP: 2009 },
};

function RaceInfo({ session, onViewDrivers, onBack }) {
  const info = circuitDatabase[session.circuit_short_name] || circuitDatabase[session.location];

  return (
    <div style={styles.formWrap}>
      <button style={styles.back} onClick={onBack}>← Back</button>
      <div style={styles.raceHeader}>
        <span style={{ fontSize: 24 }}>🏁</span>
        <div>
          <div style={styles.raceName}>{session.circuit_short_name}</div>
          <div style={{ color: "#888", fontSize: 13 }}>{session.country_name}</div>
        </div>
        <span style={{ color: "#e8002d", fontSize: 13, marginLeft: "auto" }}>{session.date_start?.slice(0, 10)}</span>
      </div>

      {info ? (
        <>
          <div style={{ display: "grid", gridTemplateColumns: "1fr 1fr", gap: 12, marginBottom: 16 }}>
            {[
              { icon: "🔄", label: "Laps", value: info.laps },
              { icon: "📏", label: "Circuit Length", value: info.length },
              { icon: "⚡", label: "DRS Zones", value: info.drs },
              { icon: "📅", label: "First GP", value: info.firstGP },
            ].map((s) => (
              <div key={s.label} style={{ background: "#111", borderRadius: 12, padding: 20, textAlign: "center" }}>
                <div style={{ fontSize: 24, marginBottom: 8 }}>{s.icon}</div>
                <div style={{ color: "#fff", fontWeight: 700, fontSize: 18 }}>{s.value}</div>
                <div style={{ color: "#888", fontSize: 12, marginTop: 4 }}>{s.label}</div>
              </div>
            ))}
          </div>

          <div style={{ background: "#111", borderRadius: 12, padding: 20, border: "1px solid #e8002d44", marginBottom: 24 }}>
            <div style={{ color: "#e8002d", fontWeight: 700, fontSize: 12, letterSpacing: 1, marginBottom: 12 }}>⏱ LAP RECORD</div>
            <div style={{ color: "#fff", fontFamily: "monospace", fontSize: 36, fontWeight: 700 }}>{info.lapRecord}</div>
            <div style={{ display: "flex", justifyContent: "space-between", marginTop: 8 }}>
              <span style={{ color: "#888" }}>{info.holder}</span>
              <span style={{ color: "#888" }}>{info.year}</span>
            </div>
          </div>
        </>
      ) : (
        <p style={{ color: "#888" }}>Circuit data not available</p>
      )}

      <button style={styles.btn} onClick={onViewDrivers}>
        👥 View Driver Standings
      </button>
    </div>
  );
}

function DriverList({ session, onSelectDriver, onBack }) {
  const [drivers, setDrivers] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios.get(`https://api.openf1.org/v1/drivers?session_key=${session.session_key}`)
      .then((res) => {
        const unique = Object.values(
          res.data.reduce((acc, d) => {
            if (!acc[d.driver_number]) acc[d.driver_number] = d;
            return acc;
          }, {})
        ).sort((a, b) => (a.position ?? 99) - (b.position ?? 99));
        setDrivers(unique);
        setLoading(false);
      })
      .catch(() => setLoading(false));
  }, []);

  return (
    <div style={styles.formWrap}>
      <button style={styles.back} onClick={onBack}>← Back</button>
      <div style={styles.raceHeader}>
        <span style={{ fontSize: 24 }}>🏁</span>
        <span style={styles.raceName}>{session.circuit_short_name}</span>
        <span style={styles.raceCountry}>{session.country_name}</span>
      </div>

      {loading ? (
        <div style={styles.center}>
          <div style={styles.spinner} />
          <p style={{ color: "#888", marginTop: 16 }}>Loading drivers...</p>
        </div>
      ) : (
        <div style={{ display: "flex", flexDirection: "column", gap: 10 }}>
          {drivers.map((d) => {
            const color = d.team_colour ? `#${d.team_colour}` : "#666";
            return (
              <div key={d.driver_number}
                onClick={() => onSelectDriver(d)}
                style={{
                  display: "flex", alignItems: "center", gap: 16,
                  background: "#111", borderRadius: 12, padding: "14px 16px",
                  cursor: "pointer", border: `1px solid #222`,
                  transition: "border-color 0.2s",
                }}
                onMouseEnter={e => e.currentTarget.style.borderColor = color}
                onMouseLeave={e => e.currentTarget.style.borderColor = "#222"}>
                <div style={{ width: 4, height: 44, background: color, borderRadius: 2, flexShrink: 0 }} />
                <div style={{ flex: 1 }}>
                  <div style={{ color: "#fff", fontWeight: 600, fontSize: 15 }}>{d.full_name}</div>
                  <div style={{ color: "#888", fontSize: 13 }}>{d.team_name}</div>
                </div>
                <div style={{ color, fontWeight: 700, fontSize: 14 }}>#{d.driver_number}</div>
                <div style={{ color: "#555", fontSize: 12 }}>→</div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

function StrategyForm({ session, driver, onBack }) {
  const [form, setForm] = useState({
    driverName: driver?.full_name ?? "Max Verstappen",
    driverNumber: driver?.driver_number ?? 1,
    currentLap: 30, totalLaps: 57, position: 2,
    tireCompound: "Medium", tireAge: 15,
    gapAhead: 1.2, gapBehind: 3.5,
    weatherCondition: "Dry",
  });
  const [result, setResult] = useState("");
  const [loading, setLoading] = useState(false);

  const set = (k, v) => setForm((f) => ({ ...f, [k]: v }));

  const getStrategy = async () => {
    setLoading(true);
    setResult("");
    try {
      const res = await axios.post(`${API}/api/strategy`, {
        circuitName: session.circuit_short_name,
        countryName: session.country_name,
        driverName: form.driverName,
        driverNumber: Number(form.driverNumber),
        currentLap: Number(form.currentLap),
        totalLaps: Number(form.totalLaps),
        position: Number(form.position),
        tireCompound: form.tireCompound,
        tireAge: Number(form.tireAge),
        gapAhead: Number(form.gapAhead),
        gapBehind: Number(form.gapBehind),
        weatherCondition: form.weatherCondition,
      });
      setResult(res.data.strategy);
    } catch {
      setResult("Error connecting to strategy engine. Please try again.");
    }
    setLoading(false);
  };

  const teamColor = driver?.team_colour ? `#${driver.team_colour}` : "#e8002d";

  return (
    <div style={styles.formWrap}>
      <button style={styles.back} onClick={onBack}>← Back</button>
      <div style={{ ...styles.raceHeader, borderLeft: `4px solid ${teamColor}` }}>
        <span style={{ fontSize: 24 }}>🏁</span>
        <div>
          <div style={styles.raceName}>{session.circuit_short_name}</div>
          <div style={{ color: "#888", fontSize: 13 }}>{form.driverName} #{form.driverNumber}</div>
        </div>
        <span style={styles.raceCountry}>{session.country_name}</span>
      </div>

      <div style={styles.formGrid}>
        {[
          ["Driver Name", "driverName", "text"],
          ["Driver Number", "driverNumber", "number"],
          ["Current Lap", "currentLap", "number"],
          ["Total Laps", "totalLaps", "number"],
          ["Position", "position", "number"],
          ["Tire Age (laps)", "tireAge", "number"],
          ["Gap Ahead (sec)", "gapAhead", "number"],
          ["Gap Behind (sec)", "gapBehind", "number"],
        ].map(([label, key, type]) => (
          <div key={key} style={styles.field}>
            <label style={styles.label}>{label}</label>
            <input style={styles.input} type={type} value={form[key]}
              onChange={(e) => set(key, e.target.value)} />
          </div>
        ))}
      </div>

      <div style={styles.tireRow}>
        {["Soft", "Medium", "Hard", "Intermediate", "Wet"].map((t) => (
          <button key={t} onClick={() => set("tireCompound", t)}
            style={{
              ...styles.tire,
              background: form.tireCompound === t ? tireColors[t] : "#1a1a1a",
              color: form.tireCompound === t && t === "Hard" ? "#000" : form.tireCompound === t ? "#000" : "#fff",
              borderColor: form.tireCompound === t ? tireColors[t] : "#333",
            }}>{t}</button>
        ))}
      </div>

      <div style={styles.weatherRow}>
        {weatherOptions.map((w) => (
          <button key={w.name} onClick={() => set("weatherCondition", w.name)}
            style={{
              ...styles.tire,
              background: form.weatherCondition === w.name ? "#1e3a5f" : "#1a1a1a",
              borderColor: form.weatherCondition === w.name ? "#4a9eff" : "#333",
              color: "#fff",
              display: "flex", flexDirection: "column", alignItems: "center", gap: 4,
              padding: "8px 12px",
            }}>
            <span style={{ fontSize: 18 }}>{w.icon}</span>
            <span style={{ fontSize: 11 }}>{w.name}</span>
          </button>
        ))}
      </div>

      <button style={styles.btn} onClick={getStrategy} disabled={loading}>
        {loading ? "Analyzing..." : "🧠 Get AI Strategy"}
      </button>

      {result && (
        <div style={styles.result}>
          <div style={styles.resultHeader}>
            <span style={{ color: "#e8002d" }}>📡</span>
            <span style={styles.resultTitle}>STRATEGY CALL</span>
          </div>
          <pre style={styles.resultText}>{result}</pre>
        </div>
      )}
    </div>
  );
}

export default function App() {
  const [selected, setSelected] = useState(null);
  const [showDrivers, setShowDrivers] = useState(false);
  const [selectedDriver, setSelectedDriver] = useState(null);

  return (
    <div style={styles.app}>
      <div style={styles.header}>
        <span style={{ fontSize: 32 }}>🏁</span>
        <span style={styles.title}>PitWall</span>
        <span style={styles.tagline}>Your AI Race Strategist</span>
      </div>
      {!selected && <SessionList onSelect={setSelected} />}
      {selected && !showDrivers && !selectedDriver && (
        <RaceInfo
          session={selected}
          onViewDrivers={() => setShowDrivers(true)}
          onBack={() => setSelected(null)}
        />
      )}
      {selected && showDrivers && !selectedDriver && (
        <DriverList
          session={selected}
          onSelectDriver={setSelectedDriver}
          onBack={() => setShowDrivers(false)}
        />
      )}
      {selected && selectedDriver && (
        <StrategyForm
          session={selected}
          driver={selectedDriver}
          onBack={() => setSelectedDriver(null)}
        />
      )}
    </div>
  );
}

const styles = {
  app: { minHeight: "100vh", background: "#0a0a0a", color: "#fff", fontFamily: "system-ui, sans-serif", padding: "0 0 60px" },
  header: { display: "flex", alignItems: "center", gap: 12, padding: "24px 32px", borderBottom: "1px solid #1a1a1a" },
  title: { fontSize: 28, fontWeight: 700 },
  tagline: { color: "#666", fontSize: 14, marginLeft: 8 },
  subtitle: { color: "#666", fontSize: 13, padding: "16px 32px 8px" },
  grid: { display: "grid", gridTemplateColumns: "repeat(auto-fill, minmax(200px, 1fr))", gap: 16, padding: "0 32px" },
  card: { background: "#111", border: "1px solid #222", borderRadius: 12, padding: 20, cursor: "pointer", transition: "border-color 0.2s" },
  cardFlag: { fontSize: 20, marginBottom: 8 },
  cardName: { fontWeight: 600, fontSize: 16, marginBottom: 4 },
  cardCountry: { color: "#888", fontSize: 13, marginBottom: 6 },
  cardDate: { color: "#e8002d", fontSize: 12 },
  center: { display: "flex", flexDirection: "column", alignItems: "center", paddingTop: 80 },
  spinner: { width: 32, height: 32, border: "3px solid #222", borderTop: "3px solid #e8002d", borderRadius: "50%", animation: "spin 1s linear infinite" },
  formWrap: { padding: "24px 32px" },
  back: { background: "none", border: "1px solid #333", color: "#fff", padding: "8px 16px", borderRadius: 8, cursor: "pointer", marginBottom: 20 },
  raceHeader: { display: "flex", alignItems: "center", gap: 12, background: "#111", padding: "16px 20px", borderRadius: 12, marginBottom: 24 },
  raceName: { fontWeight: 700, fontSize: 20 },
  raceCountry: { color: "#888", fontSize: 14, marginLeft: "auto" },
  formGrid: { display: "grid", gridTemplateColumns: "1fr 1fr", gap: 16, marginBottom: 20 },
  field: { display: "flex", flexDirection: "column", gap: 6 },
  label: { color: "#888", fontSize: 12 },
  input: { background: "#1a1a1a", border: "1px solid #333", color: "#fff", padding: "10px 12px", borderRadius: 8, fontSize: 14 },
  tireRow: { display: "flex", gap: 8, marginBottom: 16, flexWrap: "wrap" },
  weatherRow: { display: "flex", gap: 8, marginBottom: 24, flexWrap: "wrap" },
  tire: { padding: "8px 16px", borderRadius: 8, border: "1px solid", cursor: "pointer", fontWeight: 600, fontSize: 13 },
  btn: { width: "100%", background: "#e8002d", color: "#fff", border: "none", padding: "14px", borderRadius: 12, fontSize: 16, fontWeight: 700, cursor: "pointer", marginBottom: 24 },
  result: { background: "#111", border: "1px solid #e8002d44", borderRadius: 12, padding: 20 },
  resultHeader: { display: "flex", alignItems: "center", gap: 8, marginBottom: 12 },
  resultTitle: { color: "#e8002d", fontWeight: 700, fontSize: 13, letterSpacing: 1 },
  resultText: { color: "#fff", fontFamily: "monospace", fontSize: 14, lineHeight: 1.6, whiteSpace: "pre-wrap", margin: 0 },
};