# frozen_string_literal: true

require 'rake'

module KubsCLI
  # Copies from a repo to $HOME directory
  class Copy
    attr_accessor :config

    def initialize(config = KubsCLI.configuration)
      @fh = FileHelper.new
      @config = config
    end

    def copy_all
      copy_dotfiles
      copy_gnome_terminal_settings
    end

    def copy_dotfiles
      Dir.each_child(@config.dotfiles) do |file|
        config_file = File.join(@config.dotfiles, file)
        local_file = File.join(@config.local_dir, ".#{file}")

        @fh.copy(from: config_file, to: local_file)
      end
    end

    def copy_gnome_terminal_settings
      unless @config.gnome_terminal_settings
        return
      end
      # This is the ONLY spot for gnome terminal
      gnome_path = '/org/gnome/terminal/'
      gnome_file = @config.gnome_terminal_settings

      unless File.exist?(gnome_file)
        KubsCLI.add_error(e: KubsCLI::Error, msg: "Could not find #{gnome_file}")
        return
      end

      dconf_load = "dconf load #{gnome_path} < #{config.gnome_terminal_settings}"
      Rake.sh(dconf_load)
    rescue RuntimeError => e
      KubsCLI.add_error(e: e, msg: 'Unable to copy gnome settings')
    end
  end
end
