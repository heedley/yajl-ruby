# encoding: UTF-8
require File.expand_path(File.dirname(__FILE__) + '/../spec_helper.rb')

class Dummy2
  def to_json
    "hawtness"
  end
end

describe "Yajl JSON encoder" do
  FILES = Dir[File.dirname(__FILE__)+'/../../benchmark/subjects/*.json']
  
  FILES.each do |file|
    it "should encode #{File.basename(file)} to an IO" do
      # we don't care about testing the stream subject as it has multiple JSON strings in it
      if File.basename(file) != 'twitter_stream.json'
        input = File.new(File.expand_path(file), 'r')
        io = StringIO.new
        encoder = Yajl::Encoder.new
        hash = Yajl::Parser.parse(input)
        encoder.encode(hash, io)
        io.rewind
        hash2 = Yajl::Parser.parse(io)
        io.close
        input.close
        hash.should == hash2
      end
    end
  end
  
  FILES.each do |file|
    it "should encode #{File.basename(file)} and return a String" do
      # we don't care about testing the stream subject as it has multiple JSON strings in it
      if File.basename(file) != 'twitter_stream.json'
        input = File.new(File.expand_path(file), 'r')
        encoder = Yajl::Encoder.new
        hash = Yajl::Parser.parse(input)
        output = encoder.encode(hash)
        hash2 = Yajl::Parser.parse(output)
        input.close
        hash.should == hash2
      end
    end
  end
  
  FILES.each do |file|
    it "should encode #{File.basename(file)} call the passed block, passing it a String" do
      # we don't care about testing the stream subject as it has multiple JSON strings in it
      if File.basename(file) != 'twitter_stream.json'
        input = File.new(File.expand_path(file), 'r')
        encoder = Yajl::Encoder.new
        hash = Yajl::Parser.parse(input)
        output = ''
        encoder.encode(hash) do |json_str|
          output << json_str
        end
        hash2 = Yajl::Parser.parse(output)
        input.close
        hash.should == hash2
      end
    end
  end
  
  it "should encode with :pretty turned on and a single space indent, to an IO" do
    output = "{\n \"foo\": {\n  \"name\": \"bar\",\n  \"id\": 1234\n }\n}"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\n \"foo\": {\n  \"id\": 1234,\n  \"name\": \"bar\"\n }\n}"
    end
    obj = {:foo => {:id => 1234, :name => "bar"}}
    io = StringIO.new
    encoder = Yajl::Encoder.new(:pretty => true, :indent => ' ')
    encoder.encode(obj, io)
    io.rewind
    io.read.should == output
  end
  
  it "should encode with :pretty turned on and a single space indent, and return a String" do
    output = "{\n \"foo\": {\n  \"name\": \"bar\",\n  \"id\": 1234\n }\n}"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\n \"foo\": {\n  \"id\": 1234,\n  \"name\": \"bar\"\n }\n}"
    end
    obj = {:foo => {:id => 1234, :name => "bar"}}
    encoder = Yajl::Encoder.new(:pretty => true, :indent => ' ')
    output = encoder.encode(obj)
    output.should == output
  end
  
  it "should encode with :pretty turned on and a tab character indent, to an IO" do
    output = "{\n\t\"foo\": {\n\t\t\"name\": \"bar\",\n\t\t\"id\": 1234\n\t}\n}"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\n\t\"foo\": {\n\t\t\"id\": 1234,\n\t\t\"name\": \"bar\"\n\t}\n}"
    end
    obj = {:foo => {:id => 1234, :name => "bar"}}
    io = StringIO.new
    encoder = Yajl::Encoder.new(:pretty => true, :indent => "\t")
    encoder.encode(obj, io)
    io.rewind
    io.read.should == output
  end
  
  it "should encode with :pretty turned on and a tab character indent, and return a String" do
    output = "{\n\t\"foo\": {\n\t\t\"name\": \"bar\",\n\t\t\"id\": 1234\n\t}\n}"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\n\t\"foo\": {\n\t\t\"id\": 1234,\n\t\t\"name\": \"bar\"\n\t}\n}"
    end
    obj = {:foo => {:id => 1234, :name => "bar"}}
    encoder = Yajl::Encoder.new(:pretty => true, :indent => "\t")
    output = encoder.encode(obj)
    output.should == output
  end
  
  it "should encode with it's class method with :pretty and a tab character indent options set, to an IO" do
    output = "{\n\t\"foo\": {\n\t\t\"name\": \"bar\",\n\t\t\"id\": 1234\n\t}\n}"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\n\t\"foo\": {\n\t\t\"id\": 1234,\n\t\t\"name\": \"bar\"\n\t}\n}"
    end
    obj = {:foo => {:id => 1234, :name => "bar"}}
    io = StringIO.new
    Yajl::Encoder.encode(obj, io, :pretty => true, :indent => "\t")
    io.rewind
    io.read.should == output
  end
  
  it "should encode with it's class method with :pretty and a tab character indent options set, and return a String" do
    output = "{\n\t\"foo\": {\n\t\t\"name\": \"bar\",\n\t\t\"id\": 1234\n\t}\n}"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\n\t\"foo\": {\n\t\t\"id\": 1234,\n\t\t\"name\": \"bar\"\n\t}\n}"
    end
    obj = {:foo => {:id => 1234, :name => "bar"}}
    output = Yajl::Encoder.encode(obj, :pretty => true, :indent => "\t")
    output.should == output
  end
  
  it "should encode with it's class method with :pretty and a tab character indent options set, to a block" do
    output = "{\n\t\"foo\": {\n\t\t\"name\": \"bar\",\n\t\t\"id\": 1234\n\t}\n}"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\n\t\"foo\": {\n\t\t\"id\": 1234,\n\t\t\"name\": \"bar\"\n\t}\n}"
    end
    obj = {:foo => {:id => 1234, :name => "bar"}}
    output = ''
    Yajl::Encoder.encode(obj, :pretty => true, :indent => "\t") do |json_str|
      output = json_str
    end
    output.should == output
  end
  
  it "should encode multiple objects into a single stream, to an IO" do
    pending "Find a better way to compare order of hash keys in resulting string"
    io = StringIO.new
    obj = {:foo => "bar", :baz => 1234}
    encoder = Yajl::Encoder.new
    5.times do
      encoder.encode(obj, io)
    end
    io.rewind
    output = "{\"baz\":1234,\"foo\":\"bar\"}{\"baz\":1234,\"foo\":\"bar\"}{\"baz\":1234,\"foo\":\"bar\"}{\"baz\":1234,\"foo\":\"bar\"}{\"baz\":1234,\"foo\":\"bar\"}"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\"foo\":\"bar\",\"baz\":1234}{\"foo\":\"bar\",\"baz\":1234}{\"foo\":\"bar\",\"baz\":1234}{\"foo\":\"bar\",\"baz\":1234}{\"foo\":\"bar\",\"baz\":1234}"
    end
    io.read.should == output
  end
  
  it "should encode multiple objects into a single stream, and return a String" do
    pending "Find a better way to compare order of hash keys in resulting string"
    obj = {:foo => "bar", :baz => 1234}
    encoder = Yajl::Encoder.new
    json_output = ''
    5.times do
      json_output << encoder.encode(obj)
    end
    output = "{\"baz\":1234,\"foo\":\"bar\"}\n{\"baz\":1234,\"foo\":\"bar\"}\n{\"baz\":1234,\"foo\":\"bar\"}\n{\"baz\":1234,\"foo\":\"bar\"}\n{\"baz\":1234,\"foo\":\"bar\"}\n"
    if RUBY_VERSION.include?('1.9') # FIXME
      output = "{\"foo\":\"bar\",\"baz\":1234}\n{\"foo\":\"bar\",\"baz\":1234}\n{\"foo\":\"bar\",\"baz\":1234}\n{\"foo\":\"bar\",\"baz\":1234}\n{\"foo\":\"bar\",\"baz\":1234}\n"
    end
    json_output.should == output
  end
  
  it "should encode all map keys as strings" do
    Yajl::Encoder.encode({1=>1}).should eql("{\"1\":1}")
  end
  
  it "should check for and call #to_json if it exists on custom objects" do
    d = Dummy2.new
    Yajl::Encoder.encode({:foo => d}).should eql('{"foo":"hawtness"}')
  end
  
  it "should encode a hash where the key and value can be symbols" do
    Yajl::Encoder.encode({:foo => :bar}).should eql('{"foo":"bar"}')
  end
end