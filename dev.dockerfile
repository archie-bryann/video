# syntax=docker/dockerfile:1
# check=error=true

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t video .
# docker run -d -p 80:80 -e RAILS_MASTER_KEY=<value from config/master.key> --name video video

# For a containerized dev environment, see Dev Containers: https://guides.rubyonrails.org/getting_started_with_devcontainer.html

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.4.5
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Rails app lives here
WORKDIR /rails

# Install base packages
# Added more packages here for deployment
# removed for development
# RUN apt-get update -qq && \
#     apt-get install --no-install-recommends -y curl libjemalloc2 libvips bash bash-completion libffi-dev tzdata postgresql nodejs npm postgresql-client && \ 
#     npm install -g yarn && \
#     ln -s /usr/lib/$(uname -m)-linux-gnu/libjemalloc.so.2 /usr/local/lib/libjemalloc.so && \
#     rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set development environment variables and enable jemalloc for reduced memory usage and latency.
ENV RAILS_ENV="development" \
    # BUNDLE_DEPLOYMENT="1" \
    # BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" 
    #\
    #LD_PRELOAD="/usr/local/lib/libjemalloc.so"

# Throw-away build stage to reduce size of final image
# removed for development
# FROM base AS build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libyaml-dev pkg-config && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Install application gems
COPY Gemfile Gemfile.lock vendor ./

RUN bundle install 
# removed for development
# && \
#     rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
#     # -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
#     bundle exec bootsnap precompile -j 1 --gemfile

# Copy application code
COPY . .

# Make scripts executable
RUN chmod +x bin/* 

# Precompile bootsnap code for faster boot times.
# -j 1 disable parallel compilation to avoid a QEMU bug: https://github.com/rails/bootsnap/issues/495
RUN bundle exec bootsnap precompile -j 1 app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# removed for development
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile




# Final stage for app image
FROM base

# Run and own only the runtime files as a non-root user for security
# removed for development
# RUN groupadd --system --gid 1000 rails && \
#     useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash
# USER 1000:1000

# Copy built artifacts: gems, application
# removed for development
# COPY --chown=rails:rails --from=build "${BUNDLE_PATH}" "${BUNDLE_PATH}"
# COPY --chown=rails:rails --from=build /rails /rails

# Make entrypoint executable
RUN chmod +x /rails/bin/docker-entrypoint

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-dev-entrypoint"]

# Start server via Thruster by default, this can be overwritten at runtime
EXPOSE 80
CMD ["./bin/thrust", "./bin/rails", "server", "-b", "0.0.0.0"] 
# added  "-b", "0.0.0.0"  for development