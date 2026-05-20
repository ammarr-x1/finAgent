Financial Market Reaction Agent
Autonomous Content-to-Action System Using Google Antigravity
1. Project Overview
Project Name
Financial Market Reaction Agent
Challenge Category
Challenge 1 — Autonomous Content-to-Action Agent
(Insight → Action System)
Core Objective
The system automatically:
1.	Collects financial and market-related information
2.	Understands and extracts insights
3.	Analyzes financial impact
4.	Generates autonomous decisions
5.	Simulates financial actions
6.	Updates system state
7.	Shows outcome visualization
2. Core Concept
The system behaves like an intelligent autonomous financial analyst.
Instead of simply summarizing news, the system:
•	understands events
•	reasons about consequences
•	evaluates risk
•	decides actions
•	executes simulated trades
•	updates portfolio state
•	communicates results
 
3. Why This Project Is Strong
This project strongly satisfies all judging criteria because it demonstrates:
•	agentic reasoning
•	planning and execution
•	multi-agent orchestration
•	autonomous decision making
•	realistic action simulation
•	clear system state changes
•	real-world applicability
4. High-Level System Architecture
Financial News APIs
        +
RSS Feeds
        +
Mock Social Media Data
        +
Stock Market APIs
                ↓
      Input Processing Layer
                ↓
     Google Antigravity Orchestrator
                ↓
 ┌────────────────────────────────┐
 │      Multi-Agent Workflow      │
 └────────────────────────────────┘
                ↓
  Insight + Risk + Decision Engine
                ↓
      Trade Simulation System
                ↓
 Notifications + Portfolio Update
                ↓
      Outcome Visualization
5. Role of Google Antigravity
Google Antigravity is the CENTRAL orchestration system.
It is NOT used superficially.
Antigravity Responsibilities
1. Agent Orchestration
Controls:
•	workflow sequence
•	task delegation
•	communication between agents
2. Planning & Reasoning
Handles:
•	multi-step reasoning
•	contextual memory
•	decision chains
3. Tool Integration
Antigravity connects:
•	News APIs
•	RSS feeds
•	stock APIs
•	mock datasets
•	databases
 
4. Execution Handling
Manages:
•	trade simulations
•	notification triggers
•	state updates
•	logging
5. Agent Trace Logging
Provides:
•	reasoning logs
•	execution traces
•	workflow transparency
This is VERY important for judges.
6. FULL DETAILED WORKFLOW
STEP 1 — Data Collection Layer
Purpose
Collect market-related information from multiple sources.
Input Sources
A. Financial News APIs
Used for:
•	market news
•	geopolitical news
•	inflation
•	oil prices
•	earnings reports
 
Recommended APIs
Primary APIs
NewsAPI
Free tier available.
Use for:
•	finance headlines
•	business news
•	economic events
GNews API
Backup news provider.
Mediastack
Additional backup source.
Finnhub API
Financial market news.
MarketAux
Financial intelligence API.
API Fallback Strategy
If one API limit is exhausted:
NewsAPI
   ↓
GNews
   ↓
Mediastack
   ↓
Local Mock Dataset
This guarantees uninterrupted demos.
 
B. RSS Feed Sources
RSS feeds are FREE and reliable.
Recommended RSS Sources
•	Reuters Business RSS
•	Yahoo Finance RSS
•	CNBC RSS
•	Investing.com RSS
Why RSS Is Important
RSS feeds:
•	avoid API limits
•	are lightweight
•	are free
•	provide real headlines
Example RSS Workflow
RSS Feed
   ↓
Feed Parser
   ↓
Headline Extraction
   ↓
Antigravity Processing
C. Stock Market APIs
Used for:
•	stock prices
•	historical data
•	volatility
•	sector performance
 
Recommended APIs
Primary
Yahoo Finance yfinance Library
Completely free.
This should be your MAIN stock source.
Backup APIs
Alpha Vantage
Twelve Data
Financial Modeling Prep
STEP 2 — Social Media Signal System
IMPORTANT DESIGN DECISION
DO NOT rely heavily on Twitter/X APIs.
Twitter/X APIs are expensive and restrictive.
Recommended Approach
Use MOCK SOCIAL DATA.
This is fully acceptable in hackathons.
Why Mock Data Is Better
Advantages
•	no API costs
•	no rate limits
•	predictable outputs
•	stable demos
•	easier debugging
Mock Social Data Structure
Store data locally in JSON format.
 
