# Nightguard Kali Docker Environment

This project provides a simple Docker-based Kali Linux environment for terminal-driven security and development work.

It builds a custom image from `kalilinux/kali-rolling`, installs common tools (like `nmap`, `sqlmap`, `tmux`, and `openssh-server`), and starts services with `supervisord`.

## What this project is

- A reusable Kali container setup you can start with one script.
- A headless environment intended for CLI workflows.
- A persistent workspace using the local `./root` folder mounted into container `/root`.

## Start scripts

There are two equivalent startup scripts, one per shell environment:

- `start.ps1` (PowerShell / Windows)
- `start.sh` (Bash / Linux/macOS)

Both scripts do two main things:

1. Build the Docker image:
   - `docker build -t ng-kali .`
2. Run the container in detached mode with useful options:
   - Adds network capabilities (`NET_ADMIN`, `NET_RAW`)
   - Sets timezone and user/group environment variables
   - Maps an SSH port to the host (`40022`)
   - Mounts `./root` into `/root` for persistent files
   - Enables `/dev/net/tun` device passthrough
   - Restarts automatically unless stopped
   - Requests GPU access (`--gpus all`)

## Prerequisites

Before running the start scripts, make sure you have:

- Docker installed and running
- Permission to run Docker commands on your system
- A shell matching the script you use:
  - PowerShell for `start.ps1`
  - Bash for `start.sh`
- (Optional) NVIDIA GPU + NVIDIA Container Toolkit if you want GPU support (`--gpus all`)

## Troubleshooting

- Port conflict on `40022`:
  - If container start fails or SSH is unreachable, check whether port `40022` is already used on the host.
  - Change the host-side port in the run command (for example, `-p 40023:22`).
- Container name already in use:
  - If `ng-kali` already exists, remove or rename the old container before starting again.
  - Example: `docker rm -f ng-kali`
- GPU errors (`--gpus all`):
  - If Docker reports GPU/runtime issues, verify NVIDIA drivers and NVIDIA Container Toolkit are installed.
  - If you do not need GPU access, remove `--gpus all` from the start script.
- `/dev/net/tun` issues:
  - On systems without TUN support, the device mapping may fail.
  - Enable TUN on the host or remove the `--device "/dev/net/tun:/dev/net/tun"` flag.
- Docker permission denied:
  - Run with an account that can access Docker, or use elevated privileges based on your OS setup.

## Quick usage

- On PowerShell: `./start.ps1`
- On Bash: `./start.sh`

After startup, you can interact with the running container via Docker commands (for example, `docker exec -it ng-kali bash`).

## SSH access example

- Connect from host: `ssh -p 40022 root@localhost`
- Use the host port you mapped in the start script if different from `40022`.

## Dynamic port forward (SOCKS proxy)

- Create a local SOCKS proxy on port `8888` through the container:
  - `ssh -D 8888 -N -p 40022 root@localhost`
- Configure your client/tool to use a SOCKS5 proxy at `127.0.0.1:8888`.
- Keep that SSH session running while you want proxy traffic tunneled.

## Chrome proxy quick setup (Windows + Linux)

- Start the SOCKS tunnel first (same command on both platforms):
  - `ssh -D 8080 -N -p 40022 root@localhost`
- Windows (PowerShell) Chrome launch:
  - `& 'C:\Program Files\Google\Chrome\Application\chrome.exe' --user-data-dir=./Chrome --proxy-server="socks5://127.0.0.1:8080" --proxy-bypass-list="<-loopback>"`
- Linux Chrome launch:
  - `google-chrome --user-data-dir=./Chrome --proxy-server="socks5://127.0.0.1:8080" --proxy-bypass-list="<-loopback>"`
- This uses an isolated browser profile and routes browser traffic through your SSH SOCKS proxy.
- Run these commands from this project folder for easy organization.
- Setup can still differ by system:
  - Browser binary may differ (`google-chrome`, `chromium`, `brave-browser`, etc.)
  - You may choose a different profile path or SOCKS port
  - Corporate/local policies can override proxy behavior

## Stop/Restart

- Stop the container: `docker stop ng-kali`
- Start it again: `docker start ng-kali`
- Restart it: `docker restart ng-kali`
- View logs: `docker logs -f ng-kali`
- Remove it (if needed): `docker rm -f ng-kali`
