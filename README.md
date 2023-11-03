Acme API
===================

Rails API application.

Developed by: `Jonathan Cabas Candama`

# Requirements

* Ruby 3.2.2
* Rails 7.1.1
* Postgres
* Redis 5.0.8

# Setting up Database

Run the following to setup rails db

```sh
  $ rails db:setup
  $ rails db:migrate
  $ rails db:seed
```

# Getting Started

The following services need to be up and running.

```sh
  $ rails s -p 5001 (Runs rails server on port 5001)
  $ redis-server & (Runs redis as a backgroung process)
```

# Testing

The testing framework used is `RSpec`

Run the following command to run the test suite:

``
  $ rspec spec
``

# Endpoints Documentation

### API response below threshold

```sh

    GET http://localhost:5001/tests
    Headers: 'user-id:{user_id}'

    Response status: 200 OK
    Response body:
    {
      "success": "This is fine!"
    }
```

### API response above threshold

```sh

    GET http://localhost:5001/tests
    Headers: 'user-id:{user_id}'

    Response status: 200 OK
    Response body:
    {
      "error": "over quota"
    }
```
