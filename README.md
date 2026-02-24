# Purple Explorer - cross-platform Azure Service Bus explorer (Windows, macOS, Linux)

Purple Explorer is a cross-platform desktop application built with .NET 8.  
This repository is a fork of the original [PurpleExplorer](https://github.com/telstrapurple/PurpleExplorer) project,
which appears to be no longer maintained. This fork attempts to continue development, albeit at a slow pace.

It's a simple tool to help you:

* Connect to Azure Service Bus
* View topics and subscriptions
* View queues
* View active and dead-letter messages
* View message body and its details
* Send a new message
* Save messages to send them quickly
* Delete a message **^**
* Purge active or dead-letter messages
* Re-submit a message from dead-letter
* Dead-letter a message **^**

**\^ NOTE:** These marked actions require receiving all the messages up to the selected message and this increases DeliveryCount. Be aware that there can be consequences to other messages in the subscription.

## How to run

### With Nix (recommended)

A Nix flake is provided for reproducible builds. You need [Nix](https://nixos.org/download/) with flakes enabled.

```sh
# Run directly without installing
nix run github:philipmat/PurpleExplorer

# Or, after cloning:
nix run

# Build only (output symlinked to ./result)
nix build

# Enter a development shell with the .NET 8 SDK available
nix develop
```

> [!NOTE]
> The flake includes a `Directory.Build.targets` file that suppresses an Avalonia telemetry MSBuild task
> (`AvaloniaStats`) which attempts to write to a path that is read-only in sandboxed build environments.
> This has no effect on the built application.

> [!NOTE]
> If you update NuGet dependencies, regenerate `deps.json` before committing:
> ```sh
> nix build .#purpleExplorer.passthru.fetch-deps && ./result deps.json
> ```

### Without Nix

You need to have [.NET 8](https://dotnet.microsoft.com/en-us/download/dotnet/8.0) or later installed.

To build and run the project:

1. Clone the repository.
2. Navigate to the root of the repo.
3. Run `dotnet run --project PurpleExplorer/PurpleExplorer.csproj` to run the application;  
   or after building with `dotnet build`,
   run `dotnet run PurpleExplorer/bin/Debug/net8.0/PurpleExplorer.dll`.

## Recent Changes

Since forking from the original project, the following significant updates have been made:

* Enhanced UI:
  * resizable panels and grids;
  * filtering for the tree view;
  * improved message details window with DLQ reason display and application properties;
  * added spinner to indicate background operations.
* Improved connection management and user experience (taller connection box, alerts for existing connections, etc.).
* Upgraded to .NET 8 for better performance and latest features.
* Upgraded to latest Avalonia (v11) for improved UI framework capabilities.
* Migrated to Azure.Messaging.ServiceBus for the latest Azure SDK.
* Upgraded all dependencies to their latest versions.
* Implemented comprehensive nullability fixes and code quality improvements
* (editorconfig, better naming).
* Added key bindings and buttons for closing windows.
* Fixed various bugs including null reference exceptions, timeout issues, and app state handling.
* Added a Nix-flake-based build

For a full list of changes, see the git commit history.
