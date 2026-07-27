{ pkgs, ...}:
{
    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users."kuta" = {
    isNormalUser = true;
    description = "kuta";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };
}
