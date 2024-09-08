# Plymouth GIF Theme

A Nix flake that exports a plymouth theme that shows a custom GIF on your boot screen.

![A computer turning on and displaying a GIF of an exploding cat as a boot screen](./assets/demo.gif)

## How?

First add this flake as an input to your own flake.

```nix
{
  description = "My flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    plymouth-gif-theme = {
      url = "github:toodeluna/plymouth-gif-theme";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {...};
}
```

Then add the theme to your plymouth config in your `configuration.nix` file.

```nix
{ ... }@inputs:
{
  boot.plymouth = {
    enable = true;
    theme = "plymouth-gif-theme";
    themePackages = [
      inputs.plymouth-gif-theme.package.x86_64-linux.default

      # Or use override to specify a custom GIF.
      # (inputs.plymouth-gif-theme.package.x86_64-linux.override { logo = ./path/to/my/logo.gif })
    ];
  };
}
```

## Why?

Funny.
