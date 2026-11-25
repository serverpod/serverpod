# Jaspr inside Serverpod

## What you would see

You have a Serverpod project with a web package next to the server. You type
`serverpod start`. The server comes up, and so does the website. You open
`http://localhost:8082/site`. The Serverpod server rendered that page, in
the process that answers your API calls, with the same `Session` your
endpoints get. A counter on the page is a Jaspr `@client` component, so it
runs in the browser too. Click it and it counts up.

Edit a server-rendered part of the page and save. Half a second later that
part is new, and the counter still shows the number you clicked it to.
Edit the component's `build` method and save. Three seconds later the page
shows the change, and the counter still has its number. Set a breakpoint
in the component from your IDE, and it hits.

Change something hot reload cannot apply, such as the fields of a const
class, and the page reloads itself. Add a new `@client` component, and
Jaspr's generator runs, the browser code is rebuilt, and the new component
is interactive.

When you ship, there is one server executable. It renders the pages, serves
the compiled JavaScript and answers the API, from one process on one port.

That is what we propose to build, in two steps. In the first, Jaspr's own
tooling compiles the browser code and talks to the browser, and Serverpod
renders the pages. In the second, `serverpod start` compiles the browser
code itself, and the three seconds become half a second. The second step
is optional.

This is the second design for the integration. The first,
[jaspr_integration.md](jaspr_integration.md), runs `jaspr serve` as a child
process. Its [feasibility assessment](jaspr_integration_feasibility.md) and
its [requests for Jaspr](jaspr_upstream_requests.md) are where the facts in
the last sections come from.

## Where the rendering runs

Jaspr is a web framework in the Flutter mould. You write components, Jaspr
renders them to HTML on a server, and the same components compiled to
JavaScript take over in the browser. Taking over is called hydration. The
server wrote `<span>Count: 0</span>` into the page, and the browser code
found that span, attached itself, and started counting.

Jaspr is also its own server. `jaspr serve` compiles the browser code with
build_runner, starts a Dart process that renders pages with shelf, watches
your files, and refreshes the browser when they change. None of it knows
about Serverpod.

So where should the rendering run in a Serverpod project? The first
instinct is to leave Jaspr alone. `serverpod start` launches `jaspr serve`
as a child and forwards browser requests to it. That works until a page
needs the signed-in user. Then the Jaspr server has to call the Serverpod
server over HTTP, as a client, to learn what the Serverpod server already
knew when the request came in.

The other way is to bring the rendering inside. Jaspr's rendering core is a
function that takes a URL, a base path and some headers and returns HTML.
Put it behind a Serverpod route and the page renders in the server isolate,
where the route already has the `Session`.

Jaspr's maintainer, Kilian Schulte, reviewed the first design and asked for
the second. In his words, the whole point of the integration is that the
Serverpod process does the server-side rendering as part of its routing, so
pages have the session. He also pointed at the mode Jaspr has for it.
`jaspr daemon --skip-server` runs only Jaspr's client workflow and leaves
the server to someone else. This design is built on that mode.

```text
serverpod start (the runner)
+-- file watcher          server, client package, and each Jaspr app's lib/ and web/
+-- code generation       serverpod generate
+-- server compiler       frontend_server, target vm, hot reloads the server
+-- jaspr daemon          one per app: Jaspr's generator, build_runner, DDC, DWDS
+-- the server process
    +-- API endpoints
    +-- JasprRoute at /site
        +-- page requests     rendered in-process, with the Session
        +-- file requests     forwarded to the daemon, or the app's built files
        +-- $serverpodInstance  tells a page when the process was replaced
```

The browser talks to two ports. Pages and files come from the server. The
connection that carries hot reloads goes straight to the daemon, as it does
in Jaspr's own setup.

## What you write

Three packages, as in any Serverpod project with a frontend, except the
frontend is a Jaspr package:

```text
my_project/
+-- my_project_server/
+-- my_project_client/
+-- my_project_web/
    +-- lib/
    |   +-- app.dart
    |   +-- components/counter.dart
    |   +-- main.client.dart
    |   +-- main.server.dart
    +-- web/styles.css
    +-- pubspec.yaml
```

