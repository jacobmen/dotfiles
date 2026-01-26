# Updating

```sh
nix flake update
home-manager switch --flake .
```

# Garbage Collection

```sh
home-manager expire-generations "-1 days"
nix-store --gc
```
