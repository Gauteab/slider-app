# Lecture App

A WebSocket app that allows live polling from students via a slider

# Deploy
ssh onto the server: `ssh -i ~/nrec/test.pem ubuntu@158.39.201.82`

run `./start`

url: https://tinyurl.com/y56oosuj

# Development

Elm frontend, Haskell backend

## Backend

run server: `stack run`

## Frontend

start live reload: 
```bash
elm-live src/Main.elm --start-page=src/index.html -- --output=main.js
```
