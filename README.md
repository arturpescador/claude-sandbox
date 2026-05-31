# Claude Sandbox

## Repository Structure

```text
claude-sandbox/
├── docker/
│   └── Dockerfile
├── src/
├── output/
├── squid.conf
├── start-claude.sh
├── start-proxy.sh
└── README.md
```

### Normal Mode

```bash
./start-claude.sh
```

Direct internet access.

### Restricted Mode

```bash
./start-proxy.sh
./start-claude.sh
```

Traffic is routed through Squid and restricted by the allowlist in `squid.conf`.