The web package is an ordinary Jaspr package in server mode, the kind
`jaspr create` writes. It depends on `jaspr`, and for development on
`build_runner`, `build_web_compilers`, `jaspr_builder` and `jaspr_cli`. The
last one lets the runner start Jaspr's daemon with `dart run`, at a version
pinned per project. `main.client.dart` is the browser entrypoint.
`main.server.dart` still works with `jaspr serve`, but the Serverpod server
never calls it. The server imports the app's root component and the
options Jaspr's generator writes next to the entrypoint.

The server names the app in its `pubspec.yaml`, where Flutter apps are
named too:

```yaml
serverpod:
  jaspr_apps:
    website:
      path: ../my_project_web
```

The key is the app's identifier and `path` is its package, relative to the
server. Only `serverpod start` reads this. It says which package to run the
daemon in and which files to watch, not where the app is served. That is a
route, in `server.dart`:

```dart
import 'package:my_project_web/app.dart';
import 'package:my_project_web/main.server.options.dart';
import 'package:serverpod_jaspr/serverpod_jaspr.dart';

void run(List<String> args) async {
  final pod = Serverpod(args);

  pod.webServer.addRoute(
    JasprRoute(
      'website',
      build: (session, request) => App(
        greeting: 'Rendered by Serverpod at ${DateTime.now()}',
      ),
      options: () => defaultServerOptions,
    ),
    '/site',
  );

  await pod.start();
}
```

`JasprRoute` comes from a new package, `serverpod_jaspr`. Its first argument
is the identifier from `jaspr_apps`. `build` makes the root component for
one page request and gets the request's `Session`, so it can query the
database before anything is rendered. `options` returns the server options
Jaspr's generator wrote. It is a function rather than a value, for a reason
the section on server reloads gives.

The route is mounted at `/site` here. It could as well be at `/`. The app's
`Document` takes its base from `context.binding.basePath`, so its links and
its script tag resolve below the mount. That is all a developer writes.

## A page request

A request for `/site/about?tab=team` reaches the `JasprRoute`, whose path
is `/**` below its mount. The route looks at the last segment after the
mount, here `about`. If that segment has an extension other than `html`,
`htm` or `xml`, the request is for a file. Jaspr's own server uses the same
rule, so an app behaves the same under both. Otherwise it is a page.

For a page the route asks Serverpod for the `Session`, calls `build`, and
hands Jaspr the component and a description of the request:

```dart
final rendered = await jaspr.renderRequest(
  component,
  (
    url: '/about?tab=team',
    basePath: '/site/',
    headers: _StoreHeaders(request.headers),
  ),
  options: _options(),
  loadFile: _loadFile,
);
```

The description is a record Jaspr calls `RequestLike`. Its `url` is
relative to the mount, so Jaspr's router sees `/about`, as it would if the
app ran alone at the root. Its `basePath` is the mount, and it is what
`context.binding.basePath` returns. The route works both out from the
request. The segments it did not consume belong to the app, and what came
before them is the mount.

The `headers` give Jaspr its cookies and its reload header, and give
components the rest through `context.headers`. They are a view over relic's
`HeaderStore`, not a copy. Relic is the HTTP library under Serverpod's web
server. The view goes through a two-member interface Jaspr owns,
`HeadersLike`, so neither package depends on the other. Jaspr builds a
`RequestLike` only for a shelf request. Every other host builds its own.
The `options` are passed per call rather than set once for the process, so
two apps in one server would not fight over them. `loadFile` reads
`Document.template` files from the app's files.

`renderRequest` does not exist in Jaspr today. What exists is
`renderComponent`, which takes a shelf `Request`, and Serverpod's web server
is not built on shelf. It is one of the changes we ask Jaspr for.

The result is a record too, `ResponseLike`: status code, headers and body.
The route turns it into a Serverpod `Response` without copying either. The
body bytes are wrapped as they are, and the headers become a `HeaderStore`
view over Jaspr's map. The content type is read from that view for the body
and left out of the headers.

## A file request

