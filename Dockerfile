FROM node:18-slim

WORKDIR /app

# Clone the repository
RUN apt-get update && apt-get install -y git
RUN git clone https://github.com/haraldini/Figma-Context-MCP.git .

# Install pnpm
RUN npm install -g pnpm

# Install dependencies
RUN pnpm install

# Build the application
RUN pnpm build

# Create a patch to modify the server binding
RUN echo 'diff --git a/dist/server.js b/dist/server.js\n--- a/dist/server.js\n+++ b/dist/server.js\n@@ -1,1 +1,1 @@\napp.listen(port, "0.0.0.0", () => {' > patch.diff

# Apply the patch after build
RUN sed -i 's/app.listen(port,/app.listen(port, "0.0.0.0",/' dist/server.js

EXPOSE 3333

CMD ["pnpm", "start:http"] 