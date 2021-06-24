# Är det Helgdag?!

En superenkel Svelte App som kollar om det är Helgdag än.

## Kör lokalt
```
npm run dev
```
Appen körs på `localhost:5000` (eller någon random port, om 5000 är upptagen).

## Skapa en Docker Container och kör lokalt
```
docker build -f Dockerfile_test -t ardethelgdag .
docker run -p 80:80 ardethelgdag
```
Appen körs på `localhost:80`.

## Kör på en server mha `docker-compose`
```
chmod +x init-letsencrypt.sh
sudo ./init-letsencrypt.sh
docker-compose up --build
```
`docker-compose` exponerar port 80 och port 443. Se till att trafik kan nå servern!
SSL Certifikat sätts upp automatiskt mha let's encrypt.
