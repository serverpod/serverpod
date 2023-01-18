# Contribute
Serverpod is built by the community for the community. Pull requests are very much welcome. If you are making something more significant than just a tiny bug fix, please get in touch with Serverpod's lead developer [Viktor Lidholt](https://www.linkedin.com/in/viktorlidholt/) before you get started. This makes sure that your contribution aligns with Serverpod's overall vision and roadmap and that multiple persons don't do the same work.

If you want to contribute, please view our [roadmap](https://github.com/serverpod/serverpod/projects/1) and pick issues from there. This will make it much more likely that we can include the new features you are building.

## Working on Serverpod
The main [Serverpod repository](https://github.com/serverpod/serverpod) contains all Serverpod code and code for tests and official modules and integrations. Send any pull requests to the `main` branch.

### Writing code
We are very conscious about keeping the Serverpod code base clean. When you write your code, make sure to use `dart format` and that you don't get any errors or lints from `dart analyze`.

### Running all tests
Continuous integration tests are automatically run when sending a pull request to the `main` branch. You can run the tests locally by changing your working directory into the root serverpod directory and running:

```bash
util/run_tests
```

> **Tests may not yet work if running on a Windows machine. Mac is recommended for Serverpod development.**

### Running individual tests
Running single individual tests is useful when you are working on a specific feature. To do it, you will need to manually start the test server, then run the integration tests from the `serverpod` package.

1. Add an entry for the test server at the end of your `/etc/hosts file`.
```
127.0.0.1 serverpod_test_server
```
2. Start the Docker container for the test server.
```bash
cd tests/serverpod_test_server/docker_local
docker-compose up --build --detach
./setup-tables
```
3. Start the test server.
```bash
cd tests/serverpod_test_server
dart bin/main.dart
```
4. Run an individual test
```bash
cd tests/serverpod_test_server
dart test test/connection_test.dart
```

### Command line tools
To run the `serverpod` command from your cloned repository, you will need to:

```bash
cd tools/serverpod_cli
dart pub get
dart pub global activate --source path .
```

Depending on your Dart version you may need to run the `dart pub global` command above every time you've made changes in the Serverpod tooling.


> **If you run the local version of the `serverpod` command line interface you will need to set the `SERVERPOD_HOME` environment variable. It should point to your cloned `serverpod` repository.**


### Editing the pubspec.yaml files
First off, we are restrictive about which new packages we include in the Serverpod project. So before starting to add new dependencies you should probably get in touch with the maintainers of Serverpod to clear it.

Secondly, you shouldn't edit the `pubspec.yaml` files directly. Instead, make changes to the files in the `templates/` directory. When you've made changes, run the `update_pubspecs` command to generate the `pubspec.yaml` files.

```bash
util/update_pubspecs
```

## Submitting your pull request
To keep commits clean, Serverpod squashes them when merging pull requests. Therefore, it is essential that each pull request only contains a single feature or bug fix. Keeping the pull requests smaller also makes it faster and easier to review the code.

If you are contributing new code, you will also need to provide tests for your code. The tests should be placed in the `tests/serverpod_test_server` package.

## Getting support
Feel free to post on [Serverpod's discussion board](https://github.com/serverpod/serverpod/discussions) if you have any questions. We check the board daily.
