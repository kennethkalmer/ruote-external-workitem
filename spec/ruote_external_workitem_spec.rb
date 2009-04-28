require 'spec_helper'

describe RuoteExternalWorkitem, "parsing" do
  it "should parse a workitem from JSON" do
    json = <<-JSON
      {"last_modified": "2009/04/23 12:49:07 +0200",
       "type": "OpenWFE::InFlowWorkItem",
       "participant_name": "toto",
       "attributes": {"shallow": "true", "nes": {"ted": "yes" } },
       "links": [{"href": "http://localhost:4567/workitems", "rel": "via"},
         {"href": "http://localhost:4567/workitems/20090413-juduhojewo/0_0_0_0_1", "rel": "self"}],
       "dispatch_time": "2009/04/23 12:49:07 +0200",
       "flow_expression_id": {"workflow_definition_url": "field:__definition",
       "expression_name": "toto",
       "workflow_definition_name": "TestExternal",
       "owfe_version": "0.9.21",
       "workflow_definition_revision": "0",
       "workflow_instance_id": "20090413-juduhojewo",
       "engine_id": "ruote_rest",
       "expression_id": "0.0.0.0.1"}}
    JSON

    wi = RuoteExternalWorkitem.parse( json )
    wi.should be_an_instance_of( RuoteExternalWorkitem::Base )
  end
end

describe RuoteExternalWorkitem::Base do
  before(:each) do
    json = <<-JSON
      {"last_modified": "2009/04/23 12:49:07 +0200",
       "type": "OpenWFE::InFlowWorkItem",
       "participant_name": "toto",
       "attributes": {"shallow": "true", "nes": {"ted": "yes" } },
       "dispatch_time": "2009/04/23 12:49:07 +0200",
       "flow_expression_id":
          {"workflow_definition_url": "field:__definition",
           "expression_name": "toto",
           "workflow_definition_name": "TestExternal",
           "owfe_version": "0.9.21",
           "workflow_definition_revision": "0",
           "workflow_instance_id": "20090413-juduhojewo",
           "engine_id": "ruote_rest",
           "expression_id": "0.0.0.0.1"}
          }
    JSON

    @wi = RuoteExternalWorkitem.parse( json )
  end
  
  it "should have a fei (FlowExpressionId) hash" do
    fei = @wi.fei

    fei['owfe_version'].should == '0.9.21'

    fei.keys.should include('workflow_definition_url')
    fei.keys.should include('expression_name')
    fei.keys.should include('owfe_version')
    fei.keys.should include('workflow_definition_name')
    fei.keys.should include('workflow_instance_id')
    fei.keys.should include('engine_id')
    fei.keys.should include('expression_id')
  end

  it "should have 'short fei'" do
    @wi.short_fei.should == '(fei 0.9.21 ruote_rest field:__definition TestExternal 0 20090413-juduhojewo toto 0.0.0.0.1)'
  end
  
  it "should have a participant name" do
    @wi.participant_name.should == 'toto'
  end
  
  it "should have a dispatch time" do
    @wi.dispatch_time.should_not be_nil
    @wi.dispatch_time.should be_an_instance_of( Time )
  end
  
  it "should have a last modified time" do
    @wi.last_modified.should_not be_nil
    @wi.last_modified.should be_an_instance_of( Time )
  end
  
  it "should have attributes" do
    @wi.attributes.should be_an_instance_of( Hash )
    @wi.attributes['shallow'].should be_true
  end
  
  it "should act like a hash for attributes" do
    @wi['shallow'].should be_true
  end
  
  it "should have convenient access to attribute keys through methods" do
    lambda {
      @wi.shallow.should be_true
    }.should_not raise_error(NoMethodError)
  end

  it "should spill itself as json" do
    lambda {
      JSON.parse( @wi.to_json )
    }.should_not raise_error(JSON::JSONError)
  end
end

describe RuoteExternalWorkitem::REST do
  before(:each) do
    json = <<-JSON
      {"last_modified": "2009/04/23 12:49:07 +0200",
       "type": "OpenWFE::InFlowWorkItem",
       "participant_name": "toto",
       "attributes": {"shallow": "true", "nes": {"ted": "yes" } },
       "links": [{"href": "http://localhost:4567/workitems", "rel": "via"},
         {"href": "http://localhost:4567/workitems/20090413-juduhojewo/0_0_0_0_1", "rel": "self"}],
       "dispatch_time": "2009/04/23 12:49:07 +0200",
       "flow_expression_id":
          {"workflow_definition_url": "field:__definition",
           "expression_name": "toto",
           "workflow_definition_name": "TestExternal",
           "owfe_version": "0.9.21",
           "workflow_definition_revision": "0",
           "workflow_instance_id": "20090413-juduhojewo",
           "engine_id": "ruote_rest",
           "expression_id": "0.0.0.0.1"}
          }
    JSON

    @wi = RuoteExternalWorkitem.parse( json )
  end
  
  it "should have a base URI" do
    @wi.base_uri.should == "http://localhost:4567/"
  end
  
  it "should have a URI to self" do
    @wi.uri.should == "http://localhost:4567/workitems/20090413-juduhojewo/0_0_0_0_1"
  end
end

describe RuoteExternalWorkitem::XMPP do
  before(:each) do
    json = <<-JSON
      {"last_modified": "2009/04/23 12:49:07 +0200",
       "type": "OpenWFE::InFlowWorkItem",
       "participant_name": "toto",
       "attributes": {"shallow": "true", "nes": {"ted": "yes" } },
       "source_jid": "jabber@example.com",
       "reply_jid": "replies@example.com",
       "dispatch_time": "2009/04/23 12:49:07 +0200",
       "flow_expression_id":
          {"workflow_definition_url": "field:__definition",
           "expression_name": "toto",
           "workflow_definition_name": "TestExternal",
           "owfe_version": "0.9.21",
           "workflow_definition_revision": "0",
           "workflow_instance_id": "20090413-juduhojewo",
           "engine_id": "ruote_rest",
           "expression_id": "0.0.0.0.1"}
          }
    JSON

    @wi = RuoteExternalWorkitem.parse( json )
  end
  
  it "should have a source jabber id" do
    @wi.source_jid.should == 'jabber@example.com'
  end

  it "should have a destination jabber id for replies" do
    @wi.reply_jid.should == 'replies@example.com'
  end
end

describe RuoteExternalWorkitem::AMQP do
  before(:each) do
    json = <<-JSON
      {"last_modified": "2009/04/23 12:49:07 +0200",
       "type": "OpenWFE::InFlowWorkItem",
       "participant_name": "toto",
       "attributes": {"shallow": "true", "nes": {"ted": "yes" } },
       "source_queue": "ruote.participant",
       "reply_queue": "ruote.listener",
       "dispatch_time": "2009/04/23 12:49:07 +0200",
       "flow_expression_id":
          {"workflow_definition_url": "field:__definition",
           "expression_name": "toto",
           "workflow_definition_name": "TestExternal",
           "owfe_version": "0.9.21",
           "workflow_definition_revision": "0",
           "workflow_instance_id": "20090413-juduhojewo",
           "engine_id": "ruote_rest",
           "expression_id": "0.0.0.0.1"}
          }
    JSON

    @wi = RuoteExternalWorkitem.parse( json )
  end
  
  it "should have a source queue" do
    @wi.source_queue.should == 'ruote.participant'
  end
  
  it "should have a queue name for replies" do
    @wi.reply_queue.should == 'ruote.listener'
  end
end
