return {
    cmd = { "nixd" },
    filetypes = { "nix" },
    root_markers = { "flake.nix", ".git" },
    settings = {
        nixd = {
            nixpkgs = {
                expr = "import <nixpkgs> { }",
            },
            formatting = {
                command = { "alejandra" },
            },
            options = {
                home_manager = {
                    expr = "(builtins.getFlake (builtins.toString ~/.config/home-manager)).homeConfigurations.jdm.options",
                },
            },
        },
    },
}
