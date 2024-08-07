return {
   -- ref: https://wezfurlong.org/wezterm/config/lua/SshDomain.html
   ssh_domains = {},

   -- ref: https://wezfurlong.org/wezterm/multiplexing.html#unix-domains
   unix_domains = {},

   -- ref: https://wezfurlong.org/wezterm/config/lua/WslDomain.html
   wsl_domains = {
      {
         name = 'Arch',
         distribution = 'Arch',
         username = 'hw770',
      },
      {
         name = 'WSL:Ubuntu',
         distribution = 'Ubuntu',
         username = 'hw770',
         default_cwd = '/home/hw770',
         default_prog = { 'fish', '-l' },
      },
   },

   default_domain = 'Arch',
}
