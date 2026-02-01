# Updating

```sh
nix flake update
home-manager switch --flake .
```

# Comparing versions

```sh
nix flake update
home-manager build --flake . # Creates dry-run build
nix store diff-closures ~/.nix-profile ./result
```

# Garbage Collection

```sh
home-manager expire-generations "-1 days"
nix-store --gc
```
