#!/usr/bin/perl

# obmenu-generator - schema file

=for comment

    item:      add an item inside the menu               {item => ["command", "label", "icon"]},
    cat:       add a category inside the menu             {cat => ["name", "label", "icon"]},
    sep:       horizontal line separator                  {sep => undef}, {sep => "label"},
    pipe:      a pipe menu entry                         {pipe => ["command", "label", "icon"]},
    file:      include the content of an XML file        {file => "/path/to/file.xml"},
    raw:       any XML data supported by Openbox          {raw => q(...)},
    beg:       begin of a category                        {beg => ["name", "icon"]},
    end:       end of a category                          {end => undef},
    obgenmenu: generic menu settings                {obgenmenu => ["label", "icon"]},
    exit:      default "Exit" action                     {exit => ["label", "icon"]},

=cut


# NOTE:
#    * Keys and values are case sensitive. Keep all keys lowercase.
#    * ICON can be a either a direct path to an icon or a valid icon name
#    * Category names are case insensitive. (X-XFCE and x_xfce are equivalent)

require "$ENV{HOME}/.config/obmenu-generator/config.pl";

## Text editor
my $editor = $CONFIG->{editor};
my $syslang = "$ENV{LANG}";
my $lang = substr($syslang, 0, 2);

# Distro -------------------------------------------------------------------
sub mk_distro {
    return `~/bin/distro-info -2`;
}

my $def_browser = `/usr/bin/xdg-mime query default application/x-extension-html`;
my $brcmd = `dex -d /usr/share/applications/$def_browser`;
$brcmd = (split ': ', $brcmd)[1];

my $def_fileman = `/usr/bin/xdg-mime query default inode/directory`;
my $fileman = `/usr/bin/dex -d /usr/share/applications/$def_fileman`;
$fileman = (split ': ', $fileman)[1];

