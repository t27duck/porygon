require "yaml"

class Settings
  @settings = {}
  attr_reader :settings

  def self.load!(filename='./config.yml')
    @settings = YAML::load_file(filename)
  end

  def self.method_missing(name, *args, &block)
    return @settings[name.to_s] if @settings[name.to_s]
    raise NoMethodError, "Unknown config #{name}"
  end
end
