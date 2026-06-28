# Multi-Agent iOS App Development Pipeline

## Objective
Build a production-ready Swift iOS app through a fully orchestrated multi-agent pipeline.
- Market research → naming → design → implementation → QA → code review → ship
- Every step tracked on GitHub with branches, PRs, reviews, and merges
- App name TBD (decided by naming committee for best App Store discoverability)

## Constraints
- No games
- No period/menstrual tracking apps
- Swift native iOS app only (SwiftUI preferred, iOS 17+)
- Production-ready: complete UI, all states, real logic, onboarding, error handling

## Current Status
- [x] Phase 0: Infrastructure setup
- [ ] Phase 1: Market Research (branch: feature/01-market-research)
- [ ] Phase 2: App Naming (branch: feature/02-app-naming)
- [ ] Phase 3: Design System (branch: feature/03-design-system)
- [ ] Phase 4: iOS Implementation (branch: feature/04-ios-implementation)
- [ ] Phase 5: App Store Metadata

## Phase Details

### Phase 1: Market Research
**Agent**: Marketing Analyst
**Branch**: feature/01-market-research
**Goal**: Identify the single best iOS app opportunity (non-game, non-period-tracker)
**Method**: 
- Analyze App Store trending categories (2025-2026)
- Score: market size, saturation level, build complexity, monetization potential
- Select winner category
- Find top 3 apps in category, analyze what makes them successful
**Output**: MARKET_RESEARCH.md
**Gate**: QA reviews research quality → merge to main

### Phase 2: App Naming
**Agents**: 3 independent naming agents
**Branch**: feature/02-app-naming
**Goal**: Best possible name for App Store discoverability + brand appeal
**Method**: Each agent independently proposes name + subtitle + keyword strategy
**Output**: NAMING.md with winner + rationale
**Gate**: QA reviews → merge to main

### Phase 3: Design System
**Agent**: Designer
**Branch**: feature/03-design-system
**Goal**: Complete, implementable design spec
**Method**: Study top 3 reference apps, create full design system
**Output**: DESIGN.md (color palette, typography, components, all screens, all states)
**Gate**: QA reviews completeness → merge to main

### Phase 4: iOS Implementation
**Agent**: Lead Developer
**Branch**: feature/04-ios-implementation
**Goal**: Production-ready Xcode project
**Method**: Implement DESIGN.md exactly, handle all edge cases
**Output**: Complete Swift/SwiftUI app
**Gate**: QA PASS + Code Review APPROVE → Merger merges

### Phase 5: App Store Metadata
**Agent**: Marketing Analyst
**Branch**: feature/05-appstore-metadata
**Output**: APPSTORE.md (description, keywords, screenshots plan)
