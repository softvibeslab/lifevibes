# ⚠️ DEPRECATED - NO USAR - ARCHIVO DE REFERENCIA HISTÓRICA

Este archivo contiene especificaciones técnicas de una versión anterior de LifeVibes
(Backend: FastAPI + Supabase + LangChain | Frontend: Next.js + React Native).

**Stack actual:** Flutter + Firebase + PoppyAI (ver TECH_SPECS_SOFTVIBES.md)

Fecha de deprecación: 2026-02-03
Razón: El equipo Softvibes (Roger, Omar, Roberto) ya domina Flutter + Firebase, por lo
que se decidió usar este stack en lugar de FastAPI + Supabase.

Este archivo se mantiene como referencia histórica por si en el futuro se considera
cambiar de stack tecnológico.

---

# LifeVibes - Especificaciones Tecnicas (DEPRECATED)

## Arquitectura del Sistema

### Frontend (Web + Mobile)
Web:
- Next.js 14 con App Router
- TypeScript para type safety
- shadcn/ui para componentes
- Framer Motion para animaciones
- Tailwind CSS para estilos

Mobile:
- React Native 0.73+
- Expo SDK 50 (opcional)
- React Native Reanimated para animaciones 60fps
- React Native Navigation
- Axios para API calls

### Backend (FastAPI)
Estructura del proyecto:
lifevibes-backend/
  app/
    api/
      v1/
        endpoints/
          auth.py        # Registro, login, JWT
          avatar.py      # Avatar management
          onboarding.py  # Onboarding flow
          knowledge.py   # RAG operations
          coach.py       # Chat con coach
          goals.py       # Metas (Be/Do/Have)
          clients.py     # CRM
          tasks.py       # Delegacion
    core/
      config.py         # Configuraciones
      security.py      # JWT, 2FA
      database.py      # SQLAlchemy setup
    models/
      user.py
      avatar.py
      knowledge.py
      goal.py
      client.py
      task.py
    services/
      rag_service.py       # LangChain RAG
      agent_service.py      # AI agents
      scraping_service.py   # Social media
      gamification_service.py
    schemas/
      Pydantic schemas
    tests/

### Database Schema (Supabase PostgreSQL)

CREATE TYPE phase_enum AS ENUM ('be', 'do', 'have');
CREATE TYPE task_status AS ENUM ('pending', 'in_progress', 'completed');
CREATE TYPE user_tier AS ENUM ('free', 'pro', 'enterprise');

