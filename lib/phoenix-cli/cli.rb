require 'thor'
require 'active_support/inflector'
require 'phoenix-cli'

trap("SIGINT") { exit! }

module PhoenixCli
  class CLI < Thor
    include Thor::Actions

    map %w(-v --version) => :version

    desc "install", "Install framework"
    def install
      exec('mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez')
    end

    desc "new", "Create new project"
    def new(path='')
      exec("mix phoenix.new #{path}")
    end

    desc "server", "Create new project"
    def server
      exec("mix phoenix.server")
    end

    desc "deps", "Install dependences"
    def deps
      exec("mix deps.get")
    end

    desc "console", "Run phoenix console"
    def console
      exec("iex -S mix")
    end

    desc "migrate", "Run ecto migrations"
    def migrate
      exec("mix ecto.migrate")
    end

    desc "generate", "Run generators"
    def generate(*commands)
      generator = commands[0]
      resource = commands[1]
      attributes = commands[2..(commands.length - 1)]

      resource_camelized = resource.camelize
      resource_pluralized = resource.pluralize

      if ['scaffold', 'html', 'resource'].include? generator
        exec("mix phoenix.gen.html #{resource_camelized} #{resource_pluralized} #{attributes.join(' ')}")
      end

      if ['json', 'api'].include? generator
        exec("mix phoenix.json #{resource_camelized} #{resource_pluralized} #{attributes.join(' ')}")
      end

      if ['channel', 'presence', 'secret', 'digest'].include? generator
        exec("mix phoenix.gen.#{generator} #{attributes.join(' ')}")
      end

      if ['model'].include? generator
        exec("mix phoenix.gen.#{generator} #{resource_camelized} #{resource_pluralized} #{attributes.join(' ')}")
      end
    end

    desc "routes", "Show phoenix routes"
    def routes
      exec("mix phoenix.routes")
    end

    desc 'version', 'phoenix-cli version'
    def version
      puts PhoenixCli::VERSION
    end
  end

  class Generate < Thor

  end
end
