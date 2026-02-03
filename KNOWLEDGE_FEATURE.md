# Knowledge Base Feature - Documents as RAG for Avatar & AI Agent

## Vision
Users can upload documents (PDFs, Word, Notes, etc.) that integrate as knowledge base for the avatar and AI agent.

## Key Features
1. Document Upload (PDF, DOCX, TXT, MD)
2. Text Extraction & Processing
3. Embeddings Generation (1536 dimensions)
4. RAG Search (Vector similarity)
5. Integration with Avatar & AI Agent
6. XP Rewards for adding documents
7. Badges based on knowledge base

## Database Schema

### knowledge_documents
- id, userId, avatarId, type (strategy, product, client, personal)
- title, description, fileUrl, fileName, fileSize, fileType
- content (extracted text)
- chunks (list of chunk IDs)
- embedding (main vector)
- tags, categories
- isIntegrated (whether AI agent uses it)
- skillsAffected, xpReward
- summary, keyPoints, actionItems
- timesQueried, lastQueried
- relevanceScore
- createdAt, updatedAt

### document_chunks
- id, documentId, userId
- chunkIndex, content
- embedding (vector)
- metadata (type, fileName, chunkIndex)
- createdAt

## Firebase Cloud Functions

### knowledge_uploadDocument
- Download from Firebase Storage
- Extract text (PDF, DOCX, TXT, MD)
- Split into chunks (1000 tokens)
- Generate embeddings (OpenAI or alternative)
- Save to Firestore (documents + chunks)
- Generate AI summary with PoppyAI
- Award XP to avatar
- Return success with documentId and xpAwarded

### knowledge_queryDocuments (RAG)
- Generate query embedding
- Vector similarity search in document_chunks
- Filter by category, type
- Top 5-20 results
- Group by document
- Calculate avg similarity per document
- Update stats (timesQueried, relevanceScore)
- Return documents with context

### knowledge_deleteDocument
- Verify ownership
- Delete document from Firestore
- Delete chunks
- Delete file from Storage
- Return success with documentId

## Flutter UI Components

### DocumentsLibraryScreen
- List all uploaded documents
- Filters by type (strategy, product, client, personal)
- Search by text
- Sort by date, relevance, type
- Category tabs (marketing, sales, automation, content)

### DocumentUploadScreen
- Upload from device
- Drag & drop support
- Metadata form (type, tags, categories)
- Progress bar for upload and processing

### DocumentDetailScreen
- View document (PDF viewer, text, etc.)
- AI-generated summary
- Key points extracted
- Suggested actions
- Statistics (times queried, relevance)
- Affected skills (which skills this doc improves)
- Edit/Delete buttons
- Mark as integrated with avatar

### KnowledgeBaseScreen
- Total documents by type (chart)
- Total tokens in embeddings
- Last update date
- XP earned from documents
- Badges earned

## AI Integration

### PoppyAI Prompts

Prompt 1: Extract & Summarize
Analyze this document and give me:
1. Executive summary (2-3 paragraphs)
2. Key points (5-10 bullets)
3. Suggested actions (5-10 actionable items)

Document: [EXTRACTED_TEXT]

Context: This is for the LifeVibes avatar - a personal AI coach.

Prompt 2: Infer Skills
Based on this document content, which of the avatar skills should be improved or affected?

Available skills: marketing_strategy, content_creation, business_development, sales_techniques, product_management, client_relations, automation, leadership, negotiation

Document: [EXTRACTED_TEXT]

Return: skills array with confidence scores.

Prompt 3: Generate Questions
Based on this document, generate 10 questions the user should ask to deepen their understanding of the topic.

Document: [EXTRACTED_TEXT]

Topic: [TOPIC]

Return: questions array with topic and relevance.

## RAG Integration

### RAG Flow
1. User asks question
2. System generates query embedding
3. Search document_chunks (vector similarity)
4. Retrieve top 5-20 relevant chunks
5. Group by document
6. Calculate document-level scores
7. Return documents with context
8. AI agent generates personalized response

### Example RAG Query
User: How should I price my course?

System:
1. Generate embedding for pricing course
2. Search knowledge base
3. Returns relevant docs:
   - Business Plan 2026.pdf (similarity: 0.92)
   - Pricing Strategy Guide.pdf (similarity: 0.89)
   - Course Pricing Research.pdf (similarity: 0.85)
4. AI agent uses these docs to give personalized advice

## XP & Gamification

### XP Rewards
- Upload document: +50 XP (base)
- Large documents (>5MB): +50 XP bonus
- Strategic documents (type=strategy): +25 XP bonus
- Product documents (type=product): +25 XP bonus
- Weekly streak (1+ docs/week): +100 XP

### Badges
- first_document: First document uploaded
- knowledge_seeker: 10 documents
- scholar: 50 documents
- master: 100 documents
- expert: 200 documents
- category_expert: 20 docs in one category
- strategy_guru: 30 strategy docs
- product_master: 30 product docs

## File Types Supported

- PDF (.pdf)
- Word (.docx)
- Text (.txt)
- Markdown (.md)
- URLs (external links)

## Costs

### Storage
- Firebase Storage: /bin/bash.026/GB
- 100 documents of 1MB each = 100MB = .60/month
- 1GB of documents = 6/month

### Compute
- Text extraction: Local (free)
- Embeddings: /bin/bash.02/1M tokens (OpenAI)
- 100 documents of 10K tokens each = 1M tokens = 0/one-time
- Query search: Minimal (Firestore queries)

## Implementation Plan

### Sprint 1-2: MVP
- Firebase Storage setup
- Document upload UI
- Basic text extraction (PDF, TXT)
- Firestore schema (documents + chunks)
- Upload Cloud Function

### Sprint 3-4: Advanced Features
- DOCX extraction
- Embeddings generation
- RAG query system
- AI summary generation (PoppyAI)
- Search and filters

### Sprint 5-6: Polish
- PDF viewer integration
- Advanced filters
- XP and badges system
- Knowledge base dashboard

## Benefits

### For Users
- Personalized AI coach that knows their documents
- Fast answers with real context
- Organized knowledge base
- Gamified learning (XP, levels, badges)

### For Softvibes
- Increased engagement (users upload docs)
- Better AI responses (more personalized)
- Premium features (advanced RAG, AI summaries)
- Higher retention

---
Feature: Knowledge Base (Documents as RAG)
Created: 2026-02-03
For: Roger Garcia Vital & Team Softvibes
Methodology: Softvibes1 + RAG Integration

