```bash
rails new video --main --database=postgresql
```

```bash
RAILS_ENV=production
POSTGRES_HOST=db
POSTGRES_DB=videodb_production
POSTGRES_USER=dean
POSTGRES_PASSWORD=password123
RAILS_MASTER_KEY=169a416e80ae5efd52345b0e2fb6dced
```

```bash
docker-compose build
```

```bash
docker-compose up
```

```bash
rails g scaffold post title body:text
```

```rb
# routes.rb
root "posts#index"
```

```bash
docker-compose build && docker-compose up
```

```bash
alias dcr="docker-compose build && docker-compose up"
dcr
```
