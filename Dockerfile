# =================================================================
# Stage 1: Base Image with PNPM
# This stage creates a clean environment with Node.js and pnpm installed.
# =================================================================
FROM node:18-alpine AS base
RUN npm install -g pnpm

# =================================================================
# Stage 2: Install Dependencies
# This stage copies only the package files and installs all dependencies.
# This is efficient because it only re-runs if the package files change.
# =================================================================
FROM base AS deps
WORKDIR /app
COPY pnpm-lock.yaml .
COPY pnpm-workspace.yaml .
COPY api/pyproject.toml ./api/
COPY web/package.json ./web/
RUN pnpm install --filter web --legacy-peer-deps --shamefully-hoist

# =================================================================
# Stage 3: Build the Frontend
# This stage copies the source code and builds the frontend application.
# It uses the dependencies from the previous stage.
# =================================================================
FROM base AS builder
WORKDIR /app
COPY --from=deps /app/node_modules ./node_modules
COPY web ./web
# Pass the public URLs as build-time arguments
ARG NEXT_PUBLIC_API_URL
ARG NEXT_PUBLIC_CONSOLE_URL
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}
ENV NEXT_PUBLIC_CONSOLE_URL=${NEXT_PUBLIC_CONSOLE_URL}
RUN pnpm --filter web build

# =================================================================
# Stage 4: Final Production Image
# This stage takes the built frontend and serves it.
# =================================================================
FROM base AS runner
WORKDIR /app
COPY --from=builder /app/web ./web
# Set the working directory for the start command
WORKDIR /app/web
EXPOSE 3000
CMD ["pnpm", "start"]
