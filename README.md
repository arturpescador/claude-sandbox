# Claude Sandbox

A Docker-based sandbox for running Claude Code in an isolated environment, with optional network restrictions via a Squid proxy.

## Requirements

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Mac, Windows, or Linux)
- **Windows only:** PowerShell 5.1+ (built-in) and Docker Desktop with WSL 2 backend enabled

## Repository Structure

```text
claude-sandbox/
├── docker/
│   └── Dockerfile
├── squid.conf
├── start-claude.sh       # Mac / Linux
├── start-claude.ps1      # Windows
├── start-proxy.sh        # Mac / Linux
├── start-proxy.ps1       # Windows
└── README.md
```

The scripts create the following directories on first run:

| Platform | Project files | Output | Claude config |
|----------|--------------|--------|---------------|
| Mac / Linux | `~/claude-sandbox/src` | `~/claude-sandbox/output` | `~/.config/claude` |
| Windows | `%USERPROFILE%\claude-sandbox\src` | `%USERPROFILE%\claude-sandbox\output` | `%USERPROFILE%\.config\claude` |

## Normal Mode — direct internet access

**Mac / Linux**
```bash
./start-claude.sh
```

**Windows** (PowerShell)
```powershell
.\start-claude.ps1
```

## Restricted Mode — traffic filtered through Squid

Start the proxy first, then start Claude. The proxy enforces the allowlist in `squid.conf` (only `*.anthropic.com` and `*.claude.com` are permitted by default).

**Mac / Linux**
```bash
./start-proxy.sh
./start-claude.sh
```

**Windows** (PowerShell)
```powershell
.\start-proxy.ps1
.\start-claude.ps1
```

### Windows — execution policy

If PowerShell blocks the scripts, allow local scripts for your session:
```powershell
Set-ExecutionPolicy -Scope Process -ExecutionPolicy RemoteSigned
```

## Customising the allowlist

Edit `squid.conf` to add or remove domains, then restart the proxy.
