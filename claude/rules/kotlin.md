---
paths:
  - "**/*.kt"
  - "**/*.kts"
---

# Kotlin / Kotlin Multiplatform

## Architecture
- Business logic lives in `commonMain`; no platform APIs there.
- Prefer interfaces + dependency injection over `expect`/`actual`; use
  `expect`/`actual` only when there is no other way, and keep platform code
  isolated in its source set.
- Package layout and architecture (Clean / MVI / MVVM) follow the existing
  module, not a fixed template.

## Code
- Follow the official Kotlin coding conventions and the project's existing style.
- Coroutines and `Flow`/`StateFlow` for async and reactive code.
- Never swallow `CancellationException` — beware `runCatching` and broad
  `catch (e: Exception)` in suspend code.
- Errors: sealed result types (or `Result` outside suspend code); no exceptions
  for control flow.
- Prefer `val` and immutable data (`data class`, read-only collections).
- Explicit return types on public API.
- KDoc on public API: concrete about what the code does, short.
- Avoid naive nested loops over growing collections; pick data structures by
  their access pattern.

## Build and verification
- Before running a Gradle task, check that it exists in this build — `detekt`,
  `ktlintCheck`, iOS targets etc. may not be configured.
- Typical tasks: `./gradlew build`, `./gradlew allTests`,
  `./gradlew testDebugUnitTest`, `./gradlew iosSimulatorArm64Test`.
  There is no `commonTest` task; common tests run via platform test tasks.
- Tests for common code use `kotlin.test`.
- No `TODO` in production code without an issue reference.
