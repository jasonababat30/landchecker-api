# Landchecker Property Search API

A REST API for property search, user authentication, and personal watchlists, built with Ruby on Rails and PostgreSQL for the Landchecker Senior Fullstack Coding Challenge.

## Features

- List and retrieve available properties.
- Filter properties by price, bedrooms, and property type.
- Paginate property results.
- Register and authenticate users using JWT.
- Manage personal property watchlists.
- Broadcast property changes through Action Cable.
- Validate request data and handle errors.

## Tech Stack

- Ruby on Rails API
- PostgreSQL
- BCrypt password hashing
- JWT authentication
- Action Cable
- RSpec

## Prerequisites

- Ruby and Bundler
- PostgreSQL

## Setup

Install dependencies:

```bash
bundle install
```

Configure your PostgreSQL connection and required Rails environment variables for your local environment.

Create and prepare the database:

```bash
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

Start the API server:

```bash
bin/rails server -p 4000
```

The API will be available at `http://localhost:4000`.

## API Endpoints

| Method | Endpoint | Description |
|---|---|---|
| GET | `/properties` | List available properties |
| GET | `/properties/:id` | Retrieve a property |
| POST | `/auth/register` | Register an account |
| POST | `/auth/login` | Log in and receive a JWT |
| GET | `/watchlist` | Retrieve the user's watchlist |
| POST | `/watchlist` | Add a property to the watchlist |
| DELETE | `/watchlist/:property_id` | Remove a property from the watchlist |
| WebSocket | `/cable` | Action Cable connection |

### Property Filters

The properties endpoint supports `min_price`, `max_price`, `bedrooms`, `property_type`, `page`, and `per_page`.

Authenticated endpoints require a bearer token:

```text
Authorization: Bearer <token>
```

## Running Tests

```bash
bundle exec rspec
```

## Real-Time Updates

`PropertyChannel` streams updates from the `properties` stream. Property creation and updates trigger broadcasts containing the updated property data.

The default async adapter is intended for local development. A shared adapter such as Redis is recommended for multi-process deployments.
