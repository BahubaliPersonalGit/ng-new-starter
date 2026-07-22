
#build stage
FROM node:20-alpine AS build
LABEL author="Bahubali"

WORKDIR /app

COPY package.json package-lock.json ./
RUN npm ci

#Copy source and build
COPY . .
ARG CONFIGURATION=staging
RUN npm run build -- --configuration $CONFIGURATION


FROM nginx:1.27-alpine AS runtime


COPY --from=build /app/dist/ng-new-starter/browser /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]