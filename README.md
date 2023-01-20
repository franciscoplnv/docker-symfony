# Base: https://github.com/codenip-tech/symfony-base-repository

# Symfony Base Repository

This repository contains the basic configuration to run Symfony applications with MySQL database

## Content
- PHP container running version 8.1.13
- MariaDB container running version 10.9.4


## Installation:
- Run `make build` to create all containers 
- Run `make start` to spin up containers
- Enter the PHP container with `make ssh-be`
- Install your favourite Symfony version with `composer create-project symfony/skeleton project [version (e.g. 5.2.*)]`
- Move the content to the root folder with `mv project/* . && mv project/.env .`. This is necessary since Composer won't install the project if the folder already contains data.
- Copy the content from `project/.gitignore` and paste it in the root's folder `.gitignore`
- Remove `project` folder (not needed anymore)
- Navigate to `localhost:1000` so you can see the Symfony welcome page :)

## Instructions
- `make build` to build the containers
- `make start` to start the containers
- `make stop` to stop the containers
- `make restart` to restart the containers
- `make prepare` to install dependencies with composer (once the project has been created)
- `make run` to start a web server listening on port 1000 (8000 in the container)
- `make logs` to see application logs
- `make ssh-be` to SSH into the application container