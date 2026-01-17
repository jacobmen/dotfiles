# Setup

```sh
systemctl --user daemon-reload
systemctl --user enable service-file
systemctl --user start service-file
```

# Monitoring

```sh
# Status
systemctl --user status service-name # exclude .service

# Logs
journalctl -u service-name
```
