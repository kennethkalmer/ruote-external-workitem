require 'spec_helper'

describe RuoteExternalWorkitem::Base do
  it "should have a fei (FlowExpressionId)"
  it "should have a participant name"
  it "should have a dispatch time"
  it "should have a last modified time"
  it "should have attributes"
end

describe RuoteExternalWorkitem::REST do
  it "should have a base URI"
  it "should have a URI to self"
end

describe RuoteExternalWorkitem::XMPP do
  it "should have a jabber id for replies"
end

describe RuoteExternalWorkitem::AMQP do
  it "should have a queue name for replies"
end
