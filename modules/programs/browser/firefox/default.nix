{
  username,
  pkgs,
  ...
}: let
  lock-false = {
    Value = false;
    Status = "locked";
  };
  lock-true = {
    Value = true;
    Status = "locked";
  };
in {
  home-manager.users.${username} = _: {
    programs = {
      firefox = {
        enable = true;
        package = pkgs.wrapFirefox pkgs.firefox-unwrapped {
          extraPolicies = {
            DisableTelemetry = true;
            # add policies here...

            /*
            ---- GLOBAL EXTENSIONS ----
            */
            ExtensionSettings = {
              "*".installation_mode = "normal_installed"; # blocks all addons except the ones specified below
              "uBlock0@raymondhill.net" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
                installation_mode = "force_installed";
              };
              "addon@darkreader.org" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/darkreader/latest.xpi";
                installation_mode = "force_installed";
              };
              "jid1-MnnxcxisBPnSXQ@jetpack" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger17/latest.xpi";
                installation_mode = "force_installed";
              };
               "{d7742d87-e61d-4b78-b8a1-b469842139fa}" = {
                 install_url = "https://addons.mozilla.org/firefox/downloads/latest/vimium-ff/latest.xpi";
                 installation_mode = "force_installed";
               };
              "{c2c003ee-bd69-42a2-b0e9-6f34222cb046}" = {
                install_url = "https://addons.mozilla.org/firefox/downloads/latest/auto-tab-discard/latest.xpi";
                installation_mode = "normal_installed";
              };
              "queryamoid@kaply.com" = {
                install_url = "https://github.com/mkaply/queryamoid/releases/download/v0.1/query_amo_addon_id-0.1-fx.xpi";
                installation_mode = "force_installed";
              };
              # add extensions here...
            };

            /*
            ---- PREFERENCES ----
            */
            # Set preferences shared by all profiles.
            Preferences = {
              # Performance settings
              "gfx.webrender.all" = true; # Force enable GPU acceleration
              "media.ffmpeg.vaapi.enabled" = true;
              "widget.dmabuf.force-enabled" = true; # Required in recent Firefoxes
              "reader.parse-on-load.force-enabled" = true;
              "privacy.webrtc.legacyGlobalIndicator" = false;

              # Use cloudflare for better security/privacy
              "network.trr.mode" = 3; # 2 if your havng DNS problems
              "network.trr.custom_uri" = "https://cloudflare-dns.com/dns-query";
              "network.trr.uri" = "https://cloudflare-dns.com/dns-query";

              # Remove trackers
              "privacy.purge_trackers.enabled" = lock-true;
              "privacy.trackingprotection.enabled" = lock-true;
              "privacy.trackingprotection.fingerprinting.enabled" = lock-true;
              "privacy.resistFingerprinting" = lock-true;
              "privacy.trackingprotection.socialtracking.enabled" = lock-true;
              "privacy.trackingprotection.cryptomining.enabled" = lock-true;
              "privacy.globalprivacycontrol.enabled" = lock-true;
              "privacy.globalprivacycontrol.functionality.enabled" = lock-true;
              "privacy.donottrackheader.enabled" = lock-true;
              "privacy.donottrackheader.value" = 1;
              "privacy.query_stripping.enabled" = lock-true;
              "privacy.query_stripping.enabled.pbmode" = lock-true;

          
              # Block more unwanted stuff
              "browser.privatebrowsing.forceMediaMemoryCache" = lock-true;
              "browser.contentblocking.category" = {
                Value = "strict";
                Status = "locked";
              };
              "browser.search.suggest.enabled" = lock-false;
              "browser.search.suggest.enabled.private" = lock-false;
              "privacy.popups.disable_from_plugins" = 3;
              "extensions.pocket.enabled" = lock-false;
              
              # General settings
              "ui.key.accelKey" = 17; # Set CTRL as master key
              "browser.newtab.url" = "https://tetsorou.github.io";
              "browser.newtabpage.activity-stream.enabled" = lock-false;
              "browser.newtabpage.activity-stream.telemetry" = lock-false;
              "browser.newtabpage.enhanced" = lock-false;
              "browser.newtabpage.introShown" = lock-true;
              "browser.newtabpage.pinned" = false;
              "browser.bookmarks.defaultLocation" = "toolbar";
              "browser.startup.page" = 3;
              "app.shield.optoutstudies.enabled" = lock-false;
              "dom.security.https_only_mode" = lock-true;
              "dom.security.https_only_mode_ever_enabled" = lock-true;
              "identity.fxaccounts.enabled" = lock-false;
              "app.update.auto" = false;
              "browser.startup.homepage" = "https://tetsorou.github.io";
              "browser.bookmarks.restore_default_bookmarks" = false;
              "browser.ctrlTab.recentlyUsedOrder" = false;
              "browser.discovery.enabled" = false;
              "browser.laterrun.enabled" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.addons" = false;
              "browser.newtabpage.activity-stream.asrouter.userprefs.cfr.features" = false;
              "browser.newtabpage.activity-stream.feeds.snippets" = false;
              "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "";
              "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.searchEngines" = "";
              "browser.protections_panel.infoMessage.seen" = true;
              "browser.ssb.enabled" = true;
              "browser.toolbars.bookmarks.visibility" = "newtab";
              #"browser.urlbar.placeholderName" = "Google";
              "browser.urlbar.suggest.openpage" = false;
              "datareporting.policy.dataSubmissionEnable" = false;
              "datareporting.policy.dataSubmissionPolicyAcceptedVersion" = 2;

              "extensions.screenshots.disabled" = lock-true;
              "extensions.getAddons.showPane" = lock-false;
              "extensions.htmlaboutaddons.recommendations.enabled" = lock-false;
              "extensions.extensions.activeThemeID" = "firefox-alpenglow@mozilla.org";
              # "extensions.update.enabled" = false;
              "extensions.webcompat.enable_picture_in_picture_overrides" = true;
              "extensions.webcompat.enable_shims" = true;
              
            };
          };
        };

        /*
        ---- PROFILES ----
        */
        # Switch profiles via about:profiles page.
        # For options that are available in Home-Manager see
        # https://nix-community.github.io/home-manager/options.html#opt-programs.firefox.profiles
        profiles = {
          default = {
            # choose a profile name; directory is /home/<user>/.mozilla/firefox/profile_0
            id = 0; # 0 is the default profile; see also option "isDefault"
            name = "default"; # name as listed in about:profiles
            isDefault = true; # can be omitted; true if profile ID is 0
            extensions = with pkgs.nur.repos.rycee.firefox-addons; [
              # profile-switcher
            ];
            extraConfig = ''
              lockPref("extensions.autoDisableScopes", 0);
            '';
          };
          # add profiles here...
        };
      };
    };
  };
}
