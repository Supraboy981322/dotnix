let
  pkgs = import <nixpkgs> {};

  # my preference of web browser
  zen-browser = import (
    builtins.fetchTarball
        "https://github.com/youwen5/zen-browser-flake/archive/master.tar.gz"
  ) { inherit pkgs; };

  # fn that returns an attr set for a browser extention
  firefox_extension = shortId: guid: {
    name = guid;
    value = {
      install_url = "https://addons.mozilla.org/en-US/firefox/downloads/latest/${shortId}/latest.xpi";
      installation_mode = "normal_installed";
    };
  };

  # fn that returns an attr set for a search engine
  firefox_search_engine = name: alias: template: {
    Name = name;
    URLTemplate = template;
    Alias = "@${alias}";
  };

  # the bulk of my preferences (stuff from about:config)
  #   (I just noticed how they're mostly 'false')
  firefox_prefs = {
    "ui.systemUsesDarkTheme" = 1;
    "sidebar.verticalTabs" = true;
    "sidebar.verticalTabs.dragToPinPromo.dismissed" = true;

    "browser.uiCustomization.navBarWhenVerticalTabs" = builtins.toJSON [
      "sidebar-button"
      "back-button"
      "forward-button"
      "stop-reload-button"
      "customizableui-special-spring1"
      "vertical-spacer"
      "urlbar-container"
      "customizableui-special-spring2"
      "downloads-button"
      "fxa-toolbar-menu-button"
      "unified-extensions-button"
    ];

    "browser.ml.linkPreview.enabled" = false;
    "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
    "browser.newtabpage.activity-stream.feeds.topsites" = false;
    "browser.newtabpage.activity-stream.showSponsored" = false;
    "browser.newtabpage.activity-stream.showSponsoredCheckboxes" = false;
    "browser.newtabpage.activity-stream.showSponsoredTopSites" = false;
    "browser.newtabpage.activity-stream.showWeather" = false;

    "browser.shell.checkDefaultBrowser" = false;
    "browser.theme.content-theme" = 0;
    "browser.tabs.closeWindowWithLastTab" = false;
    "browser.aboutConfig.showWarning" = false;
    "devtools.inspector.three-pane-enabled" = false;
    "devtools.theme" = "dark";
    "devtools.toolbox.host" = "window";
    "layout.css.prefers-color-scheme.content-override" = 0;
    "network.dns.disablePrefetch" = true;

    # TODO: research what this is "network.http.speculative-parallel-limit" = 0;
    "network.prefetch-next" = false;
    "privacy.clearOnShutdown_v2.formdata" = true;
    "privacy.globalprivacycontrol.was_ever_enabled" = true;
    "privacy.history.custom" = true;

    "gfx.wayland.hdr" = false;               # fixes severe, breaking graphical
    "gfx.wayland.hdr.force-enabled" = false; #   bugs on Hyprland with Nvidia

    "browser.aboutwelcome.enabled" = false;
    "browser.theme.toolbar-theme" = 0;
    "browser.toolbars.bookmarks.visibility" = "never";
    "browser.uiCustomization.horizontalTabstrip" = builtins.toJSON [
      "tabbrowser-tabs"
      "new-tab-button"
    ];

    "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    "extensions.ui.dictionary.hidden" = true;
    "extensions.ui.locale.hidden" = true;
    "extensions.ui.mlmodel.hidden" = true;
    "sidebar.visibility" = "hide-sidebar";

    # WARNING: this fixes every FireFox based browser seg-faulting
    #  (on an Nvidia system without proprietary drivers)
    "layers.acceleration.force-enabled" = false;
    "gfx.webrender.all" = false;
    "widget.wayland-dmabuf-vaapi.enabled" = false;
  };

  # list of browser extentions
  firefox_extensions = pkgs.lib.forEach (
    pkgs.lib.attrsToList {
      # in order of importance to me
      ublock-origin = "uBlock0@raymondhill.net";
          vimium-ff = "{d7742d87-e61d-4b78-b8a1-b469842139fa}";
         darkreader = "addon@darkreader.org";
           noscript = "{73a6fe31-595d-460b-a920-fcc0f8843232}";
        proton-pass = "78272b6fa58f4a1abaac99321d503a20@proton.me";
       tampermonkey = "firefox@tampermonkey.net";
          clearurls = "{74145f27-f039-47ce-a470-a662b129930a}";
           seven_tv = "seventv-next@7tv.app";
    }) (kv: firefox_extension kv.name kv.value);

  # list of search engines
  firefox_search_engines = pkgs.lib.forEach [
    {
      desc = "nixpkgs";
      alias = "pkgs";
      url = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}";
    }
    {
      desc = "NixOS wiki";
      alias = "nixos";
      url = "https://search.nixos.org/options?query={searchTerms}";
    }
    {
      desc = "noogle.dev";
      alias = "nix";
      url = "https://noogle.dev/q?term={searchTerms}";
    }
    {
      desc = "zig stdlib docs";
      alias = "zig";
      url = "https://ziglang.org/documentation/0.16.0/std/#{searchTerms}";
    }
  ] (attrset:
    firefox_search_engine attrset.desc attrset.alias attrset.url);

  # helper to parse prefs set to json
  firefox_prefs_set_to_json = prefs: pkgs.lib.concatLines
    (pkgs.lib.mapAttrsToList (name: value:
      let
        json_name = pkgs.lib.strings.toJSON name;
        json_value = pkgs.lib.strings.toJSON value;
      in
        ''lockPref(${json_name}, ${json_value});''
    ) prefs);

  # fn that injects my preferences
  inject_prefs = browser: extra_prefs: prefs_script:
    { prefs ? {}, telemetry ? false, extensions ? [], search ? {} }:
      pkgs.wrapFirefox browser {
        # about:config
        extraPrefs =  (firefox_prefs_set_to_json (prefs // extra_prefs)) + prefs_script;
        # settings
        extraPolicies = {
          # this should always be set to true, but you have the option
          DisableTelemetry = !telemetry;
          # list of browser extensions
          ExtensionSettings = builtins.listToAttrs extensions;
          # search engines
          SearchEngines = search;
        };
      };

  the_set_i_use = {
    prefs = firefox_prefs;
    telemetry = false;
    extensions = firefox_extensions;
    search = {
      Add = firefox_search_engines;
    };
  };

  new_browser_option = unwrapped: default: extra_prefs: prefs_script:
    let
      injected = inject_prefs unwrapped extra_prefs prefs_script the_set_i_use;
    in {
      # wrapped in my preferences
      re-wrapped = injected;
      # fn for my preferences plus additional config
      re-wrapped_configure = config: injected // config;
      # unmodified browser
      untouched = default;
    };

  wrap_browser = { name, unwrapped, default, extra_prefs ? {}, prefs_script ? "" }:
    {
      name = name;
      value = new_browser_option unwrapped default extra_prefs prefs_script;
    };

in (builtins.listToAttrs (map wrap_browser [
  {
    name = "firefox";
    unwrapped = pkgs.firefox-unwrapped;
    default = pkgs.firefox;
    extra_prefs = {
      "browser.uiCustomization.state" = builtins.toJSON {
        currentVersion = 26;
        newElementCount = 3;
        placements = {
          widget-overflow-fixed-list = [];

          unified-extensions-area = [
            "seventv-next_7tv_app-browser-action"
            "firefoxcolor_mozilla_com-browser-action"
            "addon_darkreader_org-browser-action"
            "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"
            "firefox_tampermonkey_net-browser-action"
          ];

          nav-bar = [
            "alltabs-button"
            "ai-window-toggle"
            "reset-pbm-toolbar-button"
            "urlbar-container"
            "vertical-spacer"
            "forward-button"
            "back-button"
            "unified-extensions-button"
            "_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action"
            "ublock0_raymondhill_net-browser-action"
            "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
            "_74145f27-f039-47ce-a470-a662b129930a_-browser-action"
          ];

          toolbar-menubar =[ "menubar-items" ];
          TabsToolbar = [];
          vertical-tabs = [ "tabbrowser-tabs" ];

          PersonalToolbar = [
            "import-button"
            "personal-bookmarks"
          ];

        };

        seen = [
          "reset-pbm-toolbar-button"
          "ai-window-toggle"
          "developer-button"
          "screenshot-button"
          "seventv-next_7tv_app-browser-action"
          "_73a6fe31-595d-460b-a920-fcc0f8843232_-browser-action"
          "ublock0_raymondhill_net-browser-action"
          "_d7742d87-e61d-4b78-b8a1-b469842139fa_-browser-action"
          "_74145f27-f039-47ce-a470-a662b129930a_-browser-action"
          "firefoxcolor_mozilla_com-browser-action"
          "addon_darkreader_org-browser-action"
          "78272b6fa58f4a1abaac99321d503a20_proton_me-browser-action"
          "firefox_tampermonkey_net-browser-action"
        ];

        dirtyAreaCache = [
          "nav-bar"
          "TabsToolbar"
          "vertical-tabs"
          "toolbar-menubar"
          "PersonalToolbar"
          "unified-extensions-area"
        ];

      };
    };
  }

  {
    name = "zen";
    unwrapped = zen-browser.zen-browser-unwrapped;
    default = zen-browser.default;
    # Zen Browser specific stuff
    extra_prefs = {
      "zen.updates.show-update-notification" = false;
      "zen.view.compact.enable-at-startup" = true;
      "zen.view.compact.hide-tabbar" = true;
      "zen.view.compact.hide-toolbar" = true;
      "zen.view.compact.toolbar-flash-popup" = true;
      "zen.view.window.scheme" = 0;
      "zen.view.use-single-toolbar" = false;
      "zen.watermark.enabled" = false;
      "zen.welcome-screen.seen" = true;
      #"zen.workspaces.continue-where-left-off" = true;
      "sidebar.verticalTabs" = false; # when set to 'true', it breaks Zen's sidebar
    };
  }

])) // {

  # fn to inject into your own browser
  custom = { browser, config, prefs_script ? "" }:
      inject_prefs browser {} prefs_script config;

}
