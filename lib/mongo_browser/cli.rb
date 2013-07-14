require "mongo_browser"
require "thor"

module MongoBrowser
  class CLI < Thor
    def initilatize(args = [], opts = [], config = {})
      super(args, opts, config)
    end
  end
end
