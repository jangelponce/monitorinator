# monitorinator

## Setup

```
cd server && bundle && rails db:reset
cd client && npm install
```
By default the client is gonna connect to the server at `http://localhost:3000`, if you are accessing this app from network, add the following .env file
```
# ./client/.env.development.local
VUE_APP_SERVER_URL=http://<remote-network-ip>:3000
```

## Start up
From Running server
```
cd server && rails s -b 0.0.0.0
```
Running client
```
cd client && npm run install
```
## Components
### Server
#### Framework
Rails 7.0
#### Database
SQLite
### Client
#### Framework
Vue 3 (using options api)
#### CSS
Bulma