A request such as `/site/main.client.dart.js` or `/site/styles.css` is for
a file. Where the file comes from depends on whether the server runs under
`serverpod start`.

In production it comes from a directory. A build script, shown under
production below, compiles the browser code with `dart compile js` and
copies it and the app's `web/` files into `web/website` in the server
package. The route serves that directory. A miss is a 404, not a rendered
page.

Under `serverpod start` the file comes from the daemon. The route forwards
the request to `http://localhost:<port>/main.client.dart.js`, with the
mount stripped and the Host header naming the daemon. Jaspr's own server
forwards file requests the same way.

The Host header matters. Inside the daemon runs DWDS, the Dart web debug
service, the same component Flutter uses for web debugging. DWDS rewrites
the bootstrap script on its way to the browser and writes into it the
address the page should open its debug connection to, taken from the host
it was asked for. Because the daemon sees itself as the host, the page
connects straight to the daemon. The server never sees the debug traffic.

The route reads template files through the daemon in the same way. While
the daemon is still starting, the route answers 503 with a retry hint, and
the browser tries again by itself.

The route knows there is a daemon from `JASPR_PROXY_PORT`, which the runner
sets on the server process. That is the variable Jaspr's own server reads,
so Jaspr's code that reaches for the daemon works unchanged. No variable
means production, and that includes `serverpod start --no-watch`.

## The daemon

`jaspr daemon` is `jaspr serve` for tools. Jaspr added it in CLI 0.18.2 for
its VS Code extension. It is hidden from `jaspr help`, prints JSON events
instead of a log, and takes commands on stdin. With `--skip-server` it runs
only the client workflow and prints that the server has to be started by
hand with the daemon's port in `JASPR_PROXY_PORT`. The runner starts one
per app, in the app's package:

```text
dart run jaspr_cli:jaspr daemon --skip-server --no-launch-in-chrome
    --proxy-port 5567 --auto=reload
```

The daemon starts build_runner's daemon on the `web` target. Jaspr's
generator and build_web_compilers run in the same build, the latter
compiling the browser code with DDC, the Dart dev compiler, in the library
bundle format that hot reload needs. The build daemon watches the files and
rebuilds by itself.

It serves the build output on the proxy port, behind DWDS. DWDS talks to
the page through a small client it injected into the bootstrap, over a
connection the page opens to the daemon. That is enough for hot reload and
for calling into the page. Breakpoints need a Chrome that DWDS can reach
over Chrome's debug protocol, and the daemon restarts DWDS in that mode
when someone asks Jaspr to launch Chrome.

After each successful build it hot reloads every connected page: new code
into the running program, then Jaspr's reassemble, then Jaspr's HTML
reload, then changed stylesheets. Each is a service extension Jaspr's
client registers, and DWDS lets the daemon call them.

It takes a message from the server and tells the pages to reload their
HTML. Jaspr's `ServerApp.reloadClients` sends that message, and the route
calls it after every server reload. And it reports progress, logs and the
browser's VM service URI as events on stdout.

The runner relays those events into its own output, so a build error in
the web package shows up where the server's errors do. It passes the
browser's VM service URI through the same proxy it passes the pod's, so an
IDE can attach to the page next to the server. And it supervises the
process tree, because the daemon spawns build_runner's daemon and perhaps
a Chrome, and neither should outlive `serverpod start`.

Two things stood in the way when we tried this, both in the CLI. Since
October 16, 2026 the CLI picks its proxy port itself and only prints it, so
`--proxy-port` above is a flag we restore. And a page below a mount, or on
another port, could not find the modules a hot reload should load, because
the daemon named them with paths from its own root. Both are small pull
requests against Jaspr's CLI, listed with the other asks. With them, the
daemon and this route worked end to end on a demo.

## An edit sets two things going

The runner watches each Jaspr app's `lib/` and `web/` next to the server's
sources, because the server imports the app. The daemon watches the same
files. So a save starts two things, and nothing orders them:

```text
save
 |
 +-------------------------------+
 v                               v
serverpod generate               the daemon rebuilds
compile the server               hot reload the pages, or
reload the server isolate        reload them when it cannot
 |
 v
Jaspr asks the daemon to reload the pages' HTML
```

