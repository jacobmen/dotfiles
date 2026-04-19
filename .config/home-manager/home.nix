{
  inputs,
  config,
  pkgs,
  ...
}: {
  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jdm";
  home.homeDirectory = "/home/jdm";

  nixpkgs.config = {
    allowUnfree = true;
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.11";

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  news.display = "silent";

  # Allow system to discover fonts installed by home-manager
  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    # Dev tools
    bat
    comma
    delta
    fd
    fzf
    git
    lazygit
    rclone
    ripgrep
    ruby
    tmux
    ugit
    yazi
    zathura
    zoxide

    # Formatters
    alejandra
    stylua
    tex-fmt

    # LSPs
    lua-language-server
    nixd

    # Neovim
    neovim
    tree-sitter

    # Shell
    pure-prompt
    zsh
    zsh-autosuggestions
    zsh-fzf-tab
    zsh-syntax-highlighting

    # Latex
    biber
    texliveMedium

    # Fonts
    jetbrains-mono

    # Rust
    rustup

    # System monitoring
    btop # comprehensive
    atop # niche (irq, etc)
    iftop # network bandwidth
    iotop # disk IO
    nvtopPackages.full # GPU
    wavemon # wi-fi signal

    # Framework
    # sudo $(which framework_tool) --charge-limit [MAX] to update max charge
    framework-tool
  ];
}
