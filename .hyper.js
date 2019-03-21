// Future versions of Hyper may add additional config options,
// which will not automatically be merged into this file.
// See https://hyper.is#cfg for all currently supported options.

module.exports = {
  config: {
    // choose either `'stable'` for receiving highly polished,
    // or `'canary'` for less polished but more frequent updates
    updateChannel: 'stable',

    // default font size in pixels for all tabs
    fontSize: 14,

    // font family with optional fallbacks
    fontFamily: '"Fira Mono for Powerline", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace',

    // default font weight: 'normal' or 'bold'
    fontWeight: 'normal',

    // font weight for bold characters: 'normal' or 'bold'
    fontWeightBold: 'bold',

    // terminal cursor background color and opacity (hex, rgb, hsl, hsv, hwb or cmyk)
    cursorColor: 'rgba(248,28,229,0.8)',

    // terminal text color under BLOCK cursor
    cursorAccentColor: '#000',

    // `'BEAM'` for |, `'UNDERLINE'` for _, `'BLOCK'` for █
    cursorShape: 'BLOCK',

    // set to `true` (without backticks and without quotes) for blinking cursor
    cursorBlink: false,

    // color of the text
    foregroundColor: '#fff',

    // terminal background color
    // opacity is only supported on macOS
    backgroundColor: '#000',

    // terminal selection color
    selectionColor: 'rgba(248,28,229,0.3)',

    // border color (window, tabs)
    borderColor: '#333',

    // custom CSS to embed in the main window
    css: `
    /* Move the hamburger menu to right */
    .header_hamburgerMenuLeft {
      left: auto;
      right: 120px;
    }

    .header_windowHeader {
      background: rgba(0, 0, 0, 0.1);
    }

    /* Hide app title when more than 1 tab */
    .header_windowHeaderWithBorder .header_appTitle {
      display: none;
    }

    /* Move tabs in header like in Chrome */
    .tabs_nav {
      position: fixed;
      top: 1px;
      left: 1px;
      z-index: 101;
      width: calc(100% - 200px);
      -webkit-app-region: no-drag;
    }

    /* Light up active tab */
    .tab_tab {
      will-change: background-color;
    }
    .tab_tab.tab_active,
    .tab_tab:hover {
      background-color: #282a36; /* backgroundColor */
      transition: background-color 150ms;
    }

    /* Do not shift since tabs are now in header */
    .terms_termsShifted {
      margin-top: 34px;
    }

    /* Fade the title of inactive tabs and the content of inactive panes */
    .tab_text,
    .term_term {
      opacity: 0.5;
      will-change: opacity;
    }
    .tab_active .tab_text,
    .term_active .term_term {
      opacity: 1;
      transition: opacity 100ms;
    }

    /* Hyper search custom theme */
    .hyper-search-wrapper {
      border-radius: 0 !important;
      border: 1px solid rgba(255, 106, 193, 0.4) !important;
      height: 36px !important;
      top: 10px !important;
      right: 24px !important;
      width: 274px !important;
      padding: 5px 0px 5px 13px !important;
      opacity: 1 !important;
      background: #242530 !important;
      box-shadow: 0 5px 15px rgba(255, 106, 193, 0.1);
      animation: hyperSearchSlideDown 100ms;
    }
    .hyper-search-wrapper input {
      font-size: 14px !important;
      margin-right: 10px !important;
      font-family: "Fira Mono for Powerline", Menlo, "DejaVu Sans Mono", Consolas, "Lucida Console", monospace !important;
    }
    .hyper-search-wrapper button {
      background: none !important;
      border-radius: 0 !important;
      height: 24px !important;
      width: 24px !important;
      overflow: hidden;
      text-indent: 50px;
      opacity: 0.5 !important;
      transition: opacity 100ms;
    }
    .hyper-search-wrapper button:hover {
      opacity: 1 !important;
    }
    .hyper-search-wrapper button:nth-child(2),
    .hyper-search-wrapper button:nth-child(3) {
      top: -1px !important;
    }
    .hyper-search-wrapper button::before {
      content: "⯅";
      color: #fff;
      position: absolute;
      top: 4px;
      left: 0;
      height: 24px;
      width: 24px;
      text-indent: 0;
    }
    .hyper-search-wrapper button:nth-child(3)::before {
      content: "⯆";
      top: 2px;
    }
    .hyper-search-wrapper button:nth-child(4)::before {
      content: "Aa";
      top: 5px;
    }
    .hyper-search-wrapper button:nth-child(4)[style*="background: rgb(40, 42, 54);"] {
      opacity: 0.6 !important;
    }
    .hyper-search-wrapper button:nth-child(4)[style*="background: rgb(40, 42, 54);"]:hover {
      opacity: 1 !important;
    }
    .hyper-search-wrapper button:nth-child(4)[style*="background: rgb(40, 42, 54);"]::before {
      color: rgb(255, 106, 193);
    }

    @keyframes hyperSearchSlideDown {
      0% { transform: translateY(-15px); opacity: 0; }
      100% { transform: translateY(0); opacity: 1; }
    }
    `,

    // custom CSS to embed in the terminal window
    termCSS: '',

    // if you're using a Linux setup which show native menus, set to false
    // default: `true` on Linux, `true` on Windows, ignored on macOS
    showHamburgerMenu: '',

    // set to `false` (without backticks and without quotes) if you want to hide the minimize, maximize and close buttons
    // additionally, set to `'left'` if you want them on the left, like in Ubuntu
    // default: `true` (without backticks and without quotes) on Windows and Linux, ignored on macOS
    showWindowControls: '',

    // custom padding (CSS format, i.e.: `top right bottom left`)
    padding: '10px 10px',

    // the full list. if you're going to provide the full color palette,
    // including the 6 x 6 color cubes and the grayscale map, just provide
    // an array here instead of a color map object
    colors: {
      black: '#000000',
      red: '#C51E14',
      green: '#1DC121',
      yellow: '#C7C329',
      blue: '#0A2FC4',
      magenta: '#C839C5',
      cyan: '#20C5C6',
      white: '#C7C7C7',
      lightBlack: '#686868',
      lightRed: '#FD6F6B',
      lightGreen: '#67F86F',
      lightYellow: '#FFFA72',
      lightBlue: '#6A76FB',
      lightMagenta: '#FD7CFC',
      lightCyan: '#68FDFE',
      lightWhite: '#FFFFFF',
    },

    // the shell to run when spawning a new session (i.e. /usr/local/bin/fish)
    // if left empty, your system's login shell will be used by default
    //
    // Windows
    // - Make sure to use a full path if the binary name doesn't work
    // - Remove `--login` in shellArgs
    //
    // Bash on Windows
    // - Example: `C:\\Windows\\System32\\bash.exe`
    //
    // PowerShell on Windows
    // - Example: `C:\\WINDOWS\\System32\\WindowsPowerShell\\v1.0\\powershell.exe`
    shell: 'C:\\Windows\\System32\\bash.exe',

    // for setting shell arguments (i.e. for using interactive shellArgs: `['-i']`)
    // by default `['--login']` will be used
    shellArgs: ['-c', 'cd ~ && exec zsh'],

    // for environment variables
    env: {},

    // set to `false` for no bell
    bell: false,

    // if `true` (without backticks and without quotes), selected text will automatically be copied to the clipboard
    copyOnSelect: false,

    // if `true` (without backticks and without quotes), hyper will be set as the default protocol client for SSH
    defaultSSHApp: true,

    // if `true` (without backticks and without quotes), on right click selected text will be copied or pasted if no
    // selection is present (`true` by default on Windows and disables the context menu feature)
    // quickEdit: true,

    // URL to custom bell
    // bellSoundURL: 'http://example.com/bell.mp3',

    // for advanced config flags please refer to https://hyper.is/#cfg
  },

  // a list of plugins to fetch and install from npm
  // format: [@org/]project[#version]
  // examples:
  //   `hyperpower`
  //   `@company/project`
  //   `project#1.0.1`
  plugins: [
    "hyper-snazzy",
    "hyper-search"
  ],

  // in development, you can create a directory under
  // `~/.hyper_plugins/local/` and include it here
  // to load it and avoid it being `npm install`ed
  localPlugins: [],

  keymaps: {
    // Example
    // 'window:devtools': 'cmd+alt+o',
  },
};
