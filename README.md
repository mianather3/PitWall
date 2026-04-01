# 🏁 PitWall — AI F1 Race Strategist

> Your AI-powered Formula 1 pit stop strategy engine, built for the pit wall.

## 🚀 Live Demo
**Backend API:** https://pitwallapi.azurewebsites.net/api/session

## 📱 What It Does
PitWall is a full-stack iOS app that gives Formula 1 fans real-time AI-powered race strategy recommendations — just like a real pit wall strategist.

- Browse the live 2025 F1 race calendar
- Select any race and input real-time race conditions
- Get instant AI pit stop strategy recommendations powered by GPT-4o-mini
- Receive tire compound suggestions, timing recommendations, and risk assessments

## 🛠️ Tech Stack
| Layer | Technology |
|-------|-----------|
| iOS Frontend | Swift, SwiftUI |
| Backend API | C#, .NET 10, Blazor Web API |
| AI Engine | OpenAI GPT-4o-mini |
| Live F1 Data | OpenF1 API |
| Cloud Deployment | Microsoft Azure App Service |
| Version Control | Git, GitHub |

## 🏗️ Architecture
```
[ SwiftUI iOS App ]
        ↕ HTTP
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

## 🤖 AI Strategy Engine
The strategy engine analyzes:
- Current lap and total laps remaining
- Tire compound and age
- Gap to car ahead and behind
- Driver position
- Circuit characteristics

And returns a structured recommendation including pit timing, tire compound suggestion, strategic reasoning, and risk level.

## 🏎️ Built By
**Mian Ather Ali** — CS/DS Student, University of Utah Honors College  
[LinkedIn](https://linkedin.com/in/mianather) | [GitHub](https://github.com/mianather3) | [Portfolio](https://mianather3.github.io/Portfolio/)
