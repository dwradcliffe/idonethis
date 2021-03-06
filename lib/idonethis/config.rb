require 'singleton'
require 'yaml'
require 'syck'

module IDoneThis
  class Config < Hashie::Mash
    include Singleton

    attr_reader :present

    FILE = "#{ENV['HOME']}/.idonethisrc"

    def initialize
      begin
        config_data = YAML.load_file(FILE)
        @present = true
      rescue
        config_data = {}
        @present = false
      end

      super(config_data)
    end

    def save
      yaml_data = YAML::dump(to_hash)
      File.open(FILE, 'w') {|f| f.write(yaml_data) }
    end

    def sender
      IDoneThis::Senders.const_get(self["sender"]).new
    end
  end

  def self.config
    Config.instance
  end
end