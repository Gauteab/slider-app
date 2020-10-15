
git pull
export ADDR="0.0.0.0"
export PORT="9160"

# Start frontend
cd frontend
elm-live src/Main.elm \
	--no-reload \
	--port=8000 \
    --host="0.0.0.0" \
	--start-page=src/index.html \
	-- --output=public/main.js &

# Start backend
cd ../backend
stack run