The server side is Serverpod's ordinary hot reload. When it is done, relic
replays the route's registration, Jaspr clears the caches it built from the
old code, and the route asks Jaspr to have the pages reload their HTML.
That reload fetches the page with a header that makes the server render
only the body, and swaps the new body into the live page. Client state
survives, because Jaspr's client keeps its components across the swap.

The browser side is the daemon's. One edit, with times from a run on the
demo: you change the counter's label and save at 0.0 s. The build daemon
builds for 2.7 s, recompiling one module. DWDS tells the page, the page
loads the module into its running program, Jaspr rebuilds the component
tree, and the page fetches its HTML again. At 3.1 s the counter reads
`Clicks: 3`, with the three it had counted to.

A change DDC cannot hot reload, such as a const class losing a field, is a
build error in the daemon: "Hot reload rejected due to unsupported changes.
Try performing a hot restart instead". The daemon does not restart the page
on its own. In our runs the page reloaded fully within two seconds anyway,
and we have not traced which side of DWDS did that.

Because the two sides are not coordinated, a page can briefly run new
browser code against old markup, or the reverse. Each side ends with a
fetch of the page, so the page converges, and in our runs it always did.
The fast path orders the two.

## When the server itself reloads

When Serverpod hot reloads the server isolate, its web server replays every
route's `injectIn`. The Jaspr route uses that moment to call
`ServerApp.reassemble`, so Jaspr clears caches built from the old code,
such as `jaspr_content`'s, and then has the pages reload their HTML. This is
why the route's `options` is a function. The generated options are a
getter, and after a reload the getter returns the options for the new code.

A restart is different. When the VM rejects a hot reload, the server
process is replaced, and nothing tells the open pages. So the route adds a
small script to every development page. Once a second it fetches
`$serverpodInstance` below the mount, a random number the process chose
when it started, and reloads the page when the number changes. A failed
fetch means the server is between processes, and the script tries again
sooner.

Serverpod's web server injects a refresh script of its own into every HTML
response. The Jaspr route opts out of it, through a new
`Request.skipDevAutoRefresh`, because a full reload would throw away the
client state Jaspr's reload keeps.

## Production

Production has no runner, no daemon and no compiler. It has a server
executable and a directory of files. A script in the server's
`pubspec.yaml`, next to where the Flutter template keeps `flutter_build`,
compiles the browser code with `dart compile js`:

```yaml
serverpod:
  scripts:
    jaspr_build:
      posix: |
        set -e
        cd ../my_project_web
        rm -rf build/web && mkdir -p build/web
        dart compile js -O2 -Djaspr.flags.release=true \
          -o build/web/main.client.dart.js lib/main.client.dart
        rm -rf ../my_project_server/web/website && mkdir -p ../my_project_server/web/website
        cp -R web/. ../my_project_server/web/website/
        cp build/web/*.js ../my_project_server/web/website/
```

`serverpod run jaspr_build` runs it, and the template's Dockerfile already
copies `web/` into the image. The server is built as the template builds
it, with `dart build cli`, and the Jaspr app compiles into it. `jaspr build`
is not needed. It would also build Jaspr's own server executable, which
nothing here runs.

One thing has to change in Jaspr for this. Jaspr decides release mode from
a compile-time define that `jaspr build` sets, and `dart build cli` cannot
set one, so a server built that way renders in debug mode. Jaspr should
also treat `dart.vm.product`, which every ahead-of-time build sets, as
release mode. Its `kDebugMode` documentation already says so.

## The fast path

Everything so far is the first step, and it ships on its own. In the
second, `serverpod start` compiles the browser code itself and the daemon
is not started.

The reason is the loop. Through the daemon, the edit above took 3.1 s to
show, and 12 s when it landed while the daemon was already building. The
same edit on the fast path, from a run: you save. The runner recompiles
the server in 15 ms, since frontend_server only recompiles the changed
library, and 80 ms after that compile started the server isolate has
reloaded. In parallel a second frontend_server recompiles the browser code.
10 ms after the reload the runner tells the open pages to hot reload, and
half a second after the save the counter reads `Clicks: 3`. That is the
figure Flutter developers expect.

