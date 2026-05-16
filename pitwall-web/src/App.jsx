import { useState, useEffect } from "react";
import axios from "axios";
import { createClient } from "@supabase/supabase-js";

const API = "https://pitwallapi.azurewebsites.net";
const SUPABASE_URL = "https://kyqjkfohzsvdxfbmceld.supabase.co";
const SUPABASE_ANON_KEY = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imt5cWprZm9oenN2ZHhmYm1jZWxkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzY0OTYzMTIsImV4cCI6MjA5MjA3MjMxMn0.qJmf9wQNmgRDsHNFdLLjG2FrWz3jjCgse5JPbKqKs_g";
const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

const countryFlags = {
  "Australia":"🇦🇺","China":"🇨🇳","Japan":"🇯🇵","Bahrain":"🇧🇭",
  "Saudi Arabia":"🇸🇦","United States":"🇺🇸","Italy":"🇮🇹","Monaco":"🇲🇨",
  "Spain":"🇪🇸","Canada":"🇨🇦","Austria":"🇦🇹","United Kingdom":"🇬🇧",
  "Belgium":"🇧🇪","Hungary":"🇭🇺","Netherlands":"🇳🇱","Azerbaijan":"🇦🇿",
  "Singapore":"🇸🇬","Mexico":"🇲🇽","Brazil":"🇧🇷","Qatar":"🇶🇦",
  "United Arab Emirates":"🇦🇪",
};

const tireColors = { Soft:"#e8002d",Medium:"#ffd600",Hard:"#ffffff",Intermediate:"#39b54a",Wet:"#0067ff" };

const weatherOptions = [
  {name:"Dry",icon:"☀️"},{name:"Cloudy",icon:"☁️"},{name:"Light Rain",icon:"🌦️"},
  {name:"Heavy Rain",icon:"🌧️"},{name:"Safety Car",icon:"🚗"},
];

const circuitDatabase = {
  "Melbourne":{laps:58,length:"5.278 km",lapRecord:"1:20.235",holder:"Charles Leclerc",year:2022,drs:4,firstGP:1996},
  "Shanghai":{laps:56,length:"5.451 km",lapRecord:"1:32.238",holder:"Michael Schumacher",year:2004,drs:2,firstGP:2004},
  "Suzuka":{laps:53,length:"5.807 km",lapRecord:"1:30.983",holder:"Valtteri Bottas",year:2019,drs:1,firstGP:1987},
  "Sakhir":{laps:57,length:"5.412 km",lapRecord:"1:31.447",holder:"Pedro de la Rosa",year:2005,drs:3,firstGP:2004},
  "Jeddah":{laps:50,length:"6.174 km",lapRecord:"1:30.734",holder:"Lewis Hamilton",year:2021,drs:3,firstGP:2021},
  "Miami Gardens":{laps:57,length:"5.412 km",lapRecord:"1:29.708",holder:"Max Verstappen",year:2023,drs:3,firstGP:2022},
  "Imola":{laps:63,length:"4.909 km",lapRecord:"1:15.484",holder:"Rubens Barrichello",year:2004,drs:2,firstGP:1980},
  "Monte Carlo":{laps:78,length:"3.337 km",lapRecord:"1:12.909",holder:"Rubens Barrichello",year:2004,drs:1,firstGP:1950},
  "Catalunya":{laps:66,length:"4.657 km",lapRecord:"1:18.149",holder:"Max Verstappen",year:2021,drs:2,firstGP:1991},
  "Montreal":{laps:70,length:"4.361 km",lapRecord:"1:13.078",holder:"Valtteri Bottas",year:2019,drs:2,firstGP:1978},
  "Spielberg":{laps:71,length:"4.318 km",lapRecord:"1:05.619",holder:"Carlos Sainz",year:2020,drs:3,firstGP:1970},
  "Silverstone":{laps:52,length:"5.891 km",lapRecord:"1:27.097",holder:"Max Verstappen",year:2020,drs:2,firstGP:1950},
  "Hungaroring":{laps:70,length:"4.381 km",lapRecord:"1:16.627",holder:"Lewis Hamilton",year:2020,drs:2,firstGP:1986},
  "Spa-Francorchamps":{laps:44,length:"7.004 km",lapRecord:"1:46.286",holder:"Valtteri Bottas",year:2018,drs:2,firstGP:1950},
  "Zandvoort":{laps:72,length:"4.259 km",lapRecord:"1:11.097",holder:"Lewis Hamilton",year:2021,drs:2,firstGP:1952},
  "Monza":{laps:53,length:"5.793 km",lapRecord:"1:21.046",holder:"Rubens Barrichello",year:2004,drs:2,firstGP:1950},
  "Baku":{laps:51,length:"6.003 km",lapRecord:"1:43.009",holder:"Charles Leclerc",year:2019,drs:2,firstGP:2016},
  "Marina Bay":{laps:62,length:"4.940 km",lapRecord:"1:35.867",holder:"Lewis Hamilton",year:2023,drs:3,firstGP:2008},
  "Austin":{laps:56,length:"5.513 km",lapRecord:"1:36.169",holder:"Charles Leclerc",year:2019,drs:2,firstGP:2012},
  "Mexico City":{laps:71,length:"4.304 km",lapRecord:"1:17.774",holder:"Valtteri Bottas",year:2021,drs:3,firstGP:1963},
  "Interlagos":{laps:71,length:"4.309 km",lapRecord:"1:10.540",holder:"Valtteri Bottas",year:2018,drs:2,firstGP:1973},
  "Las Vegas":{laps:50,length:"6.201 km",lapRecord:"1:35.490",holder:"Oscar Piastri",year:2024,drs:2,firstGP:2023},
  "Lusail":{laps:57,length:"5.380 km",lapRecord:"1:24.319",holder:"Max Verstappen",year:2023,drs:2,firstGP:2021},
  "Yas Marina Circuit":{laps:58,length:"5.281 km",lapRecord:"1:26.103",holder:"Max Verstappen",year:2021,drs:2,firstGP:2009},
};