Example Mock Dataset
[
  {
    "platform": "X",
    "username": "marketwatcher",
    "post": "Oil prices are skyrocketing rapidly.",
    "timestamp": "2026-05-14T10:00:00"
  },
  {
    "platform": "Reddit",
    "subreddit": "stocks",
    "post": "Transportation companies may struggle due to rising fuel costs.",
    "timestamp": "2026-05-14T10:05:00"
  }
]
How Mock Social Data Is Used
Mock Social JSON
        ↓
Social Signal Agent
        ↓
Sentiment Analysis
        ↓
Insight Extraction
 
Optional Real APIs
Reddit API
Reddit Developer API
Optional only.
STEP 3 — Input Processing Agent
Agent Name
Input Intelligence Agent
Purpose
Process and normalize all incoming data.
Responsibilities
This Agent:
•	reads headlines
•	processes RSS feeds
•	loads mock social data
•	cleans text
•	removes duplicates
•	formats structured inputs
Example Input
Oil prices rise by 18% amid geopolitical conflict.
Structured Output
{
  "event": "oil_price_rise",
  "sector": "energy",
  "impact": "market_volatility"
}
 
STEP 4 — News Intelligence Agent
Purpose
Understand the meaning of financial events.
Responsibilities
This agent:
•	extracts entities
•	identifies sectors
•	detects economic signals
•	identifies affected companies
Example Reasoning
Input
“Oil prices rise sharply”
Agent Understanding
•	transportation sector affected
•	energy sector may benefit
Output
{
  "affected_negative": ["transportation"],
  "affected_positive": ["energy"],
  "confidence": 0.91
}
STEP 5 — Sentiment Analysis Agent
Purpose
Analyze market sentiment from:
•	news
•	social data
•	headlines
 
Technologies
Recommended
•	VADER Sentiment
•	TextBlob
Both are free.
Responsibilities
This agent:
•	detects positive/negative sentiment
•	estimates market fear/confidence
•	generates sentiment score
Example Output
{
  "sentiment": "negative",
  "score": -0.76
}
STEP 6 — Insight Extraction Agent
Purpose
Generate actionable insights.
Responsibilities
This agent:
•	combines news + sentiment + market data
•	identifies risks
•	creates business intelligence
Example Insight
Rising oil prices combined with negative transportation sentiment may reduce logistics profitability.
 
Output
{
  "insight": "Transportation sector at elevated risk",
  "severity": "high"
}
STEP 7 — Portfolio Risk Agent
Purpose
Analyze portfolio exposure.
Responsibilities
This agent:
•	evaluates holdings
•	calculates exposure
•	estimates volatility
•	predicts losses
Example Portfolio
{
  "XYZ Logistics": 35,
  "Energy Fund": 20,
  "Tech ETF": 45
}
Example Output
{
  "risk_level": "high",
  "expected_loss": "$1800",
  "most_exposed_asset": "XYZ Logistics"
}
 
STEP 8 — Decision Agent
Purpose
Generate autonomous financial decisions.
Responsibilities
This agent:
•	evaluates risks
•	selects best actions
•	creates execution plans
Example Logic
IF oil prices rise
AND transportation exposure > 25%
THEN reduce logistics allocation
AND increase energy exposure
Example Output
{
  "actions": [
    "SELL XYZ Logistics",
    "BUY Energy Fund"
  ]
}
STEP 9 — Trade Simulation Agent
Purpose
Simulate execution of actions.
CRITICAL REQUIREMENT
This fulfills the “action execution simulation” requirement.
 
Responsibilities
This agent:
•	executes mock trades
•	updates mock database
•	recalculates portfolio
•	logs actions
Example Execution Logs
[11:01 AM] SELL order executed
Asset: XYZ Logistics
Quantity: 50

[11:02 AM] BUY order executed
Asset: Energy Fund
Quantity: 30
Database Update Example
BEFORE
{
  "XYZ Logistics": 35,
  "Energy Fund": 20
}
AFTER
{
  "XYZ Logistics": 15,
  "Energy Fund": 40
}
 
