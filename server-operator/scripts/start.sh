# apply game env file
# apply map env file
# actually jk, set these in kube?

# Game specific setup script
./${GAME_NAME}/setup.sh

# Game specific setup script
./${GAME_NAME}/start_server.sh

# Start the server-operator here
./start_server_operator.sh