# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
# Development
bin/dev                    # Start development server
bin/rails console          # Rails REPL

# Database
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed

# Testing
bin/rails test             # Full test suite
bin/rails test test/models/user_test.rb  # Single test file

# Linting & Security
bin/rubocop                # Ruby style (Rails Omakase)
bin/brakeman               # Security scan

# Background jobs
bin/jobs                   # Run Solid Queue worker

# Deployment
bin/kamal                  # Docker-based deploy
```

## Architecture

Rails 8.0 API-only app for music streaming backed by Yandex Cloud Object Storage (S3-compatible).

**Request flow:**
1. Client authenticates via Devise Token Auth (`/api/auth/`)
2. Authenticated requests hit `/api/aws/` endpoints
3. Controllers call `YandexCloudService` to sync metadata from Yandex Cloud into PostgreSQL
4. Tracks are served as JSON; cloud URLs point directly to Yandex Cloud Storage

**Models:**
- `User` — authenticated via Devise Token Auth; owns tracks and playlists
- `Track` — music metadata (`name`, `artist`, `cloud_url`, `artwork`, `genres[]`)
- `Playlist` — named collection; a special auto-created playlist "Понравившееся" holds liked tracks
- `PlaylistTrack` — join table for playlist ↔ track

**Key routes (`config/routes.rb`):**
```
/api/auth                          # Devise Token Auth (register, sign_in, sign_out)
/api/aws/tracks                    # CRUD + sync, top_tracks, liked, like_track
/api/aws/playlists                 # CRUD + fetch_from_yandex_cloud
```

**Services:** `app/services/yandex_cloud_service.rb` wraps the AWS SDK S3 client pointed at `storage.yandexcloud.net`.

**Infrastructure:** PostgreSQL for data + Solid Queue (jobs) + Solid Cache + Solid Cable (all DB-backed). Deployed via Kamal with Docker; Thruster handles HTTP asset compression in front of Puma.

**Auth tokens:** Bearer tokens via Devise Token Auth; 2-week lifespan; `access-token`, `client`, `uid` headers required on authenticated requests.
