.PHONY: run stop help db-create db-migrate db-shell db-console db-show migrate-reset

# Start Docker containers in the background
run:
	docker compose up -d
	@echo "Application running at http://localhost:8000"

# Start Docker container in the background withouth the database
run-php-only:
	docker-compose up -d php
	@echo "Symfony app (without DB) running at http://localhost:8000"

# Start the database only
run-db-only:
	docker-compose up -d db
	@echo "Database is running"

# Stop and remove Docker containers
stop:
	docker compose down
	@echo "Application stopped and containers removed"

# Show list of all available commands
help:
	@echo "Available commands:"
	@echo "  run             - Start Docker containers"
	@echo "  stop            - Stop and remove Docker containers"
	@echo "  db-create       - Create the database"
	@echo "  db-migrate      - Run all migrations (create tables)"
	@echo "  db-shell        - Open the MariaDB shell (command line)"
	@echo "  db-console      - Open Symfony console (run Symfony commands)"
	@echo "  db-show         - Show all rows from the 'person' table"
	@echo "  migrate-reset   - Drop, recreate and run migrations again"
	@echo "  help            - Show this help message"

# Create the database using Doctrine (only structure, no tables yet)
db-create:
	docker exec -it symfony_php php bin/console doctrine:database:create

# Run all database migrations (creates tables)
db-migrate:
	docker exec -it symfony_php php bin/console doctrine:migrations:migrate --no-interaction

# Open MariaDB command line to work with the database manually
db-shell:
	docker exec -it symfony_db mariadb -u symfony -psymfony symfony_app

# Open Symfony console to run internal Symfony commands
db-console:
	docker exec -it symfony_php php bin/console

# Show all rows from 'person' table using SQL SELECT
db-show:
	docker exec -i symfony_db mariadb -u symfony -psymfony symfony_app -e "SELECT * FROM person;"

# Drop the database, create it again, and run migrations
migrate-reset:
	docker exec -it symfony_php php bin/console doctrine:database:drop --force
	docker exec -it symfony_php php bin/console doctrine:database:create
	docker exec -it symfony_php php bin/console doctrine:migrations:migrate --no-interaction
	@echo "Database has been reset and all migrations applied."
