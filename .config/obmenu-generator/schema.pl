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

our $SCHEMA = [

    #          COMMAND                 LABEL              ICON
    {item => ['xdg-open .',       'Arquivos', 'system-file-manager']},
    {item => ['tilix',            'Terminal',     'utilities-terminal']},
    {item => ['xdg-open http://', 'Web Browser',  'web-browser']},
    {item => ['gmrun',            'Executar comando',  'system-run']},

    {sep => 'Categorias'},

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
    {cat => ['settings',    'Preferências',    'applications-accessories']},
    {cat => ['system',      'Sistema',      'applications-system']},

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
    {beg => ['Preferências Avançadas', 'applications-engineering']},

      # Configuration files
      {item => ["$editor ~/.conkyrc",              'Conky RC',    'text-x-generic']},
      {item => ["$editor ~/.config/tint2/tint2rc", 'Tint2 Panel', 'text-x-generic']},

      # obmenu-generator category
      {beg => ['Obmenu-Generator', 'accessories-text-editor']},
        {item      => ["$editor ~/.config/obmenu-generator/schema.pl", 'Menu Schema', 'text-x-generic']},
        {item      => ["$editor ~/.config/obmenu-generator/config.pl", 'Menu Config', 'text-x-generic']},

        {sep  => undef},
        {item => ['obmenu-generator -s -c',    'Generate a static menu',             'accessories-text-editor']},
        {item => ['obmenu-generator -s -i -c', 'Generate a static menu with icons',  'accessories-text-editor']},
        {sep  => undef},
        {item => ['obmenu-generator -p',       'Generate a dynamic menu',            'accessories-text-editor']},
        {item => ['obmenu-generator -p -i',    'Generate a dynamic menu with icons', 'accessories-text-editor']},
        {sep  => undef},

        {item    => ['obmenu-generator -d', 'Refresh icon set', 'view-refresh']},
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

    {pipe => ['~/.config/openbox/scripts/obpipemenu-places', 'Diretórios', 'folder']}, 
    {pipe => ['~/.config/openbox/scripts/sysInfo.sh pipe', 'SysInfo', 'dialog-information-symbolic']}, 
    {pipe => ['~/.config/openbox/scripts/obrecent.sh', 'Recentes', 'view-wrapped-symbolic']}, 
    {pipe => ['~/.config/openbox/scripts/al-audacious.sh', 'Audacious', 'multimedia']}, 
    #{pipe => ['~/.config/openbox/scripts/recently_opened_menu.sh', 'Recentes', 'view-wrapped-symbolic']}, 
    # 
    
    # {sep => undef},

    ## The xscreensaver lock command
    {item => ['~/bin/autolock.sh lock', 'Bloquear', 'system-lock-screen']},

    ## This option uses the default Openbox's "Exit" action
    {item => ['~/bin/bl-exit.sh', 'Sair', 'application-exit']},

    ## This option uses the default Openbox's "Exit" action
    # {exit => ['Exit', 'application-exit']},

    ## This uses the 'oblogout' menu
    # {item => ['oblogout', 'Exit', 'application-exit']},
]