### The browser code

`serverpod start` keeps a frontend_server process resident to compile the
server incrementally. frontend_server is the Dart SDK's compiler front
end. With `--target=dartdevc` it emits JavaScript in the format DDC uses
for debug builds, incrementally, library by library. The runner starts a
second frontend_server per Jaspr app with that target and the flags
build_web_compilers' own driver uses, on the entrypoint
`package:my_project_web/main.client.dart`. It takes the compiler from the
SDK it resolved for the server, so a project pinned to a Flutter SDK
compiles both sides with the same compiler. The vendored frontend_server
client needs three additions: a `package:` entrypoint, extra arguments,
and the `recompile-restart` request explained below.

frontend_server writes all modules' JavaScript into one file, with source
maps and metadata in two more and a manifest of byte offsets. The runner
splits them into one file per module, such as
`packages/my_project_web/components/counter.dart.lib.js`, as flutter_tools
does for Flutter web. The bootstrap scripts are adapted from flutter_tools'
too, with two differences. Every URL resolves against the directory the
entry script came from, so the app works below a mount. And the list of
modules is part of the main module, so no debug service has to supply it.

Two runtime files do not depend on the app. The module loader and the stack
trace mapper are copied from the SDK. `dart_sdk.js`, the SDK compiled to
JavaScript, is not shipped and takes about four seconds to compile, so the
runner compiles it once per SDK version into
`.dart_tool/serverpod/web_sdk/<version>`. After the first compile the
output directory holds:

```text
.dart_tool/serverpod/jaspr/website/
+-- main.client.dart.js          the entry script the page loads
+-- main_module.bootstrap.js     the module list and the call to main
+-- reloaded_sources.json        what a hot reload should load
+-- dart_sdk.js, ddc_module_loader.js, dart_stack_trace_mapper.js, ...
+-- packages/<package>/...       one .lib.js and .map per library
```

The route forwards file requests to the runner's asset server instead of
the daemon's, with the runner as the host, for the reason given under file
requests. The runner runs Jaspr's generator and compiles the browser code
before it compiles the server, because the generated options are an input
of the server compile, and so that the first page can hydrate.

### The edit, in order

A change in `web/` is a static file change, and the pages reload. A change
in `lib/` goes through this cycle:

```text
save
 |
 v
code generation       serverpod generate, then Jaspr's generator if needed
 |
 +------------------------------+
 v                              v
compile the server              compile the browser code
reload the server isolate       (hot reload, or a restart)
 |                              |
 +------------------------------+
 |
 v
tell the open pages what to do
```

The two compiles run at the same time, and the pages are told only after
both have finished and the server has reloaded. If the browser reloaded
first and fetched a fresh page, the server would still run the old code,
and new client code would meet old markup. The pages are told one of three
things.

**Hot reload.** frontend_server accepted the change as a hot reload. The
page loads the new code into its running Dart program, rebuilds its
component tree, and fetches its own page again to pick up server-rendered
changes. Client state survives.

**Restart.** frontend_server rejected the change, or the generated client
options changed, or a static file did. The runner recompiles with
`recompile-restart`, which skips the checks a hot reload needs, and the page
reloads itself. State is lost.

**Nothing on the browser side.** Only the server changed. The page still
fetches itself again, and client state survives.

Two failures need care. If the browser compile fails, the pages are told
nothing and keep the old code. The compiler must remember the failed
libraries and invalidate them again next time, because a rejected compile
rolls frontend_server back to the code before it, and a later edit to some
other file would otherwise compile against the broken library's last good
version. If the server compile fails, the browser update waits, the
strongest one pending, until a cycle compiles the server. Otherwise new
browser code would hydrate against stale markup.

### The browser's side

The runner hosts DWDS, as the daemon did, so the page's side of an edit is
the same code in both steps and Jaspr's client needs nothing new. DWDS
already has a load strategy for frontend_server's library bundle output,
the one flutter_tools uses, so flutter_tools is the template. The runner
gives DWDS an asset reader over its output, a package config mapper, a
digest provider, the entrypoint and the URL of `reloaded_sources.json`,
and marks its bootstrap with the two comments DWDS's injector looks for.

