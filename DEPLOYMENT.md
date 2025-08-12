# aaronOS Deployment Guide

## Railway Deployment

### Prerequisites
- Railway account
- GitHub repository connected
- PostgreSQL and Redis services added

### Environment Variables Required
Set these in your Railway dashboard:

**Core Configuration:**
- `SECRET_KEY` - Generate a random secret key
- `DEPLOY_ENV=PRODUCTION`
- `DEBUG=false`

**AI Model APIs:**
- `OPENAI_API_KEY` - Your OpenAI API key
- `ANTHROPIC_API_KEY` - Your Anthropic API key
- `GOOGLE_API_KEY` - Your Google API key
- `COHERE_API_KEY` - Your Cohere API key
- `REPLICATE_API_TOKEN` - Your Replicate API token
- `FIREWORKS_API_KEY` - Your Fireworks API key
- `OPENROUTER_API_KEY` - Your OpenRouter API key
- `PERPLEXITY_API_KEY` - Your Perplexity API key
- `MISTRAL_API_KEY` - Your Mistral API key

**Cloud Services:**
- `AWS_ACCESS_KEY_ID` - Your AWS access key
- `AWS_SECRET_ACCESS_KEY` - Your AWS secret key

**Database (Auto-configured by Railway):**
- `DATABASE_URL` - Automatically set by Railway PostgreSQL
- `REDIS_URL` - Automatically set by Railway Redis

### Deployment Steps
1. Connect your GitHub repository to Railway
2. Add PostgreSQL and Redis services
3. Configure environment variables
4. Deploy the application

### Post-Deployment
- Access your aaronOS platform at the Railway-provided URL
- Create your admin account
- Configure AI models in the admin panel

## Features
- Multi-model AI support (OpenAI, Anthropic, Google, etc.)
- Visual workflow builder
- Enterprise security
- API-first design
- Real-time collaboration