function parseMarkdown(text) {
  if (!text) return null;
  const parts = text.split(/\*\*(.*?)\*\*/g);
  return parts.map((part, i) =>
    i % 2 === 1
      ? <span key={i} style={{color:"#fff",fontWeight:700}}>{part}</span>
      : <span key={i} style={{color:"#ccc"}}>{part}</span>
  );
}

function AuthModal({ onClose, onAuth }) {
  const [mode, setMode] = useState("signin");
  const [email, setEmail] = useState("");
  const [password, setPassword] = useState("");
  const [error, setError] = useState("");
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState("");

  const handle = async () => {
    setLoading(true); setError(""); setMessage("");
    try {
      if (mode === "signin") {
        const { data, error } = await supabase.auth.signInWithPassword({ email, password });
        if (error) throw error;
        onAuth(data.user); onClose();
      } else {
        const { error } = await supabase.auth.signUp({ email, password });
        if (error) throw error;
        setMessage("Check your email to confirm your account, then sign in.");
      }
    } catch (e) { setError(e.message); }
    setLoading(false);
  };

  return (
    <div style={s.overlay}>
      <div style={s.modal}>
        <div style={{display:"flex",alignItems:"center",gap:10,marginBottom:8}}>
          <span style={{fontSize:28}}>🏁</span>
          <span style={{fontSize:22,fontWeight:800}}>PitWall</span>
        </div>
        <div style={s.modeTabs}>
          {["signin","signup"].map(m => (
            <button key={m} onClick={() => { setMode(m); setError(""); setMessage(""); }}
              style={{...s.modeTab,...(mode===m?s.modeTabActive:{})}}>
              {m==="signin"?"Sign In":"Sign Up"}
            </button>
          ))}
        </div>
        <input style={s.authInput} type="email" placeholder="Email" value={email} onChange={e=>setEmail(e.target.value)} />
        <input style={s.authInput} type="password" placeholder="Password" value={password}
          onChange={e=>setPassword(e.target.value)} onKeyDown={e=>e.key==="Enter"&&handle()} />
        {error && <p style={{color:"#e8002d",fontSize:13,margin:0}}>{error}</p>}
        {message && <p style={{color:"#39b54a",fontSize:13,margin:0}}>{message}</p>}
        <button style={s.authBtn} onClick={handle} disabled={loading}>
          {loading?"...":(mode==="signin"?"Sign In":"Create Account")}
        </button>
        <button style={s.authSkip} onClick={onClose}>Continue without account</button>
      </div>
    </div>
  );
}