The page's debug connection goes to the runner's port, and the runner
drives the page through the VM service DWDS synthesizes from it:
`reloadSources` for a hot reload, a service call for a restart, and
Jaspr's three extensions for the rest. That is what Jaspr's CLI does, and
its client manager, a few hundred lines over the VM service, is the piece
to copy. The same VM service goes to the IDE through the runner's proxy,
next to the pod's, with `reloadSources` intercepted to run the compile
first, as the pod's is. Breakpoints come when the developer asks for
Chrome, as in the daemon. Expression evaluation needs one more request in
the vendored frontend_server client.

DWDS fetches the list of reloaded sources on every hot reload and knows
nothing of a page two reloads behind. The runner therefore serves the
latest file of each module changed since the last restart, each under a
query with its generation so the browser does not take a cached one. An
up-to-date page reloads modules it already has, which is wasted work but
correct. Every output goes through a temporary file and a rename, so a
reader never sees half a file.

One hole is left, and the restart script closes it. A page that loads
while the runner is between writing new browser code and reloading the
server gets markup from one generation and code from the next, and Jaspr's
hydration stops on a marker its options do not know. The runner therefore
reports each app's generation when it asks the server to reload the pages,
the server writes it into every page it renders from then on, and the
script compares it once with the generation the loaded code recorded.

### Code generation

Jaspr's generator reads `@client` and a few other annotations and writes
the client and server options files, which list the components and how to
load each in the browser. Without them a new `@client` component does not
hydrate.

The daemon runs the generator inside its build. The fast path runs only the
generator, through `build_runner daemon`. The build daemon keeps the
compiled build script, the asset graph and the analyzer warm, and in manual
mode it builds only when asked and reports what it wrote. The runner starts
one per app with `lib` as the build target.

A daemon build costs a few seconds even when nothing needs generating, and
most edits are to method bodies, which the generator does not read. So the
runner parses each changed file, without resolving it, and keeps the parts
the generator reads: imports, annotated classes with their constructor
parameters and fields, annotated members, and annotated top-level
declarations. Call that the file's shape. The generator runs only when a
shape changed, and a file that fails to parse counts as changed. Fields are
in the shape because a `this.x` parameter takes its type from the field,
and the generator writes a decoder for that type.

The build daemon reports every file a build step wrote, changed or not, so
the runner compares each reported output with the content it last saw and
compiles only the changed ones. It also remembers them, because the watcher
is about to report those writes, and drops an event for a generated file
whose content is what the runner just compiled.

The build daemon's first start compiles build_runner's build script ahead
of time, which takes most of a minute. Later starts took seven seconds on a
package with only Jaspr's builders and eleven with build_web_compilers
added. When the script does change, after an edit to the web package's
`pubspec.yaml` for instance, the daemon exits by itself. The runner has to
notice, because a build it asked for then never completes, and start it
again.

One bug stands in the way of both steps. On a package with committed
generated files and no asset graph yet, the build daemon's first build
fails with `Source my_project_web|lib/main.server.options.dart clashes
with declared output in buildStepPlan`. The daemon reports every file on
disk as added before its first build, and build_runner's plan for a build
made from file changes keeps those files as sources, including the ones a
builder is about to generate. The `build` command strips them. The fix is a
few lines in build_runner's `BuildPlan`, and it has to go upstream before
this ships. Jaspr's CLI drives the daemon the same way and hits the same
bug on build_runner 2.16 after a clean of `.dart_tool`.

## What has to change in Jaspr

Jaspr's `next` branch, where the 0.24 work happened, was merged into `main`
for the 0.24 beta in October 2026, so `main` is the branch to target. Each
ask below is small, each is its own pull request, and each is a decision
for Jaspr's maintainer.

