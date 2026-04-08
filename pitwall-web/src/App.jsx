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
      <p style={styles.subtitle}>2025 Race Calendar — Select a race for AI Strategy</p>
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

function StrategyForm({ session, onBack }) {
  const [form, setForm] = useState({
    driverName: "Max Verstappen", driverNumber: 1,
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

  return (
    <div style={styles.formWrap}>
      <button style={styles.back} onClick={onBack}>← Back</button>
      <div style={styles.raceHeader}>
        <span style={{ fontSize: 24 }}>🏁</span>
        <span style={styles.raceName}>{session.circuit_short_name}</span>
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
        {[
          { name: "Dry", icon: "☀️" },
          { name: "Cloudy", icon: "☁️" },
          { name: "Light Rain", icon: "🌦️" },
          { name: "Heavy Rain", icon: "🌧️" },
          { name: "Safety Car", icon: "🚗" },
        ].map((w) => (
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

  return (
    <div style={styles.app}>
      <div style={styles.header}>
        <span style={{ fontSize: 32 }}>🏁</span>
        <span style={styles.title}>PitWall</span>
        <span style={styles.tagline}>Your AI Race Strategist</span>
      </div>
      {selected
        ? <StrategyForm session={selected} onBack={() => setSelected(null)} />
        : <SessionList onSelect={setSelected} />}
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
  tireRow: { display: "flex", gap: 8, marginBottom: 24, flexWrap: "wrap" },
  tire: { padding: "8px 16px", borderRadius: 8, border: "1px solid", cursor: "pointer", fontWeight: 600, fontSize: 13 },
  btn: { width: "100%", background: "#e8002d", color: "#fff", border: "none", padding: "14px", borderRadius: 12, fontSize: 16, fontWeight: 700, cursor: "pointer", marginBottom: 24 },
  result: { background: "#111", border: "1px solid #e8002d44", borderRadius: 12, padding: 20 },
  resultHeader: { display: "flex", alignItems: "center", gap: 8, marginBottom: 12 },
  resultTitle: { color: "#e8002d", fontWeight: 700, fontSize: 13, letterSpacing: 1 },
  resultText: { color: "#fff", fontFamily: "monospace", fontSize: 14, lineHeight: 1.6, whiteSpace: "pre-wrap", margin: 0 },
  weatherRow: { display: "flex", gap: 8, marginBottom: 24, flexWrap: "wrap" },
};