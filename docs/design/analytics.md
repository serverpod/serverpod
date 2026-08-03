# CLI feature analytics

Serverpod CLI analytics help the Serverpod team understand how developers use
the framework throughout a project's lifecycle. The feature is intended to
guide product decisions with aggregate trends while protecting the privacy of
individual developers and their projects.

CLI analytics complement basic command-usage reporting. They describe what
kinds of projects developers build, which Serverpod capabilities they adopt,
and how their development workflows evolve.

## Questions the feature should answer

The collected information should make it possible to answer questions such as:

- Which project configurations and Serverpod capabilities are commonly adopted?
- How deeply are individual capabilities used within active projects?
- Which capabilities tend to be used together?
- How does adoption change as projects mature and across Serverpod releases?
- How often do projects generate code, create migrations, or upgrade?
- Which development-session configurations and Flutter targets are configured?
- Which Flutter targets are actually launched?
- Where do generation attempts fail or become unusually slow?

These questions should be answerable at an aggregate project level. Repeated
activity from one busy checkout must not make a capability appear more widely
adopted than it is.

## Lifecycle coverage

Analytics cover the following meaningful lifecycle activities:

- creating a project;
- upgrading an existing project;
- generating code, including one-shot and watched generation;
- creating regular and repair migrations;
- starting a development session; and
- launching a companion Flutter application.

Equivalent ways of performing the same activity should have equivalent
analytics behavior. For example, an action initiated from a command, an
interactive interface, or an automation tool should contribute to the same
product signal when its user-visible outcome is the same.

Events that represent a completed outcome are reported only when that outcome
occurs. Failed generation attempts are still relevant because generation
reliability is one of the questions the feature is intended to answer.
Repeated or unchanged work should not create misleading activity.

Analytics are best-effort and must never delay, fail, or change the result of a
CLI operation.

## Measurement semantics

Feature adoption and feature usage are different measurements:

- **Adoption** indicates whether a project uses a capability.
- **Usage depth** indicates how many times a countable capability occurs within
  that project.

Project-size measurements provide context for usage depth, such as the number
of models, endpoints, relations, indexes, migrations, or modules. Configuration
capabilities that do not have a meaningful occurrence count remain
presence-only.

Analytics distinguish:

- a logical project from an individual checkout;
- configured intent from observed use;
- one-shot generation from incremental generation; and
- successful outcomes from failed attempts where failure is itself a useful
  product signal.

Each Serverpod server is treated as a separate logical project, including when
multiple servers live in the same repository.

Adoption views should count each active logical project once, using its most
recent relevant state. Usage-depth views should likewise use a representative
project state rather than summing every generation run. Activity counters and
timings are trend signals, not an accounting or billing system.

## Privacy and user control

Analytics are enabled according to the CLI's analytics preference and can be
disabled with the global `--no-analytics` option.

The feature must not collect user-generated or project-identifying content,
including:

- file-system paths, repository URLs, or package and project names;
- endpoint, model, field, migration, module, or device names;
- source code, generated code, SQL, logs, or command output;
- secrets or configuration values; or
- raw command arguments that may contain user content.

Reported data is limited to anonymous identifiers, booleans, numbers, and
coarse categories drawn from controlled vocabularies. Categories describe
Serverpod capabilities rather than user-chosen names.

A logical project may be represented by a stable anonymous identity so that
activity from multiple checkouts can be aggregated. Individual checkouts may
also be distinguished anonymously when needed to understand development
behavior. Neither identity may expose or be derived into a reversible project
or developer identifier.

## Intended use

The primary consumer is the Serverpod product and engineering team. The data is
used to:

- prioritize capabilities and documentation;
- understand whether features progress from experimentation to sustained use;
- identify common feature combinations and project shapes;
- evaluate adoption across project-age and release cohorts; and
- find generation reliability or performance areas worth investigating.

The data must be interpreted as aggregate directional evidence. It is not
intended to identify individual developers or projects, audit exact command
history, diagnose the contents of a specific project, or provide operational
telemetry for a running Serverpod application.

## Feature requirements

The feature is complete when:

- all lifecycle activities in scope produce consistent analytics regardless of
  how the activity was initiated;
- opt-out prevents analytics from being reported;
- analytics failures are invisible to normal CLI behavior;
- capability reporting uses stable, documented meanings;
- adoption and usage depth can be analyzed without overcounting active
  checkouts;
- generation health can be analyzed separately for one-shot and incremental
  workflows; and
- no prohibited user-generated or identifying content is reported.

The feature specification intentionally does not define event names, payload
schemas, storage formats, code locations, analytics providers, delivery
mechanisms, or test structure. Those choices may evolve without changing the
product behavior described here.