CREATE TABLE users (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  email VARCHAR(255) UNIQUE NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  tier user_tier DEFAULT 'free',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE avatars (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  level INTEGER DEFAULT 1,
  xp INTEGER DEFAULT 0,
  health INTEGER DEFAULT 100,
  happiness INTEGER DEFAULT 100,
  productivity INTEGER DEFAULT 100,
  appearance JSONB DEFAULT '{}',
  skills JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE knowledge_chunks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  content TEXT NOT NULL,
  embedding VECTOR(1536),
  metadata JSONB DEFAULT '{}',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  phase phase_enum NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT,
  target_value JSONB,
  current_value JSONB,
  status task_status DEFAULT 'pending',
  due_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

CREATE TABLE clients (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  name VARCHAR(255) NOT NULL,
  company VARCHAR(255),
  industry VARCHAR(100),
  contact_info JSONB,
  ai_context TEXT,
  status VARCHAR(50) DEFAULT 'prospect',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES users(id) ON DELETE CASCADE,
  client_id UUID REFERENCES clients(id) ON DELETE CASCADE,
  title VARCHAR(255) NOT NULL,
  type VARCHAR(50), -- manual, automated, ai_suggested
  status task_status DEFAULT 'pending',
  priority VARCHAR(20) DEFAULT 'medium',
  assigned_to VARCHAR(20), -- user, ai, client
  due_date DATE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Indexes para performance
CREATE INDEX idx_knowledge_embeddings ON knowledge_chunks USING ivfflat (embedding vector_cosine_ops);
CREATE INDEX idx_goals_user_phase ON goals(user_id, phase);
CREATE INDEX idx_tasks_user_client ON tasks(user_id, client_id);

### API Endpoints

#### Autenticacion
POST /api/v1/auth/register
POST /api/v1/auth/login
POST /api/v1/auth/refresh
POST /api/v1/auth/logout
POST /api/v1/auth/verify-2fa

#### Avatar
GET /api/v1/avatar
PUT /api/v1/avatar
POST /api/v1/avatar/upgrade
POST /api/v1/avatar/equip-skill

#### Onboarding
POST /api/v1/onboarding/start
POST /api/v1/onboarding/answer
POST /api/v1/onboarding/connect-social
POST /api/v1/onboarding/scrape-profile
POST /api/v1/onboarding/complete

#### Knowledge (RAG)
POST /api/v1/knowledge/add
GET /api/v1/knowledge/search
POST /api/v1/knowledge/sync-social
DELETE /api/v1/knowledge/{id}

#### Coach AI
POST /api/v1/coach/chat
POST /api/v1/coach/recommendations
POST /api/v1/coach/identify-patterns
POST /api/v1/coach/automate-suggestion

#### Goals
GET /api/v1/goals
POST /api/v1/goals
PUT /api/v1/goals/{id}
DELETE /api/v1/goals/{id}
POST /api/v1/goals/{id}/complete

#### Clients (B2B)
GET /api/v1/clients
POST /api/v1/clients
PUT /api/v1/clients/{id}
DELETE /api/v1/clients/{id}
POST /api/v1/clients/{id}/delegate

#### Tasks
GET /api/v1/tasks
POST /api/v1/tasks
PUT /api/v1/tasks/{id}
DELETE /api/v1/tasks/{id}
POST /api/v1/tasks/{id}/complete

### AI Integration

#### LangChain RAG Setup
from langchain.embeddings import OpenAIEmbeddings
from langchain.vectorstores import SupabaseVectorStore
from langchain.chat_models import ChatAnthropic
from langchain.chains import ConversationalRetrievalChain

# Embeddings
embeddings = OpenAIEmbeddings()

# Vector Store
vectorstore = SupabaseVectorStore(
    client=supabase,
    embedding=embeddings,
    table_name=knowledge_chunks,
    query_name=match_knowledge
)

# LLMs
claude = ChatAnthropic(model=claude-3-sonnet)
glm = ChatAnthropic(model=glm-4.7, base_url=https://api.z.ai/api/anthropic)

# RAG Chain
qa_chain = ConversationalRetrievalChain.from_llm(
    llm=claude,
    retriever=vectorstore.as_retriever(search_kwargs={k: 5}),
    return_source_documents=True
)

#### Agent Orchestration (LangGraph)
from langgraph.graph import StateGraph
from langgraph.prebuilt import create_react_agent

# Agents
coach_agent = create_react_agent(claude, tools)
pattern_agent = create_react_agent(claude, pattern_tools)
marketing_agent = create_react_agent(claude, marketing_tools)

# Workflow
workflow = StateGraph(state)
workflow.add_node(coach, coach_agent)
workflow.add_node(pattern_recognition, pattern_agent)
workflow.add_node(marketing, marketing_agent)

### Social Media Scraping

#### LinkedIn
from linkedin_api import LinkedInAPI

def scrape_linkedin_profile(url):
    api = LinkedInAPI(token=LINKEDIN_TOKEN)
    profile = api.get_profile(url)
    return {
        name: profile.name,
        headline: profile.headline,
        about: profile.about,
        experience: profile.experience,
        skills: profile.skills
    }

#### X (Twitter)
import tweepy

def scrape_twitter_posts(handle, count=100):
    client = tweepy.Client(bearer_token=TWITTER_BEARER)
    tweets = client.get_users_tweets(id=user_id, max_results=count)
    return [tweet.text for tweet in tweets.data]

### Gamification Engine

class GamificationService:
    def calculate_xp(self, action_type):
        xp_rewards = {
            complete_goal: 100,
            chat_with_coach: 10,
            add_knowledge: 50,
            delegate_task: 75
        }
        return xp_rewards.get(action_type, 0)
    
    def check_level_up(self, user):
        current_level = user.avatar.level
        xp_needed = current_level * 1000
        if user.avatar.xp >= xp_needed:
            return current_level + 1
        return None
    
    def award_badge(self, user, badge_type):
        badges = user.avatar.metadata.get(badges, [])
        if badge_type not in badges:
            badges.append(badge_type)
            user.avatar.metadata[badges] = badges

## Security

### Authentication
- JWT tokens con expiracion
- Refresh tokens rotativos
- 2FA opcional (TOTP)

### Authorization
- Role-based access control
- Row-level security (RLS) en Supabase
- API rate limiting

### Data Protection
- Password hashing con bcrypt
- Encriptacion de datos sensibles
- HTTPS obligatorio
- CSP headers

## Performance Optimization

### Caching
- Redis para cache sesiones
- CDN para assets estaticos
- Cache de respuestas API

### Database
- Indexes optimizados
- Connection pooling
- Query optimization

### Frontend
- Code splitting
- Lazy loading
- Image optimization
- Service workers para PWA

## Monitoring & Logging

- Application logs (Python logging)
- Error tracking (Sentry)
- Performance monitoring (New Relic o Datadog)
- User analytics (Plausible - privacy-focused)

