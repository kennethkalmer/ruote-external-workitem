module RuoteExternalWorkitem
  # Extension to #Base with AMQP specific information exposed
  module AMQP

    def source_queue
      @workitem['source_queue']
    end

    def reply_queue
      @workitem['reply_queue']
    end
  end
end
