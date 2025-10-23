# Deployment

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
# or
docker-compose up --build
```

```bash
alias dcr="docker-compose build && docker-compose up"
dcr
```

# Development

Create and adjust `dev.dockerfile`.

<!-- ```bash
docker build -f dev.dockerfile -t video-demo-web:development .
```

```bash
docker run -p 3000:3000 -v $(pwd):/rails video-demo-web:development # -v development
```

Create .end.development

```bash
docker run -it --rm \
  -p 3000:3000 \
  -v $(pwd):/rails \
  --env-file .env.development \
  video-demo-web:development
``` -->

Created `docker-compose.dev.yml`

```bash
# Does both in one command:
docker-compose -f docker-compose.dev.yml up --build

###################

# Stop everything first
docker-compose -f docker-compose.dev.yml down -v

# Rebuild without cache
docker-compose -f docker-compose.dev.yml build --no-cache

# Start fresh
docker-compose -f docker-compose.dev.yml up
```