STEP 10 — Notification Agent
Purpose
Communicate results to the user.
Responsibilities
This agent:
•	sends notifications
•	generates alerts
•	creates summaries
Example Notification
Portfolio adjusted successfully.
Risk reduced from HIGH → MEDIUM.
Expected volatility reduced by 9%.
STEP 11 — Visualization Agent
Purpose
Show before vs after system state.
Responsibilities
This agent creates:
•	charts
•	timelines
•	portfolio visualizations
•	risk indicators
Visualizations
BEFORE
•	high transportation exposure
•	high risk
AFTER
•	balanced portfolio
•	lower risk
7. Mobile App Design & UI/UX
Recommended Framework
Flutter
Why:
•	fast development
•	beautiful UI
•	Android/iOS support
•	strong animations
Mobile App Workflow
SCREEN 1 — Splash Screen
Shows:
•	project branding
•	loading animation
•	AI system initialization
SCREEN 2 — Market Dashboard
Purpose
Main home screen.
Components
Top Section
•	latest financial headlines
•	market indicators
Middle Section
•	portfolio overview
•	risk score
Bottom Section
•	AI insights feed
 
UI Suggestions
Use:
•	cards
•	animated charts
•	clean dark theme
•	modern fintech design
SCREEN 3 — Live Agent Trace Screen
VERY IMPORTANT FOR JUDGES
Show:
•	agent workflow
•	reasoning chain
•	execution logs
Example Timeline
[10:00] News detected
[10:01] Sentiment analyzed
[10:02] Portfolio risk evaluated
[10:03] Decision generated
[10:04] Trade simulation executed
SCREEN 4 — Insight Details Screen
Displays:
•	extracted insight
•	confidence score
•	affected sectors
•	explanation
 
SCREEN 5 — Trade Simulation Screen
Shows:
•	executed trades
•	before/after portfolio
•	transaction history
SCREEN 6 — Analytics Screen
Displays:
•	risk reduction graphs
•	allocation charts
•	volatility trends
SCREEN 7 — Notifications Screen
Shows:
•	AI alerts
•	execution updates
•	recommendations
UI/UX Recommendations
Design Style
Use:
•	fintech-inspired interface
•	smooth animations
•	dark mode
•	glassmorphism cards
 
Important UI Principle
The app should feel:
•	autonomous
•	intelligent
•	live
•	reactive
NOT like a static dashboard.
8. Recommended Technologies
Frontend
Mobile
Flutter
Optional Web
Next.js
Backend
Recommended
FastAPI
Why:
•	fast
•	lightweight
•	excellent AI integration
Database
Recommended
Firebase Firestore
Why:
•	realtime updates
•	easy integration
•	simple authentication
 
AI & NLP
Core
Google Antigravity
Additional
Gemini API
NLP Libraries
•	spaCy
•	TextBlob
•	VADER Sentiment
Charts & Visualization
Flutter
•	fl_chart
Web
•	Recharts
•	Chart.js
9. Recommended Folder Structure
/project-root
/frontend
    /flutter_app
/backend
    /agents
        input_agent.py
        news_agent.py
        sentiment_agent.py
        insight_agent.py
        risk_agent.py
        decision_agent.py
        execution_agent.py
        notification_agent.py
    /data
        news_feed.json
        mock_social.json
        portfolio.json
    /simulation
        trade_simulator.py
    /services
        rss_service.py
        news_api_service.py
        stock_service.py
    main.py
10. Demo Flow (3–5 Minutes)
Scene 1 — Input Signals
Show:
•	market news
•	RSS headlines
•	social sentiment
Scene 2 — Agent Workflow
Show:
•	Antigravity orchestration
•	agent trace
•	reasoning chain
Scene 3 — Risk Detection
System identifies:
•	affected sectors
•	portfolio exposure
 
Scene 4 — Autonomous Decision
AI recommends:
•	reduce logistics exposure
•	buy energy assets
Scene 5 — Trade Simulation
Show:
•	trade execution
•	database updates
•	logs
Scene 6 — Final Results
Show:
•	reduced risk
•	improved allocation
•	updated dashboard
11. Key Factors That Will Impress Judges
1. Strong Agent Trace
Always display:
•	reasoning steps
•	decision logic
•	execution flow
2. Real System State Change
Must clearly show:
•	BEFORE
•	AFTER
 
3. Autonomous Reactions
System should react automatically to inputs.
4. Realistic Simulation
Trade execution must feel real:
•	logs
•	timestamps
•	notifications
•	updates
5. Professional UI/UX
Your app should resemble:
•	Bloomberg
•	TradingView
•	Robinhood
•	fintech dashboards
12. Final Recommended Architecture
News APIs + RSS + Mock Social Data
                ↓
        Google Antigravity
                ↓
     Multi-Agent Intelligence System
                ↓
 Insight + Risk + Decision Generation
                ↓
      Trade Simulation Engine
                ↓
      Portfolio State Update
                ↓
 Notifications + Visualization