function SessionList({ onSelect }) {
  const [sessions, setSessions] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    axios.get(`${API}/api/session`).then(res => {
      const seen = new Set();
      const unique = res.data
        .filter(s => s.session_name==="Race")
        .sort((a,b) => new Date(a.date_start)-new Date(b.date_start))
        .filter(s => seen.has(s.circuit_short_name) ? false : seen.add(s.circuit_short_name));
      setSessions(unique); setLoading(false);
    });
  }, []);

  if (loading) return <div style={s.center}><div style={s.spinner}/><p style={{color:"#888",marginTop:16,fontSize:14}}>Loading race calendar...</p></div>;

  const formatDate = dateStr => {
    const d = dateStr.slice(0, 10);
    const [, month, day] = d.split("-");
    const monthName = ["JAN","FEB","MAR","APR","MAY","JUN","JUL","AUG","SEP","OCT","NOV","DEC"][parseInt(month)-1];
    return { month: monthName, day: day };
  };

  return (
    <div style={{padding:"0 0 40px"}}>
      <p style={s.subtitle}>2025 Race Calendar — Select a race for circuit info</p>
      <div style={s.calList}>
        {sessions.map(session => {
          const {month,day} = formatDate(session.date_start);
          const flag = countryFlags[session.country_name]||"🏁";
          return (
            <div key={session.session_key} style={s.calCard}
              onClick={() => onSelect(session)}
              onMouseEnter={e=>e.currentTarget.style.background="#161616"}
              onMouseLeave={e=>e.currentTarget.style.background="#111"}>
              <div style={s.calDate}>
                <div style={s.calMonth}>{month}</div>
                <div style={s.calDay}>{day}</div>
              </div>
              <div style={s.calDivider}/>
              <div style={s.calInfo}>
                <div style={s.calName}>{session.circuit_short_name}</div>
                <div style={s.calCountry}>{flag} {session.country_name}</div>
              </div>
              <div style={s.calArrow}>›</div>
            </div>
          );
        })}
      </div>
    </div>
  );
}

function RaceInfo({ session, onViewDrivers, onBack }) {
  const info = circuitDatabase[session.circuit_short_name]||circuitDatabase[session.location];
  const flag = countryFlags[session.country_name]||"🏁";
  return (
    <div style={s.screen}>
      <button style={s.back} onClick={onBack}>← Back</button>
      <div style={s.gradientHeader}>
        <div style={{flex:1}}>
          <div style={{fontSize:11,color:"#e8002d",fontWeight:700,letterSpacing:1,marginBottom:6}}>RACE INFO</div>
          <div style={{fontSize:28,fontWeight:800,color:"#fff"}}>{session.circuit_short_name}</div>
          <div style={{fontSize:14,color:"rgba(255,255,255,0.6)",marginTop:4}}>{flag} {session.country_name}</div>
        </div>
        <div style={{color:"#e8002d",fontSize:13,fontWeight:600,alignSelf:"flex-start"}}>{session.date_start?.slice(0,10)}</div>
      </div>
      {info ? (
        <>
          <div style={s.statsGrid}>
            {[{ icon: "🏁", label: "Laps", value: info.laps },
              { icon: "📐", label: "Circuit Length", value: info.length },
              { icon: "⚡", label: "DRS Zones", value: info.drs },
              { icon: "🏆", label: "First GP", value: info.firstGP }].map(stat => (
              <div key={stat.label} style={s.statCard}>
                <div style={{fontSize:22,marginBottom:8}}>{stat.icon}</div>
                <div style={{color:"#fff",fontWeight:700,fontSize:20}}>{stat.value}</div>
                <div style={{color:"#666",fontSize:11,marginTop:4}}>{stat.label}</div>
              </div>
            ))}
          </div>
          <div style={s.lapRecord}>
            <div style={{color:"#e8002d",fontWeight:700,fontSize:11,letterSpacing:1.5,marginBottom:10}}>LAP RECORD</div>
            <div style={{color:"#fff",fontFamily:"'Courier New',monospace",fontSize:40,fontWeight:700,letterSpacing:2}}>{info.lapRecord}</div>
            <div style={{display:"flex",justifyContent:"space-between",marginTop:10}}>
              <span style={{color:"#888",fontSize:13}}>{info.holder}</span>
              <span style={{color:"#888",fontSize:13}}>{info.year}</span>
            </div>
          </div>
        </>
      ) : <p style={{color:"#888"}}>Circuit data not available</p>}
      <button style={s.redBtn} onClick={onViewDrivers}>View Driver Standings</button>
    </div>
  );
}

