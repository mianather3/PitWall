import { useState } from "react";
import { supabase } from "./supabase";

export default function Auth({ onLogin }) {
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [isSignUp, setIsSignUp] = useState(false);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState("");
  const [message, setMessage] = useState("");

  const handle = async () => {
    setLoading(true);
    setError("");
    setMessage("");

    const { data, error } = isSignUp
      ? await supabase.auth.signUp({ email, password })
      : await supabase.auth.signInWithPassword({ email, password });

    if (error) {
      setError(error.message);
    } else if (isSignUp) {
      setMessage("Account created! Check your email to confirm, then sign in.");
    } else {
      onLogin(data.user);
    }
    setLoading(false);
  };

  return (
    <div style={styles.wrap}>
      <div style={styles.box}>
        <div style={styles.logo}>🏎</div>
        <div style={styles.title}>PitWall</div>
        <div style={styles.subtitle}>Your AI Race Strategist</div>

        <div style={styles.toggle}>
          <button
            style={{ ...styles.tab, ...(isSignUp ? {} : styles.activeTab) }}
            onClick={() => setIsSignUp(false)}>
            Sign In
          </button>
          <button
            style={{ ...styles.tab, ...(isSignUp ? styles.activeTab : {}) }}
            onClick={() => setIsSignUp(true)}>
            Sign Up
          </button>
        </div>

        <input
          style={styles.input}
          type="email"
          placeholder="Email"
          value={email}
          onChange={(e) => setEmail(e.target.value)}
        />
        <input
          style={styles.input}
          type="password"
          placeholder="Password"
          value={password}
          onChange={(e) => setPassword(e.target.value)}
          onKeyDown={(e) => e.key === "Enter" && handle()}
        />

        {error && <div style={styles.error}>{error}</div>}
        {message && <div style={styles.success}>{message}</div>}

        <button style={styles.btn} onClick={handle} disabled={loading}>
          {loading ? "Loading..." : isSignUp ? "Create Account" : "Sign In"}
        </button>
      </div>
    </div>
  );
}

const styles = {
  wrap: { minHeight: "100vh", background: "#0a0a0a", display: "flex", alignItems: "center", justifyContent: "center" },
  box: { background: "#111", border: "1px solid #222", borderRadius: 16, padding: 40, width: 360, display: "flex", flexDirection: "column", alignItems: "center", gap: 16 },
  logo: { fontSize: 48 },
  title: { color: "#fff", fontSize: 28, fontWeight: 700 },
  subtitle: { color: "#666", fontSize: 14, marginBottom: 8 },
  toggle: { display: "flex", background: "#1a1a1a", borderRadius: 8, padding: 4, width: "100%", marginBottom: 8 },
  tab: { flex: 1, background: "none", border: "none", color: "#666", padding: "8px 0", borderRadius: 6, cursor: "pointer", fontWeight: 600, fontSize: 14 },
  activeTab: { background: "#e8002d", color: "#fff" },
  input: { width: "100%", background: "#1a1a1a", border: "1px solid #333", color: "#fff", padding: "12px 14px", borderRadius: 8, fontSize: 14, boxSizing: "border-box" },
  error: { color: "#e8002d", fontSize: 13, textAlign: "center" },
  success: { color: "#39b54a", fontSize: 13, textAlign: "center" },
  btn: { width: "100%", background: "#e8002d", color: "#fff", border: "none", padding: 14, borderRadius: 10, fontSize: 16, fontWeight: 700, cursor: "pointer", marginTop: 8 },
};