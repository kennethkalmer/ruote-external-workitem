require 'time'

module RuoteExternalWorkitem
  # Shared functionality for all workitems, no matter what the source
  # of the workitem is.
  class Base
    include REST
    include AMQP
    include XMPP

    def initialize( workitem = {} )
      @workitem = workitem
    end

    def fei
      @workitem['flow_expression_id']
    end
    
    def short_fei
      @short_fei ||=
        '(' + [
               'fei', self.fei['owfe_version'], self.fei['engine_id'],
               self.fei['workflow_definition_url'], self.fei['workflow_definition_name'],
               self.fei['workflow_definition_revision'], self.fei['workflow_instance_id'],
               self.fei['expression_name'], self.fei['expression_id']
              ].join(' ') + ')'
    end

    def dispatch_time
      @dispath_time ||= Time.parse( @workitem['dispatch_time'] )
    end

    def last_modified
      @last_modified ||= Time.parse( @workitem['last_modified'] )
    end

    def participant_name
      @workitem['participant_name']
    end

    def attributes
      @workitem['attributes']
    end

    def []( key )
      self.attributes[ key ]
    end

    def []=( key, value )
      self.attributes[ key ] = value
    end

    def to_json
      @workitem.to_json
    end

    def method_missing( method_name, *args )
      if self.attributes.keys.include?( method_name.to_s )
        return self.attributes[ method_name.to_s ]
      end

      super
    end
  end
end
