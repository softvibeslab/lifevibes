# LifeVibes - Digital Twin Coach App

## Project Overview

LifeVibes es una aplicacion de avatar personalizado que funciona como un clon del usuario, inspirada en Tamagotchi y The Sims. El avatar actua como un coach para mejorar vida personal y negocios.

### Core Concept
Un avatar personalizado que:
- Se cuida como un Tamagotchi (nutricion, crecimiento)
- Se personaliza como en The Sims (apariencia, habilidades)
- Se mejora como en Need for Speed (ramificaciones, upgrades)

### Metodologia: Be -> Do -> Have
- SER (Be): Introspeccion, identidad, proposito
- HACER (Do): Comunicar, ejecutar, automatizar
- TENER (Have): Resultados, monetizacion, exito

## Tech Stack

### Backend
- FastAPI (Python 3.11+) - API principal
- Supabase - Database + Auth + Storage + pgvector
- LangChain - RAG implementation
- Claude API - Coach agent principal
- GLM 4.7 - Implementacion masiva (cost-efficient)

### Frontend Web
- Next.js 14 (App Router) + shadcn/ui
- React 19 - UI interactiva
- Framer Motion - Animaciones gamificadas

### Mobile (Android + iOS)
- React Native o Expo - Cross-platform
- React Native Reanimated - Animaciones

### AI/ML
- LangGraph - Orquestacion de agentes
- pgvector - Vector store en Supabase

## MVP Features

### Sprint 1-2: Backend Core
- FastAPI structure con JWT auth
- Supabase schema setup
- RAG basico con pgvector
- Coach agent simple (Claude integration)

### Sprint 3-4: Frontend Web
- Next.js 14 + shadcn/ui setup
- Onboarding flow gamificado
- Avatar visualizacion simple
- Dashboard principal

### Sprint 5-6: AI & Automation
- Claude API integration completa
- Sistema de recomendaciones
- Identificacion de patrones
- Client management UI

### Sprint 7-8: Mobile MVP
- React Native setup
- Portar web features
- Push notifications

## Monetization

### Freemium Model
- Free: Avatar basico, 5 chats/dia, 1 meta
- Pro (/mes): Avatar ilimitado, clientes ilimitados, 50 chats/dia
- Enterprise (9/mes): API access, multiples usuarios, white-label

### Tokens System
- Comprar tokens para acciones premium
- Generar contenido con AI (posts, copys)
- Automatizaciones avanzadas

---

**Project Type**: Fullstack (Web + Mobile)
**Primary Focus**: MVP para digital presence coaching
**Target Audience**: Freelancers, solopreneurs, small businesses