function DriverList({ session, onSelectDriver, onBack }) {
  const [drivers, setDrivers] = useState([]);
  const [loading, setLoading] = useState(true);
  const flag = countryFlags[session.country_name]||"🏁";

  useEffect(() => {
    axios.get(`https://api.openf1.org/v1/drivers?session_key=${session.session_key}`)
      .then(res => {
        const unique = Object.values(res.data.reduce((acc,d) => { if(!acc[d.driver_number]) acc[d.driver_number]=d; return acc; },{}))
          .sort((a,b) => Number(a.driver_number)-Number(b.driver_number));
        setDrivers(unique); setLoading(false);
      }).catch(() => setLoading(false));
  }, []);

  return (
    <div style={s.screen}>
      <button style={s.back} onClick={onBack}>← Back</button>
      <div style={{display:"flex",justifyContent:"space-between",alignItems:"flex-start",marginBottom:20}}>
        <div>
          <div style={{fontSize:22,fontWeight:800,color:"#fff"}}>{session.circuit_short_name}</div>
          <div style={{fontSize:13,color:"#888",marginTop:2}}>{flag} {session.country_name}</div>
        </div>
        <div style={{color:"#e8002d",fontSize:11,fontWeight:700,letterSpacing:1}}>DRIVER STANDINGS</div>
      </div>
      {loading ? <div style={s.center}><div style={s.spinner}/></div> : (
        <div style={{display:"flex",flexDirection:"column",gap:8}}>
          {drivers.map(d => {
            const color = d.team_colour?`#${d.team_colour}`:"#666";
            const acronym = d.name_acronym||"---";
            return (
              <div key={d.driver_number} onClick={() => onSelectDriver(d)} style={s.driverCard}
                onMouseEnter={e=>{e.currentTarget.style.borderColor=color;e.currentTarget.style.background="#161616";}}
                onMouseLeave={e=>{e.currentTarget.style.borderColor="#1e1e1e";e.currentTarget.style.background="#111";}}>
                <div style={{width:4,height:48,background:color,borderRadius:2,flexShrink:0}}/>
                <div style={{background:color+"22",border:`1px solid ${color}44`,borderRadius:8,padding:"6px 10px",minWidth:44,textAlign:"center"}}>
                  <span style={{color,fontWeight:800,fontSize:13}}>{acronym}</span>
                </div>
                <div style={{flex:1}}>
                  <div style={{color:"#fff",fontWeight:600,fontSize:15}}>{d.full_name}</div>
                  <div style={{color:"#666",fontSize:12,marginTop:2}}>{d.team_name}</div>
                </div>
                <div style={{color,fontWeight:700,fontSize:14}}>#{d.driver_number}</div>
                <div style={{color:"#444",fontSize:18}}>›</div>
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
}

function StrategyForm({ session, driver, user, onBack }) {
  const info = circuitDatabase[session.circuit_short_name]||circuitDatabase[session.location];
  const [form, setForm] = useState({
    driverName: driver?.full_name??"Max Verstappen",
    driverNumber: driver?.driver_number??1,
    currentLap: 30, totalLaps: info?.laps??57,
    position: 2, tireCompound: "Medium", tireAge: 15,
    gapAhead: 1.2, gapBehind: 3.5, weatherCondition: "Dry",
  });
  const [result, setResult] = useState("");
  const [loading, setLoading] = useState(false);
  const [saved, setSaved] = useState(false);
  const set = (k,v) => setForm(f=>({...f,[k]:v}));
  const teamColor = driver?.team_colour?`#${driver.team_colour}`:"#e8002d";

  const getStrategy = async () => {
    setLoading(true); setResult(""); setSaved(false);
    try {
      const res = await axios.post(`${API}/api/strategy`, {
        circuitName:session.circuit_short_name, countryName:session.country_name,
        driverName:form.driverName, driverNumber:Number(form.driverNumber),
        currentLap:Number(form.currentLap), totalLaps:Number(form.totalLaps),
        position:Number(form.position), tireCompound:form.tireCompound,
        tireAge:Number(form.tireAge), gapAhead:Number(form.gapAhead),
        gapBehind:Number(form.gapBehind), weatherCondition:form.weatherCondition,
      });
      const strategy = res.data.strategy;
      setResult(strategy);
      if (user) {
        await supabase.from("strategy_history").insert({
          user_id:user.id, circuit:session.circuit_short_name, driver:form.driverName,
          compound:form.tireCompound, weather:form.weatherCondition,
          current_lap:Number(form.currentLap), total_laps:Number(form.totalLaps),
          position:Number(form.position), recommendation:strategy,
        });
        setSaved(true);
      }
    } catch { setResult("Error connecting to strategy engine. Please try again."); }
    setLoading(false);
  };

  return (
    <div style={s.screen}>
      <button style={s.back} onClick={onBack}>← Back</button>
      <div style={{...s.gradientHeader}}>
        <div style={{flex:1}}>
          <div style={{fontSize:11,color:"#e8002d",fontWeight:700,letterSpacing:1,marginBottom:4}}>STRATEGY</div>
          <div style={{fontSize:24,fontWeight:800,color:"#fff"}}>{session.circuit_short_name}</div>
          <div style={{fontSize:13,color:"rgba(255,255,255,0.5)",marginTop:2}}>{form.driverName} #{form.driverNumber}</div>
        </div>
        <div style={{color:"#888",fontSize:13,alignSelf:"flex-start"}}>{session.country_name}</div>
      </div>
      <div style={s.formGrid}>
        {[["Driver Name","driverName","text"],["Driver Number","driverNumber","number"],
          ["Position","position","number"],["Tire Age (laps)","tireAge","number"],
          ["Gap Ahead (sec)","gapAhead","number"],["Gap Behind (sec)","gapBehind","number"]].map(([label,key,type]) => (
          <div key={key} style={s.field}>
            <label style={s.label}>{label}</label>
            <input style={s.input} type={type} value={form[key]} onChange={e=>set(key,e.target.value)}/>
          </div>
        ))}
      </div>
      <div style={{display:"grid",gridTemplateColumns:"1fr 1fr",gap:16,marginBottom:20}}>
        {[["Current Lap","currentLap"],["Total Laps","totalLaps"]].map(([label,key]) => (
          <div key={key} style={s.field}>
            <label style={s.label}>{label}</label>
            <div style={s.stepper}>
              <button style={s.stepBtn} onClick={()=>set(key,Math.max(1,Number(form[key])-1))}>−</button>
              <span style={{flex:1,textAlign:"center",color:"#fff",fontWeight:700,fontSize:16}}>{form[key]}</span>
              <button style={s.stepBtn} onClick={()=>set(key,Math.min(100,Number(form[key])+1))}>+</button>
            </div>
          </div>
        ))}
      </div>
      <div style={{marginBottom:16}}>
        <label style={{...s.label,marginBottom:8,display:"block",textAlign:"center"}}>Tire Compound</label>
        <div style={{...s.tireRow,justifyContent:"center"}}>
          {["Soft","Medium","Hard","Intermediate","Wet"].map(t => (
            <button key={t} onClick={()=>set("tireCompound",t)} style={{
              ...s.tireBtn,
              background:form.tireCompound===t?tireColors[t]:"#1a1a1a",
              color:form.tireCompound===t&&t!=="Hard"?"#000":form.tireCompound===t?"#000":"#fff",
              borderColor:form.tireCompound===t?tireColors[t]:"#333",
            }}>{t}</button>
          ))}
        </div>
      </div>
      <div style={{marginBottom:24,background:"#111",borderRadius:14,padding:16,border:"1px solid #1a1a1a"}}>
        <label style={{...s.label,marginBottom:12,display:"block",textAlign:"center"}}>Track Conditions</label>
        <div style={{...s.weatherRow,justifyContent:"center"}}>
          {weatherOptions.map(w => (
            <button key={w.name} onClick={()=>set("weatherCondition",w.name)} style={{
              ...s.weatherBtn,
              background:form.weatherCondition===w.name?"#1e3a5f":"#1a1a1a",
              borderColor:form.weatherCondition===w.name?"#4a9eff":"#333",
            }}>
              <span style={{fontSize:20}}>{w.icon}</span>
              <span style={{fontSize:11,color:form.weatherCondition===w.name?"#fff":"#888"}}>{w.name}</span>
            </button>
          ))}
        </div>
      </div>
      <button style={s.glowBtn} onClick={getStrategy} disabled={loading}>
        {loading?"Analyzing...":"🧠 Get AI Strategy"}
      </button>
      {result && (
        <div style={s.resultCard}>
          <div style={{display:"flex",justifyContent:"space-between",alignItems:"center",marginBottom:14}}>
            <div style={{display:"flex",alignItems:"center",gap:8}}>
              <span style={{color:"#e8002d"}}>📡</span>
              <span style={{color:"#e8002d",fontWeight:700,fontSize:12,letterSpacing:1.5}}>STRATEGY CALL</span>
            </div>
            {saved && <span style={{color:"#39b54a",fontSize:12}}>✓ Saved</span>}
          </div>
          <div style={{lineHeight:1.8,fontSize:14}}>
            {result.split("\n").map((line,i) => (
              <div key={i} style={{marginBottom:4}}>{parseMarkdown(line)}</div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
}

function StrategyHistory({ user, onBack }) {
  const [history, setHistory] = useState([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    supabase.from("strategy_history").select("*").eq("user_id",user.id)
      .order("created_at",{ascending:false}).then(({data}) => { setHistory(data||[]); setLoading(false); });
  }, [user]);

  return (
    <div style={s.screen}>
      <button style={s.back} onClick={onBack}>← Back</button>
      <div style={{marginBottom:24}}>
        <div style={{fontSize:22,fontWeight:800,color:"#fff"}}>Strategy History</div>
        <div style={{fontSize:13,color:"#666",marginTop:2}}>Your past AI strategy calls</div>
      </div>
      {loading ? <div style={s.center}><div style={s.spinner}/></div> :
       history.length===0 ? <div style={{color:"#666",textAlign:"center",paddingTop:60,fontSize:14}}>No strategy calls yet. Run your first analysis!</div> : (
        <div style={{display:"flex",flexDirection:"column",gap:12}}>
          {history.map(h => (
            <div key={h.id} style={s.historyCard}>
              <div style={{display:"flex",justifyContent:"space-between",marginBottom:10}}>
                <div>
                  <div style={{color:"#fff",fontWeight:700,fontSize:15}}>{h.circuit}</div>
                  <div style={{color:"#888",fontSize:12,marginTop:2}}>{h.driver}</div>
                </div>
                <div style={{textAlign:"right"}}>
                  <div style={{color:tireColors[h.compound]||"#888",fontWeight:700,fontSize:12}}>{h.compound}</div>
                  <div style={{color:"#555",fontSize:11,marginTop:2}}>{h.weather}</div>
                </div>
              </div>
              <div style={{color:"#666",fontSize:11,marginBottom:8}}>Lap {h.current_lap}/{h.total_laps} · P{h.position}</div>
              <div style={{borderTop:"1px solid #1e1e1e",paddingTop:10,fontSize:13,lineHeight:1.6}}>
                {h.recommendation?.split("\n").slice(0,3).map((line,i) => (
                  <div key={i} style={{marginBottom:2}}>{parseMarkdown(line)}</div>
                ))}
              </div>
              <div style={{color:"#444",fontSize:11,marginTop:8}}>
                {new Date(h.created_at).toLocaleDateString("en",{month:"short",day:"numeric",year:"numeric",hour:"2-digit",minute:"2-digit"})}
              </div>
            </div>
          ))}
        </div>
      )}
    </div>
  );
}

export default function App() {
  const [user, setUser] = useState(null);
  const [showAuth, setShowAuth] = useState(false);
  const [showHistory, setShowHistory] = useState(false);
  const [selected, setSelected] = useState(null);
  const [showDrivers, setShowDrivers] = useState(false);
  const [selectedDriver, setSelectedDriver] = useState(null);

  useEffect(() => {
    supabase.auth.getSession().then(({data}) => setUser(data.session?.user??null));
    const {data:listener} = supabase.auth.onAuthStateChange((_e,session) => setUser(session?.user??null));
    return () => listener.subscription.unsubscribe();
  }, []);

  const signOut = async () => { await supabase.auth.signOut(); setUser(null); setShowHistory(false); };

  const goHome = () => { setSelected(null); setShowDrivers(false); setSelectedDriver(null); setShowHistory(false); };

  return (
    <div style={s.app}>
      <style>{`
        @keyframes spin { to { transform: rotate(360deg); } }
        * { box-sizing: border-box; }
        input:focus { outline: none; border-color: #e8002d !important; }
        button:disabled { opacity: 0.6; cursor: not-allowed; }
        ::-webkit-scrollbar { width: 4px; }
        ::-webkit-scrollbar-track { background: #0a0a0a; }
        ::-webkit-scrollbar-thumb { background: #333; border-radius: 2px; }
      `}</style>

      <div style={s.header}>
        <div style={{display:"flex",alignItems:"center",gap:10,cursor:"pointer"}} onClick={goHome}>
          <span style={{fontSize:26}}>🏁</span>
          <span style={s.title}>PitWall</span>
          <span style={s.tagline}>Your AI Race Strategist</span>
        <div style={s.badge2025}>
          <div style={s.badgeDot}/><span style={s.badgeText}>2025</span>
        </div>
        </div>
        <div style={{display:"flex",alignItems:"center",gap:12}}>
          {user ? (
            <>
              <button style={s.historyBtn} onClick={()=>setShowHistory(true)}>📋 History</button>
              <span style={{color:"#555",fontSize:12}}>{user.email}</span>
              <button style={s.signOutBtn} onClick={signOut}>Sign Out</button>
            </>
          ) : (
            <button style={s.signInBtn} onClick={()=>setShowAuth(true)}>Sign In</button>
          )}
        </div>
      </div>

      {showAuth && <AuthModal onClose={()=>setShowAuth(false)} onAuth={setUser}/>}

      <div style={s.content}>
        {showHistory && user && <StrategyHistory user={user} onBack={()=>setShowHistory(false)}/>}
        {!showHistory && !selected && <SessionList onSelect={setSelected}/>}
        {!showHistory && selected && !showDrivers && !selectedDriver && <RaceInfo session={selected} onViewDrivers={()=>setShowDrivers(true)} onBack={()=>setSelected(null)}/>}
        {!showHistory && selected && showDrivers && !selectedDriver && <DriverList session={selected} onSelectDriver={setSelectedDriver} onBack={()=>setShowDrivers(false)}/>}
        {!showHistory && selected && selectedDriver && <StrategyForm session={selected} driver={selectedDriver} user={user} onBack={()=>setSelectedDriver(null)}/>}
      </div>
    </div>
  );
}

const s = {
  app:{minHeight:"100vh",background:"#0a0a0a",color:"#fff",fontFamily:"'SF Pro Display',-apple-system,BlinkMacSystemFont,sans-serif"},
  header:{display:"flex",alignItems:"center",justifyContent:"space-between",padding:"18px 32px",borderBottom:"1px solid #151515",position:"sticky",top:0,background:"#0a0a0aee",backdropFilter:"blur(12px)",zIndex:100},
  title:{fontSize:20,fontWeight:800,letterSpacing:-0.5},
  tagline:{color:"#555",fontSize:11,letterSpacing:0.5,marginLeft:4},
  content:{width:"100%"},
  subtitle:{color:"#555",fontSize:12,padding:"20px 32px 12px",letterSpacing:0.5,textTransform:"none"},
  calList:{display:"flex",flexDirection:"column",gap:6,padding:"0 32px"},
  calCard:{display:"flex",alignItems:"center",background:"#111",borderRadius:12,overflow:"hidden",cursor:"pointer",transition:"background 0.15s"},
  calDate:{padding:"16px 20px",minWidth:72,textAlign:"center",flexShrink:0},
  calMonth:{color:"#e8002d",fontSize:11,fontWeight:700,letterSpacing:1},
  calDay:{color:"#fff",fontSize:22,fontWeight:800,lineHeight:1.2},
  calDivider:{width:1,height:44,background:"#e8002d",flexShrink:0},
  calInfo:{flex:1,padding:"0 20px"},
  calName:{color:"#fff",fontWeight:700,fontSize:16},
  calCountry:{color:"#666",fontSize:13,marginTop:2},
  calArrow:{color:"#333",fontSize:22,paddingRight:20},
  screen:{padding:"24px 32px 60px"},
  back:{background:"none",border:"1px solid #222",color:"#888",padding:"8px 16px",borderRadius:8,cursor:"pointer",marginBottom:24,fontSize:13},
  gradientHeader:{background:"linear-gradient(135deg,#1a0000 0%,#2d0000 50%,#111 100%)",borderRadius:16,padding:"24px",marginBottom:24,display:"flex",justifyContent:"space-between",alignItems:"center",border:"1px solid #2a0000",overflow:"hidden",position:"relative"},
  statsGrid:{display:"grid",gridTemplateColumns:"1fr 1fr",gap:10,marginBottom:16},
  statCard:{background:"#111",borderRadius:14,padding:"20px 16px",textAlign:"center",border:"1px solid #1a1a1a"},
  lapRecord:{background:"#111",borderRadius:14,padding:24,border:"1px solid #e8002d33",marginBottom:24},
  driverCard:{display:"flex",alignItems:"center",gap:14,background:"#111",borderRadius:12,padding:"14px 16px",cursor:"pointer",border:"1px solid #1e1e1e",transition:"border-color 0.2s,background 0.15s"},
  formGrid:{display:"grid",gridTemplateColumns:"1fr 1fr",gap:16,marginBottom:20},
  field:{display:"flex",flexDirection:"column",gap:6},
  label:{color:"#666",fontSize:11,letterSpacing:0.5,textTransform:"uppercase"},
  input:{background:"#111",border:"1px solid #222",color:"#fff",padding:"11px 14px",borderRadius:10,fontSize:14},
  stepper:{display:"flex",alignItems:"center",background:"#111",borderRadius:10,border:"1px solid #222"},
  stepBtn:{background:"none",border:"none",color:"#e8002d",fontSize:20,padding:"10px 16px",cursor:"pointer",fontWeight:700},
  tireRow:{display:"flex",gap:8,flexWrap:"wrap"},
  tireBtn:{padding:"8px 16px",borderRadius:8,border:"1px solid",cursor:"pointer",fontWeight:600,fontSize:13},
  weatherRow:{display:"flex",gap:8,flexWrap:"wrap"},
  weatherBtn:{display:"flex",flexDirection:"column",alignItems:"center",gap:4,padding:"10px 14px",borderRadius:10,border:"1px solid",cursor:"pointer",minWidth:64},
  glowBtn:{width:"100%",background:"linear-gradient(135deg,#e8002d,#c0001f)",color:"#fff",border:"none",padding:"16px",borderRadius:14,fontSize:16,fontWeight:700,cursor:"pointer",marginBottom:24,boxShadow:"0 4px 24px #e8002d44"},
  redBtn:{width:"100%",background:"#e8002d",color:"#fff",border:"none",padding:"15px",borderRadius:14,fontSize:15,fontWeight:700,cursor:"pointer"},
  resultCard:{background:"#111",border:"1px solid #e8002d33",borderRadius:14,padding:20},
  historyCard:{background:"#111",borderRadius:14,padding:18,border:"1px solid #1a1a1a"},
  overlay:{position:"fixed",inset:0,background:"rgba(0,0,0,0.85)",backdropFilter:"blur(8px)",display:"flex",alignItems:"center",justifyContent:"center",zIndex:200},
  modal:{background:"#111",border:"1px solid #222",borderRadius:20,padding:32,width:"100%",maxWidth:380,display:"flex",flexDirection:"column",gap:12},
  modeTabs:{display:"flex",background:"#0a0a0a",borderRadius:10,padding:4,gap:4,marginBottom:4},
  modeTab:{flex:1,padding:"8px",borderRadius:8,border:"none",background:"none",color:"#666",cursor:"pointer",fontWeight:600,fontSize:14},
  modeTabActive:{background:"#1a1a1a",color:"#fff"},
  authInput:{background:"#0a0a0a",border:"1px solid #222",color:"#fff",padding:"12px 14px",borderRadius:10,fontSize:14},
  authBtn:{background:"#e8002d",color:"#fff",border:"none",padding:"13px",borderRadius:10,fontSize:15,fontWeight:700,cursor:"pointer",marginTop:4},
  authSkip:{background:"none",border:"none",color:"#555",fontSize:13,cursor:"pointer",textAlign:"center",padding:4},
  signInBtn:{background:"none",border:"1px solid #333",color:"#fff",padding:"8px 16px",borderRadius:8,cursor:"pointer",fontSize:13,fontWeight:600},
  signOutBtn:{background:"none",border:"1px solid #333",color:"#888",padding:"8px 16px",borderRadius:8,cursor:"pointer",fontSize:13},
  historyBtn:{background:"none",border:"1px solid #333",color:"#fff",padding:"8px 14px",borderRadius:8,cursor:"pointer",fontSize:13},
  center:{display:"flex",flexDirection:"column",alignItems:"center",paddingTop:80},
  spinner:{width:28,height:28,border:"2px solid #222",borderTop:"2px solid #e8002d",borderRadius:"50%",animation:"spin 0.8s linear infinite"},
  badge2025:{display:"flex",alignItems:"center",gap:4,background:"rgba(232,0,45,0.15)",borderRadius:20,padding:"4px 10px",marginLeft:8},
  badgeDot:{width:7,height:7,borderRadius:"50%",background:"#e8002d",flexShrink:0},
  badgeText:{color:"#e8002d",fontSize:11,fontWeight:700},
};
