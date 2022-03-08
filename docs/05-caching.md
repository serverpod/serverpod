# Caching
Accessing the database can sometimes be expensive for complex database queries or if you need to run many different queries for a specific task. Serverpod makes it easy to cache frequently requested objects in RAM. Any serializable object can be cached. If your Serverpod is hosted across multiple servers in a cluster, objects are stored in the Redis cache.

Caches can be accessed through the `Session` object. This is an example of an endpoint method for requesting data about a user:

```dart
Future<UserData> getUserData(Session session, int userId) async {
  // Define a unique key for the UserData object
  var cacheKey = 'UserData-$userId';

  // Try to retrieve the object from the cache
  var userData = await session.caches.local.get(cacheKey) as UserData?;

  // If the object wasn't found in the cache, load it from the database and
  // save it in the cache. Make it valid for 5 minutes.
  if (userData == null) {
    userData = session.db.findById(tUserData, userId) as UserData?;
    await session.caches.local.put(cacheKey, userData!, lifetime: Duration(minutes: 5));
  }

  // Return the user data to the client
  return userData;
}
```

In total, there are three caches where you can store your objects. Two caches are local to the server handling the current session, and one is distributed across the server cluster through Redis. There are two variants for the local cache, one regular cache, and a priority cache. Place objects that are frequently accessed in the priority cache.

Depending on the type and number of objects that are cached in the global cache, you may want to specify custom caching rules in Redis. This is currently not handled automatically by Serverpod.
