# Use the official image as a base
FROM langgenius/dify-web:latest

# Set the arguments that will receive the environment variables from Railway
ARG NEXT_PUBLIC_API_URL
ARG NEXT_PUBLIC_CONSOLE_URL

# Set the environment variables inside the image
ENV NEXT_PUBLIC_API_URL=${NEXT_PUBLIC_API_URL}
ENV NEXT_PUBLIC_CONSOLE_URL=${NEXT_PUBLIC_CONSOLE_URL}