if ($lang eq "pt") {
our $SCHEMA = [
    #          COMMAND                 LABEL              ICON
    {sep => mk_distro },

    {item => ["$fileman .",       'Arquivos', 'system-file-manager']},
    {item => ['x-terminal-emulator',            'Terminal',     'utilities-terminal']},
    {item => ["$brcmd", 'Web Browser',  'web-browser']},
    {item => ['gmrun',            'Executar comando',  'system-run']},

    {sep       => undef},

    #          NAME            LABEL                ICON
    {cat => ['utility',     'Acessórios', 'applications-utilities']},
    {cat => ['development', 'Desenvolvimento', 'applications-development']},
    {cat => ['education',   'Educação',   'applications-science']},
    {cat => ['game',        'Jogos',       'applications-games']},
    {cat => ['graphics',    'Gráficos',    'applications-graphics']},
    {cat => ['audiovideo',  'Multimídia',  'applications-multimedia']},
    {cat => ['network',     'Rede',     'applications-internet']},
    {cat => ['office',      'Escritório',      'applications-office']},
    {cat => ['other',       'Outros',       'applications-other']},
    {cat => ['settings',    'Preferências',    'preferences-desktop']},
    {cat => ['system',      'Sistema',      'applications-system']},

    #                  LABEL          ICON
    #{beg => ['My category',  'cat-icon']},
    #          ... some items ...
    #{end => undef},

    #            COMMAND     LABEL        ICON
    ## Generic advanced settings
    #{sep       => undef},
    #{obgenmenu => ['Openbox Settings', 'applications-engineering']},
    #{sep       => undef},

    ## Custom advanced settings
    {sep       => undef},
    {beg => ['Preferências Avançadas', 'applications-system']},

      # Configuration files
      {item => ["$editor ~/.conkyrc",              'Conky RC',    'text-x-generic']},
      {item => ["$editor ~/.config/tint2/tint2rc", 'Tint2 Panel', 'text-x-generic']},

      # obmenu-generator category
      {beg => ['Obmenu-Generator', 'accessories-text-editor']},
        {item      => ["$editor ~/.config/obmenu-generator/schema.pl", 'Menu Schema', 'text-x-generic']},
        {item      => ["$editor ~/.config/obmenu-generator/config.pl", 'Menu Config', 'text-x-generic']},

        {sep  => undef},
        {item => ['obmenu-generator -s -c',    'Gera um menu estatico ',             'accessories-text-editor']},
        {item => ['obmenu-generator -s -i -c', 'Gera um menu estatico  com icones',  'accessories-text-editor']},
        {sep  => undef},
        {item => ['obmenu-generator -p',       'Gera um menu dinamico ',            'accessories-text-editor']},
        {item => ['obmenu-generator -p -i',    'Gera um menu dinamico  com icones', 'accessories-text-editor']},
        {sep  => undef},

        {item    => ['obmenu-generator -d', 'Atualiza Icones', 'view-refresh']},
      {end => undef},

      # Openbox category
      {beg => ['Openbox', 'openbox']},
        {item      => ["$editor ~/.config/openbox/autostart", 'Openbox Autostart',   'text-x-generic']},
        {item      => ["$editor ~/.config/openbox/rc.xml",    'Openbox RC',          'text-x-generic']},
        {item      => ["$editor ~/.config/openbox/menu.xml",  'Openbox Menu',        'text-x-generic']},
        {item      => ['openbox --reconfigure',               'Reconfigure Openbox', 'openbox']},
      {end => undef},
    {end => undef},

    {sep => undef},

    #{pipe => ['~/.config/openbox/scripts/obbrowser.pl', 'Disk', 'drive-harddisk']},

    #{pipe => ['~/.config/openbox/scripts/ob-places.pl', 'Locais', 'drive-harddisk']}, 
    #{pipe => ['~/.config/openbox/scripts/cb-places-pipemenu', 'Locais', 'drive-harddisk']}, 
    {pipe => ['~/.config/openbox/scripts/places-pipemenu', 'Locais', 'drive-harddisk']}, 
    {pipe => ['~/.config/openbox/scripts/help-pipemenu', 'Ajuda', 'help']}, 
    {pipe => ['~/.config/openbox/scripts/template-pipemenu', 'Modelos', 'applications-libraries']},
    {pipe => ['~/.config/openbox/scripts/inxi-pipemenu', 'Inxi Info', 'application-menu']}, 
    #{pipe => ['~/.config/openbox/scripts/storage-pipemenu', 'StorageInfo', 'dialog-information-symbolic']}, 
    #{pipe => ['~/.config/openbox/scripts/sysinfo-pipemnu', 'SysInfo', 'dialog-information-symbolic']}, 
    #{pipe => ['~/.config/openbox/scripts/cb-recent-pipemenu', 'Recentes', 'view-wrapped-symbolic']}, 
    #{pipe => ['corgi-openbox-menus-power-management', 'Power', 'applications-multimedia']}, 
    #{pipe => ['corgi-openbox-menus-displays', 'Monitores', 'applications-graphics']}, 
    #{pipe => ['corgi-openbox-menus-network', 'Rede', 'applications-internet']}, 
    {pipe => ['~/.config/openbox/scripts/recent-pipemenu', 'Recentes', 'view-wrapped-symbolic']}, 
    #{pipe => ['~/.config/openbox/scripts/mpc-pipemenu', 'MPC', 'multimedia']}, 
    {pipe => ['~/.config/openbox/scripts/audacious-pipemenu', 'Audacious', 'multimedia']}, 
    #{pipe => ['~/.config/openbox/scripts/virtualbox-pipemenu', 'Virtualbox', 'virtualbox']}, 
    # 
    
    # {sep => undef},

    ## The xscreensaver lock command
    {item => ['~/bin/autolock lock', 'Bloquear', 'system-lock-screen']},

    ## This option uses the default Openbox's "Exit" action
    {item => ['oblogout', 'Sair', 'application-exit']},

    ## This option uses the default Openbox's "Exit" action
    # {exit => ['Exit', 'application-exit']},

    ## This uses the 'oblogout' menu
    # {item => ['oblogout', 'Exit', 'application-exit']},
]
}
else 
{
our $SCHEMA = [
    #          COMMAND                 LABEL              ICON
    {sep => mk_distro },

    {item => ["$fileman .",       'Files', 'system-file-manager']},
    {item => ['x-terminal-emulator',            'Terminal',     'utilities-terminal']},
    {item => ["$brcmd", 'Web Browser',  'web-browser']},
    {item => ['gmrun',            'Run command',  'system-run']},

    {sep       => undef},

    #          NAME            LABEL                ICON
    {cat => ['utility',     'Utilities',   'applications-utilities']},
    {cat => ['development', 'Development', 'applications-development']},
    {cat => ['education',   'Education',   'applications-science']},
    {cat => ['game',        'Games',       'applications-games']},
    {cat => ['graphics',    'Graphics',    'applications-graphics']},
    {cat => ['audiovideo',  'Multimedia',  'applications-multimedia']},
    {cat => ['network',     'Network',     'applications-internet']},
    {cat => ['office',      'Office',      'applications-office']},
    {cat => ['other',       'Others',      'applications-other']},
    {cat => ['settings',    'Preferences', 'preferences-desktop']},
    {cat => ['system',      'System',      'applications-system']},

    #                  LABEL          ICON
    #{beg => ['My category',  'cat-icon']},
    #          ... some items ...
    #{end => undef},

    #            COMMAND     LABEL        ICON
    #{pipe => ['obbrowser', 'Disk', 'drive-harddisk']},

    ## Generic advanced settings
    #{sep       => undef},
    #{obgenmenu => ['Openbox Settings', 'applications-engineering']},
    #{sep       => undef},

    ## Custom advanced settings
    {sep       => undef},
    {beg => ['Advanced Settings', 'applications-system']},

      # Configuration files
      {item => ["$editor ~/.conkyrc",              'Conky RC',    'text-x-generic']},
      {item => ["$editor ~/.config/tint2/tint2rc", 'Tint2 Panel', 'text-x-generic']},

      # obmenu-generator category
      {beg => ['Obmenu-Generator', 'accessories-text-editor']},
        {item      => ["$editor ~/.config/obmenu-generator/schema.pl", 'Menu Schema', 'text-x-generic']},
        {item      => ["$editor ~/.config/obmenu-generator/config.pl", 'Menu Config', 'text-x-generic']},

        {sep  => undef},
        {item => ['obmenu-generator -s -c',    'Generate estatic menu ',             'accessories-text-editor']},
        {item => ['obmenu-generator -s -i -c', 'Generate estatic menu with icons',  'accessories-text-editor']},
        {sep  => undef},
        {item => ['obmenu-generator -p',       'Generate dynamic menu ',            'accessories-text-editor']},
        {item => ['obmenu-generator -p -i',    'Generate dynamic menu with icons', 'accessories-text-editor']},
        {sep  => undef},

        {item    => ['obmenu-generator -d', 'Refresh Icons', 'view-refresh']},
      {end => undef},

      # Openbox category
      {beg => ['Openbox', 'openbox']},
        {item      => ["$editor ~/.config/openbox/autostart", 'Openbox Autostart',   'text-x-generic']},
        {item      => ["$editor ~/.config/openbox/rc.xml",    'Openbox RC',          'text-x-generic']},
        {item      => ["$editor ~/.config/openbox/menu.xml",  'Openbox Menu',        'text-x-generic']},
        {item      => ['openbox --reconfigure',               'Reconfigure Openbox', 'openbox']},
      {end => undef},
    {end => undef},

    {sep => undef},

    #{pipe => ['~/.config/openbox/scripts/ob-places.pl', 'Places', 'drive-harddisk']}, 
    #{pipe => ['~/.config/openbox/scripts/cb-places-pipemenu', 'Places', 'drive-harddisk']}, 
    {pipe => ['~/.config/openbox/scripts/places-pipemenu', 'Places', 'drive-harddisk']}, 
    {pipe => ['~/.config/openbox/scripts/help-pipemenu', 'Help', 'help']}, 
    {pipe => ['~/.config/openbox/scripts/template-pipemenu', 'Templates', 'applications-libraries']},
    {pipe => ['~/.config/openbox/scripts/inxi-pipemenu', 'Inxi Info', 'application-menu']}, 
    #{pipe => ['~/.config/openbox/scripts/storage-pipemenu', 'StorageInfo', 'dialog-information-symbolic']}, 
    #{pipe => ['~/.config/openbox/scripts/sysinfo-pipemnu', 'SysInfo', 'dialog-information-symbolic']}, 
    {pipe => ['~/.config/openbox/scripts/recent-pipemenu', 'Recent', 'view-wrapped-symbolic']}, 
    #{pipe => ['~/.config/openbox/scripts/cb-recent-pipemenu', 'Recent', 'view-wrapped-symbolic']}, 
    #{pipe => ['~/.config/openbox/scripts/mpc-pipemenu', 'MPC', 'multimedia']}, 
    {pipe => ['~/.config/openbox/scripts/audacious-pipemenu', 'Audacious', 'multimedia']}, 
    #{pipe => ['~/.config/openbox/scripts/virtualbox-pipemenu', 'Virtualbox', 'virtualbox']}, 
    # 
    
    # {sep => undef},

    ## The xscreensaver lock command
    {item => ['~/bin/autolock lock', 'Lock', 'system-lock-screen']},

    ## This option uses the default Openbox's "Exit" action
    {item => ['oblogout', 'Exit', 'application-exit']},

    ## This option uses the default Openbox's "Exit" action
    # {exit => ['Exit', 'application-exit']},

    ## This uses the 'oblogout' menu
    # {item => ['oblogout', 'Exit', 'application-exit']},
]
}

