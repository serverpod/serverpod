![Serverpod banner](https://github.com/serverpod/serverpod/raw/main/misc/images/github-header.webp)

# Serverpod
[Serverpod](https://serverpod.dev) is a next-generation app and web server, built for the Flutter community. It allows you to write your server-side code in Dart, automatically generate your APIs, and hook up your database with minimal effort. Serverpod is open-source, and you can host your server anywhere.

__[Get Started](https://docs.serverpod.dev)__ - __[Join the Mailing List](https://serverpod.news)__

## Capabilities

Serverpod is a complete, competent backend for Flutter. For the glossy sales pitch, head to our main page at [Serverpod.dev](https://serverpod.dev).

Every design decision in Serverpod aims to minimize the amount of code you need to write and make it as readable as possible. Apart from being just a server, Serverpod incorporates many common tasks that are otherwise cumbersome to implement or require external services.

### Code generation
Serverpod automatically generates your model and client-side code by analyzing your server. Calling a remote endpoint is as easy as making a local method call.

### World-class logging
Stop struggling. You no longer need to search through endless server logs. Pinpoint exceptions and slow database queries in an easy-to-use user interface with a single click.

### Built-in caching
Cut down on your database costs. Don't save all your data permanently when you don't have to. Serverpod comes with a high-performance distributed cache built right in. Any serializable objects can be cached locally on your server or using Redis if you need to use the same cache across a cluster of servers.

### Easy to use ORM
Save time. Talking with your database can be a hassle. With Serverpod's ORM, your queries use native Dart types and null-safety. There is a straight path from your statically checked code to the database.

### Database migrations
Easily keep your database in sync as the requirements of your project evolve. Serverpod comes with a complete database migration system that helps you apply and version changes to the database. 

### File uploads
Upload files straight to Google Cloud Storage, S3, or store them in your database.

### Authentication
Sign in through social logins or wing your own. Currently supported are Google, Apple, Firebase, and email.

### Data streaming
Pass serialized objects through authenticated sockets. Push messages from your server for real-time communication. Sending messages across a cluster of servers is supported. Perfect for building games or chatting applications, or anything you can imagine.

### Task scheduling
Serverpod's future calls replace complicated cron jobs. Call a method anytime in the future or after a specified delay. The calls persist even if the server is restarted.

### Health checks
Monitor the database and external services that you are using. Write custom health checks and get notified when something goes wrong.

### Easy deployment
Serverpod comes with Terraform scripts for Google Cloud Platform and AWS, making deploying your server very quick. We are still working on scripts for other platforms. Please get in touch with us if you want to [contribute](/contribute).

### Built-in web server
Serverpod comes with a built-in web server. This makes it very easy to share data for applications that need both an app and traditional web pages. You can also use the webserver to create webhooks or generate custom REST APIs to communicate with 3rd party services. _The web server is still experimental, and we are actively working on it_.


## License
All Serverpod packages are licensed under BSD-3, except for the main `serverpod` package, which uses the SSPL license. In short, this means that you can, without limitation, use any of the client packages in your app. You can also host your Serverpod server without limitation as long as you do not offer Severpod as a cloud service to 3rd parties (this is typically only relevant for cloud service providers).