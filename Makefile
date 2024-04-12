postgres:
	docker run -d --name postgres -p 5432:5432 -e POSTGRES_USER=root -e POSTGRES_PASSWORD=root postgres

createdb:
	docker exec -it postgres createdb --username=root --owner=root simple_bank

dropdb:
	docker exec -it postgres dropdb simple_bank

migrateup:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose up

migratedown:
	migrate -path db/migration -database "postgresql://root:root@localhost:5432/simple_bank?sslmode=disable" -verbose down

sqlc:
	sqlc generate -f db/sqlc/sqlc.yaml

mock:
	mockgen -package mockdb -destination db/mock/repository.go learning.com/golang_backend/db/sqlc/repository Repository

test:
	go test -v -cover -short ./...

server:
	go run main.go

.PHONY: postgres createdb dropdb migrateup migratedown sqlc mock test server