| Ask | Why |
|---|---|
| Throw a `StateError` when Jaspr is not initialized, instead of calling `exit(-1)` | A server that embeds Jaspr must not go down with it. |
| Treat `dart.vm.product` builds as release mode | See production. |
| `ServerApp.reassemble()`, with reloading the clients optional | A host that reloads code itself can tell Jaspr. |
| `HeadersLike`, a two-member interface Jaspr owns, in place of shelf's private headers type | A host implements it over its own headers without copying. |
| `renderRequest`, rendering a `RequestLike` the host builds, with per-call options | The route's entry point, and `RequestLike` exported for it. |
| `--proxy-port` on `jaspr serve` and `jaspr daemon` | A tool that starts the daemon has to know the port before it starts the server. |
| Reloaded sources named by their URL on the proxy | A page below a mount, or from another port, finds them. |

The headers interface deserves a word, because the first instinct is the
other way round. Serverpod has `relic_headers`, a small package with a
`HeaderStore`, and Jaspr could depend on it. That makes Jaspr depend on a
Serverpod package, which its maintainer may not want and should not need.
`HeadersLike` turns it around. Jaspr owns two members, `names` and
`valuesOf`. Its shelf path and its tests use a map-backed implementation,
and `serverpod_jaspr` adapts relic's store to it. Jaspr depends on nothing
of ours, and it never builds one of these itself except for a shelf
request. The host does, and the interface says what the host's
implementation must hold so a render in another isolate can take it along.

The daemon step cannot do without the two CLI asks. The port flag existed
until October 16, 2026 and was removed when the CLI started to pick free
ports itself. The second is two lines. The list of reloaded sources and the
modules it names carry their URL on the proxy's port, and the list allows
cross-origin reads. Jaspr's own setup is unaffected, since its page and its
proxy are on the same machine anyway.

Three more would make the daemon step better and are not asked for yet: a
way to launch Chrome at the host's URL rather than Jaspr's, so breakpoints
work without opening a second tab, an exit when the daemon's parent goes
away, and the daemon's protocol as a documented contract. The fast path
asks for nothing beyond the table.

The maintainer's `jaspr_serverpod` package, which gives components a
`context.session`, is a natural home for the route. Whether it should live
there is his call.

## The case against

Everything above is the case for. Here is the case against, and parts of it
are right.

**Serverpod takes on Jaspr's tooling as a dependency.** The daemon is a
hidden command with a protocol made for one editor extension, and its
behaviour moved twice in October 2026. The runner supervises a process it
does not control and relays logs it does not format.

**The fast path takes on a web toolchain.** A DDC bootstrap adapted from
flutter_tools, a frontend_server driver, DWDS with its own release cadence,
and a build_runner wrapper, all tracking SDK internals with no stability
promise. That is a second team's maintenance load, for one web framework.
It is optional, and the daemon step is complete without it.

**The failure matrix is large.** Server compile, browser compile, code
generation, the daemon and the open pages each fail in their own ways, and
the ways combine. A prototype of the fast path, reviewed once, had a hang,
two paths that compiled stale code and a hydration race. The sections above
describe what closes each of them. Nobody should believe that list is
complete.

**It cannot ship on its own.** It needs seven changes in Jaspr and one in
build_runner, and each is a maintainer's decision. This is the argument
that matters.

**Developers lose things they have today.** `jaspr serve` opens Chrome with
the debugger attached. Here breakpoints need Chrome launched through the
tool, or the Dart debug extension in the developer's own browser. The app
compiles into the server, so an edit the VM rejects restarts the API server
and drops every open websocket, and a component that loops holds the
isolate that serves endpoints. A change to the web package's build script
costs tens of seconds of daemon restart.

**Two things watch the same files.** In the daemon step the runner and the
daemon each react to an edit, and nothing orders them. The page converges
because both sides end with a fetch of it. The demo showed that. Nothing
proves it.

**The daemon is the weak link.** A known upstream bug, a cold start that
dwarfs everything else, and in the fast path a shape heuristic that has to
track what jaspr_builder reads by hand. The real fix is Jaspr exposing its
generators without build_runner, so `serverpod generate` runs them next to
its own. That is the largest ask of Jaspr, and this design does not make
it.

**Memory.** Each Jaspr app keeps a daemon, with build_runner and DWDS,
resident next to the server's own frontend_server. The fast path trades the
daemon for a second frontend_server and a build daemon of its own.

