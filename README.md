Counter-Strike 1.6 in a docker container.

has rehlds, amxmodx and metamod-r support.

for production:

docker compose up


for development:

docker compose up --watch, then when you update or add scripts in scripting folder the docker compiles and restarts the server. (don't forget to update plugins.ini in configs folder)