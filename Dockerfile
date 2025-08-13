# =================================================================
# Stage 1: Base Image
# Sets up Node.js and installs pnpm globally.
# =================================================================
FROM node:18-alpine AS base
RUN npm install -g pnpm

# =================================================================
# Stage 2: Install Dependencies
# Copies only the necessary package manager files and installs dependencies.
# This layer is cached and only rebuilds if these specific files change.
# =================================================================
FROM base AS deps
WORKDIR /app
# COPY all necessary package manager configurations from the root
COPY pnpm-lock.yaml pnpm-workspace.yaml ./
COPY api/pyproject.toml ./api/
COPY web/package.json ./web/
# Install dependencies for the 'web' workspace
RUN pnpm install --filter web --legacy-peer-deps --shamefully-hoist

# =================================================================
# Stage 3: Build the Frontend
# Copies the web source code and builds the Next.js application.
# It uses the pre-installed dependencies from the 'deps' stage.
# =================================================================
FROM base AS builder
# Declare build-time arguments. These must be passed by Railway.
ARG NEXT_PUBLIC_API_URL
ARG NEXT_PUBLIC_CONSOLE_URL

WORKDIR /app
# Copy dependencies from the 'deps' stage
COPY --from=deps /app/node_modules ./node_modules
# Copy the pnpm workspace config to satisfy the build tool
COPY pnpm-workspace.yaml ./
# Copy the web application source code
COPY web ./web

# Build the web application, passing the ARGs directly to the build command.
# This injects the variables into the static files.
RUN NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL} \
    NEXT_PUBLIC_CONSOLE_URL=${NEXT_PUBLIC_CONSOLE_URL} \
    pnpm --filter web build

# =================================================================
# Stage 4: Final Production Image
# Creates a lean final image by copying only the built application
# from the 'builder' stage. It does not contain source code or build tools.
# =================================================================
FROM base AS runner
WORKDIR /app

# Set runtime environment variables. These are useful for the container
# but are NOT used by the Next.js build process.
# They are good to have for consistency if your start command needs them.
ENV NODE_ENV=production
# If you have runtime variables, you can set them here, for example:
# ENV PORT=3000

# Copy the built output from the 'builder' stage
COPY --from=builder /app/web/.next ./web/.next
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/web/public ./web/public
COPY --from=builder /app/web/package.json ./web/package.json

# Set the working directory for the start command
WORKDIR /app/web
EXPOSE 3000
CMD ["pnpm", "start"]
