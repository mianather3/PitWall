# 🏁 PitWall — AI F1 Race Strategist

> Your AI-powered Formula 1 pit stop strategy engine, built for the pit wall.

## 🚀 Live Demo
- **Web App:** https://pitwallapp.vercel.app
- **Backend API:** https://pitwallapi.azurewebsites.net/api/session

## 📱 What It Does
PitWall is a full-stack iOS + web app that gives Formula 1 fans real-time AI-powered race strategy recommendations — just like a real pit wall strategist.

**App Flow:**
1. Browse the live 2025 F1 race calendar
2. View circuit info — laps, length, DRS zones, lap record
3. Select a driver from real race standings with team colors
4. Input race conditions and get instant AI pit stop strategy

**AI Strategy Engine analyzes:**
- Tire compound and age
- Current lap vs total laps
- Gap to car ahead and behind
- Track conditions (Dry, Cloudy, Light Rain, Heavy Rain, Safety Car)
- Driver position

## 🛠️ Tech Stack
| Layer | Technology |
|-------|-----------|
| iOS Frontend | Swift, SwiftUI |
| Web Frontend | React, Vite |
| Backend API | C#, .NET 10, Blazor Web API |
| AI Engine | OpenAI GPT-4o-mini |
| Live F1 Data | OpenF1 API |
| Cloud Deployment | Microsoft Azure App Service |
| Web Deployment | Vercel |
| Version Control | Git, GitHub |

## 🏗️ Architecture

```
[ SwiftUI iOS App ] [ React Web App ]
          ↕ HTTPS
  [ Blazor C#/.NET REST API ]
          ↕
[ OpenF1 API ] + [ OpenAI GPT-4o-mini ]
          ↕
    [ Azure App Service ]
```

## 📡 API Endpoints
- `GET /api/session` — Live 2025 F1 race calendar
- `GET /api/positions/{sessionKey}` — Driver positions for a session
- `POST /api/strategy` — AI pit stop strategy recommendation

## 📸 Features — v2.0
- 🏎️ Live 2025 F1 race calendar
- 🏟️ Circuit info — laps, length, DRS zones, lap record
- 👥 Real driver standings with actual team colors
- ☀️ Weather/track condition selector
- 🔢 Lap counter stepper
- 🧠 GPT-4o-mini AI strategy engine
- 📱 Custom app icon
- ☁️ Production deployed on Azure + Vercel

## 🏎️ Built By
**Mian Ather Ali** — CS/DS Student, University of Utah Honors College  
[LinkedIn](https://linkedin.com/in/mianather) | [GitHub](https://github.com/mianather3) | [Portfolio](https://mianather3.github.io/Portfolio/)