# LifeVibes - Digital Twin Coach App

## Context
Esta aplicacion es un avatar personalizado que funciona como coach para mejorar vida personal y negocios, inspirado en Tamagotchi y The Sims.

## Metodologia Principal
Be -> Do -> Have
- SER (Be): Introspeccion, identidad, proposito
- HACER (Do): Comunicar, ejecutar, automatizar  
- TENER (Have): Resultados, monetizacion, exito

## Tech Stack
- Backend: FastAPI + Supabase + LangChain
- Frontend Web: Next.js 14 + shadcn/ui
- Mobile: React Native
- AI: Claude API + GLM 4.7

## Development Priorities
1. MVP: Backend Core (FastAPI, Supabase, RAG)
2. Frontend Web: Onboarding, Dashboard, Avatar
3. AI Integration: Coach agent, Recommendations
4. Mobile: React Native port

## Key Features to Implement
- Onboarding gamificado con scraping de redes sociales
- Avatar system con stats, XP, ramificaciones
- RAG engine para conocimiento del usuario
- Coach agent conversacional
- Client management (B2B feature)

## Code Quality Standards
- TRUST 5 framework
- Test coverage >= 85%
- Type hints required
- Linter compliance (ruff, eslint)

## Project Structure
lifevibes/
- backend/ - FastAPI application
- frontend/ - Next.js web app
- mobile/ - React Native app
- docs/ - Documentation

## When Creating Features
1. Use /moai plan to create SPEC
2. Implement with DDD (Analyze -> Preserve -> Improve)
3. Test thoroughly
4. Sync documentation with /moai sync