## What we measured

Both steps ran on October 27, 2026 on macOS, Dart 3.13.7, with headless
Chrome driving a demo project through the real `serverpod start`. The demo
had one `@client` component and one server-rendered paragraph, so these are
floor numbers, and the implementation proposed here has to match them. The
daemon column is from `jaspr daemon --skip-server` on Jaspr's main of
October 23 with the two CLI changes applied. The fast path column is from a
throwaway prototype of the resident compiler. The daemon ran on a web
package with build_web_compilers as a dev dependency, which it needs. The
fast path ran without it, which it does not.

| Step | Daemon | Fast path |
|---|---|---|
| `dart_sdk.js`, once per SDK version | in the build | 3.7 s |
| First start, compiling build_runner's build script | 74 s | 48 s |
| Later starts, to browser code ready | 13 to 20 s | 10 s |
| Page load to an interactive `@client` component | 1.4 to 2.5 s | 1.7 to 1.9 s |
| Server-rendered edit, saved to visible, client state kept | 0.43 to 0.52 s | 0.52 s |
| `@client` component edit, saved to visible, hot reload, state kept | 3.1 s | 0.46 to 0.52 s |
| The same, saved while the daemon was building another change | 12 s | |
| Edit that hot reload rejects, saved to page reloaded | 1.6 s | 1.7 s |
| New `@client` component, saved to interactive, including the generator | | 3.5 to 3.9 s |
| The generator alone, through the build daemon | | 2.3 s |
| Production page load to interactive, dart2js, measured on Dart 3.13.4 | 0.16 s | 0.16 s |

The daemon's 74 s is 41 s compiling build_runner's build script, 5 s
starting the build daemon, and 21 s for the first build. `jaspr serve` on
its own starts cold in the same 74 s.

## Why not a subprocess

The first design ran `jaspr serve` as a child, Jaspr server and all, and
proxied every browser request to it. Its assessment, in
[jaspr_integration_feasibility.md](jaspr_integration_feasibility.md), found
eight gaps in Jaspr's CLI, measured against the 0.23.5 release of
September 25, 2026. The daemon step is a subprocess too. What changed?

Three of the eight do not apply, because there is no Jaspr server: its VM
service port, its orphaned process, and the proxy in front of every page
request. Two were fixed by Jaspr's hot reload work, merged on October 13:
the daemon no longer crashes when a browser connects without a launched
Chrome, and it no longer waits for a Chrome it never launches. One is the
port flag, asked for above. Two remain in milder form: a crashed supervisor
leaves build_runner's daemon running, and Chrome opens at Jaspr's idea of
the URL. The mount prefix gap does not come back, because the page's debug
connection and its reloaded sources carry the daemon's own address.

And the subprocess could not give pages the `Session`. This one does.

## What we will build, in order

Each step is usable before the next:

1. The Jaspr asks, as pull requests against `main`, and the build_runner
   fix upstream.
2. `serverpod_jaspr` with `JasprRoute`, serving pages and files, with the
   production layout and the forwarder to a daemon.
3. The runner starts the daemon per app, relays its events, passes on the
   browser's VM service, and supervises the process tree.
4. The fast path: the resident compiler, DWDS in the runner, generations
   and the ordered edit cycle, as an option a project turns on.
5. Breakpoints through a Chrome the tool launches.

Out of scope, and not claimed:

- Jaspr's static and client rendering modes. Only server mode.
- Two Jaspr apps in one server. The options are per call, and the runner
  starts one daemon per app, but Jaspr's `JASPR_PROXY_PORT` names one port,
  so a second app needs a variable of our own.
- Windows and Linux. Nothing here is platform-specific, but the
  measurements are from macOS.
- The generator inside `serverpod generate`.

`serverpod_jaspr` builds only against a Jaspr that has the asks above, so
it cannot ship or build in CI until Jaspr publishes them. Until then it
lives behind a path override, and its pubspec says so.

The page renders in the Serverpod process, with the session. Jaspr's own
daemon does the rest, and the runner only starts it, watches it and passes
its events on. The fast path is for the day three seconds per edit is too
long.
