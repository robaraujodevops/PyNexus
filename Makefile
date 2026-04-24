up:
	docker compose up -d
down:
	docker compose down
logs:
	docker compose logs -f
migrate:
	docker run --rm --network host pynexus_api alembic upgrade head
