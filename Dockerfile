FROM arm64v8/node:20.8-alpine AS build

RUN apk add --no-cache curl bash

WORKDIR /usr/src/app

# Copy only the package files
COPY package*.json ./

RUN npm install

# Copy all files
COPY . .

FROM arm64v8/node:20.8-alpine AS production

ENV NODE_ENV production
USER node

WORKDIR /usr/src/app

COPY --chown=node:node --from=build /usr/src/app/package*.json ./
COPY --chown=node:node --from=build /usr/src/app/next.config.js .

COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/.next ./.next

# Expose port
EXPOSE 3000

# Run app
CMD ["npm", "start"]