# Magic Recipe - showcase for Serverpods functionality

This example accompanies the ["Serverpod Ground Training Course"](TODO) and highlights the features that serverpod ships.

## Here is a list of concepts we cover:

* Endpoints with custom models
    * Returning Streams and Futures 
    * required authentication
    * required user scopes (eg Admin access)
* Database & ORM
    * Queries & CRUD operations
* Authentication
    * Email Authentication
    * OnUserCreated hooks & scopes
* Testing
    * running Serverpod Code against a real Database
    * verifying that code can only be run with correct privileges
* File upload
    * uploading and retrieving files
* Caching
    * Storing "expensive" queries or third party calls
* Scheduling
    * Running cleanup calls
    * Setting up a repeating schedule
* Hosting
    * Building and hosting a Flutter app on Serverpod
* Admin Dashboards
    * Working with Users

## Running the app

```bash
# compile the flutter app and copy it in the server
./scripts/build_flutter_web
cd ./magic_recipe_server/ 
# Start the PostgreSQL and Redis containers
docker compose up -d
dart pub get
# TODO - do we want to ship migrations or not?
dart run bin/main.dart --apply-migrations
```

Now you can access the app at [localhost:8082](http://localhost:8082)