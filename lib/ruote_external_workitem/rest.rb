require 'uri'

module RuoteExternalWorkitem
  # Extension of #Base that allows for accessing additional
  # information from the workitems when using a RESTful interface like
  # ruote-rest.
  module REST

    def base_uri
      self.parsed_uri ? self.parsed_uri.to_s.gsub( self.parsed_uri.path, '/' ) : nil
    end

    def uri
      self.parsed_uri ? self.parsed_uri.to_s : nil
    end

    def parsed_uri
      @parsed_uri ||= URI.parse( @workitem['links'].detect { |l| l['rel'] == 'self' }['href'] ) rescue false
    end
  end
end
