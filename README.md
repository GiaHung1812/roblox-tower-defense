# Roblox Tower Defense

A work-in-progress Roblox tower defense experience built with a clean client-server architecture and a source-controlled [Rojo](https://rojo.space/) workflow. Players deploy and rotate towers within designated build zones while the server orchestrates enemy waves and path traversal.

## Highlights

- Ten-wave progression with multiple enemy archetypes.
- Server-authoritative enemy spawning, movement, and lifecycle management.
- Client-side placement preview with immediate valid/invalid placement feedback.
- Tower rotation before placement using the `R` key.
- Event-driven client-server communication through `RemoteEvent`.

## Technology Stack

- [Roblox Studio](https://create.roblox.com/)
- [Luau](https://luau.org/)
- [Rojo 7.7.0](https://rojo.space/) for source synchronization
- [Rokit](https://rokit.rs/) for reproducible development tooling

## Project Structure

```text
src/
├── client/                 # Player input, placement preview, and client controllers
├── server/                 # Wave orchestration and server-side gameplay logic
│   └── Modules/            # Reusable tower and enemy modules
├── shared/                 # Shared assets and remote events
└── ui/                     # Roblox UI assets
```

The [`default.project.json`](default.project.json) file maps source folders to their Roblox services: `ReplicatedStorage`, `ServerScriptService`, `StarterPlayerScripts`, and `StarterGui`.

## Getting Started

### Prerequisites

- [Roblox Studio](https://create.roblox.com/)
- [Rokit](https://rokit.rs/), used to install the Rojo version pinned in `rokit.toml`

### Run Locally

1. Install the project tools:

   ```bash
   rokit install
   ```

2. Build the Roblox place file:

   ```bash
   rojo build -o "roblox-tower-defense.rbxlx"
   ```

3. Open `roblox-tower-defense.rbxlx` in Roblox Studio.

4. Start the Rojo development server from the repository root:

   ```bash
   rojo serve
   ```

5. Connect the Rojo Studio plugin to the displayed address, then use **Play** in Roblox Studio to test the experience.

## Roblox Studio Requirements

Some runtime content is authored in Roblox Studio rather than represented by Luau source files. The place should provide the following hierarchy before playtesting:

| Location | Required content | Purpose |
| --- | --- | --- |
| `Workspace` | `Grassland` with `Start` and numerically named `Waypoints` | Enemy spawn point and navigation route |
| `Workspace` | `Mobs`, `Towers`, and `TowerArea` | Runtime containers and valid build surfaces |
| `ServerStorage` | `Mobs` folder containing enemy models | Enemy spawn templates |
| `ReplicatedStorage.Shared` | `Towers` folder containing tower models | Tower preview and spawn templates |

Enemy and tower models must include the instances expected by gameplay code, including `Humanoid` and `HumanoidRootPart` where applicable.

## Controls

| Action | Input |
| --- | --- |
| Select a tower | Spawn button in the game UI |
| Place a tower | Left mouse button on a valid build surface |
| Rotate placement preview | `R` |

## Development Notes

- Wave configuration and sequencing: [`src/server/Main.server.luau`](src/server/Main.server.luau)
- Enemy and tower domain logic: [`src/server/Modules`](src/server/Modules)
- Client placement flow: [`src/client/GameController.client.luau`](src/client/GameController.client.luau)
- Tower-spawn event: `Shared/Events/SpawnTower`