module RuoteExternalWorkitem
  # Extensions to #Base with XMPP specific information exposed
  module XMPP

    def source_jid
      @workitem['source_jid']
    end

    def reply_jid
      @workitem['reply_jid']
    end
  end
end
