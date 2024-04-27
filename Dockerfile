FROM node:18.13 as angular

WORKDIR /app

COPY . .

RUN npm ci
RUN npm run build 

FROM nginx:latest
WORKDIR /usr/share/nginx/html

COPY --from=angular /app/dist/flex/browser ./
