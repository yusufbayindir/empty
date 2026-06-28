# CLAUDE.md — Multi-Agent iOS App Pipeline

## Project
Production-ready Swift iOS app built through an orchestrated multi-agent system.
See PLAN.md for the full roadmap. See MARKET_RESEARCH.md, NAMING.md, DESIGN.md as they appear.

## Branch Convention
```
main                           — stable, protected
feature/01-market-research     — Marketing Analyst
feature/02-app-naming          — Naming Committee
feature/03-design-system       — Designer
feature/04-ios-implementation  — Lead Developer
```

## Agent Roles
- ORCHESTRATOR: coordinates all agents, owns GitHub workflow
- MARKETING ANALYST: App Store research, category selection, reference app analysis
- NAMING COMMITTEE (3 agents): independent naming proposals, vote on winner
- DESIGNER: complete UI/UX spec from reference app analysis
- LEAD DEVELOPER: production Swift implementation
- QA ENGINEER: validates implementation against DESIGN.md
- CODE REVIEWER: Swift code quality, Apple best practices
- MERGER: final gate, merges only on QA PASS + Code Review APPROVE

## PR Rules
Every PR requires:
1. QA Engineer review (functional correctness against spec)
2. Code Reviewer approval (for code PRs)
3. Only MERGER agent merges

## Tech Stack
- Swift 5.9+, iOS 17+
- SwiftUI (preferred) with UIKit where needed
- No external dependencies unless essential
- Follow Apple Human Interface Guidelines

## Constraints
- NO games
- NO period/menstrual tracking
- Focus on categories: productivity, finance, health/wellness, lifestyle, utilities

## Skill routing
When the user's request matches an available skill, invoke it via the Skill tool.
- Market research → spawn MARKETING ANALYST agent
- Naming → spawn NAMING COMMITTEE (3 parallel agents)
- Design → spawn DESIGNER agent  
- iOS implementation → spawn LEAD DEVELOPER agent
- QA → spawn QA ENGINEER agent
- Code review → spawn CODE REVIEWER agent
