# Install

## hyprland and neovim dependencies

    - sudo pacman -S git kitty ripgrep fd fzf

## install programming languages

    - sudo pacman -S python nodejs npm yarn php composer go

## fixing permissions for global npm packages

    - mkdir "${HOME}/.npm-global"
    - npm config set prefix "${HOME}/.npm-global"
    - .zshrc should have this path already set

## install global npm packages

    - npm install -g intelephense neovim esbuild @johnnymorganz/stylua-bin vue-language-server typescript-language-server typescript bun

## install hypr\* and hyprpanel dependencies

    - sudo pacman -S --needed wireplumber libgtop bluez bluez-utils btop networkmanager dart-sass wl-clipboard brightnessctl swww python upower pacman-contrib power-profiles-daemon gvfs
    - yay -S --needed aylurs-gtk-shell-git grimblast-git gpu-screen-recorder-git hyprpicker matugen-bin python-gpustat hyprsunset-git hypridle-git

## install hyprland

    - sudo pacman -S hyprland hyprpaper hyprlock
    - yay -S hyprpicker-git

## install tools

    - yay -S lazygit-git
    - sudo pacman -S ghostty

## install docker

    - sudo pacman -S docker
