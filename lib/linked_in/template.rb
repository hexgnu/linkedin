require 'erb'
require 'ostruct'
require 'hashie'

module LinkedIn
  class TemplateBinding < ::Hashie::Mash
    include ERB::Util
  end

  module Template

    class << self
      cache = {}
      mutex = Mutex.new

      define_method :load_template do |template|
        return cache[template] if cache[template]
        mutex.synchronize do
          return cache[template] if cache[template]

          file = File.join(LinkedIn.templates, "#{template.to_s}.xml.erb")
          io = ::IO.respond_to?(:binread) ? ::IO.binread(file) : ::IO.read(file)
          erb = ERB.new(io)
          erb.filename = file

          cache[template] = erb
        end
      end
    end

    def render template, data
      template = Template.load_template template
      namespace = TemplateBinding.new data
      template.result namespace.instance_eval { binding }
    end
  end
end
