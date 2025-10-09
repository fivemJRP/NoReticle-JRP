# NoReticle Script

**Made by JGN Development Team for JRP Server**

A highly optimized FiveM script that disables the weapon reticle/crosshair for all players, with an ACE permission bypass system using the latest FiveM natives.

## Features

- Disables weapon reticle/crosshair for all players by default
- ACE permission system to allow specific players to keep their reticle
- Easy permission management through server.cfg
- Refresh command to update permissions without restart

## Installation

1. Download and place the resource in your FiveM server's resources folder
2. Add `ensure noreticle` (or your resource name) to your `server.cfg`
3. Configure permissions in `server.cfg` (see below)
4. Restart your server

## ACE Permission Configuration

Add the following to your `server.cfg` to grant reticle bypass to specific players:

### Grant to specific player by identifier:
```
add_ace identifier.steam:110000XXXXXXXX noreticle.bypass allow
add_ace identifier.license:XXXXXXXXXXXXXXXX noreticle.bypass allow
```

### Grant to a group (e.g., admin):
```
add_ace group.admin noreticle.bypass allow
```

### Grant admin command permission:
```
add_ace group.admin command.refreshreticle allow
```

## Commands

- `/checkreticle` - Check if you have reticle bypass enabled
- `/refreshreticle` - (Admin only) Refresh permissions for all players without restart

## How It Works

1. By default, all players will have their weapon reticle disabled
2. Players with the `noreticle.bypass` ACE permission will keep their reticle
3. The script checks permissions on player connect and can be refreshed with a command

## Example server.cfg Setup

```cfg
# Add the resource
ensure noreticle

# Grant bypass to admin group
add_ace group.admin noreticle.bypass allow

# Grant bypass to specific players
add_ace identifier.steam:110000XXXXXXXX noreticle.bypass allow

# Allow admins to use refresh command
add_ace group.admin command.refreshreticle allow
```

## Support

For issues or questions, please open an issue on the repository.
