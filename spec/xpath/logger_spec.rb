# coding: utf-8
# vim: et ts=2 sw=2

RSpec.describe Rubyang::Xpath::Logger do
  let(:name){ 'spec' }
  let(:internal_logger){
    Class.new{
      def fatal; yield; end
      def error; yield; end
      def warn;  yield; end
      def info;  yield; end
      def debug; yield; end
    }.new
  }
  let(:logger){ described_class.new name }

  describe '.initialize' do
    it "takes one argument" do
      expect { Rubyang::Xpath::Logger.initialize internal_logger }.not_to raise_error
    end

    it "initialize Rubyang::Xpath::Logger" do
      Rubyang::Xpath::Logger.initialize internal_logger
      expect(Rubyang::Xpath::Logger.initialized?).to be true
    end
  end

  describe '.uninitialize' do
    it "takes no arguments" do
      expect { Rubyang::Xpath::Logger.uninitialize }.not_to raise_error
    end

    it "uninitialize Rubyang::Xpath::Logger" do
      Rubyang::Xpath::Logger.initialize internal_logger
      Rubyang::Xpath::Logger.uninitialize
      expect(Rubyang::Xpath::Logger.initialized?).to be false
    end
  end

  describe '.initialized?' do
    it "is false when uninitialized" do
      Rubyang::Xpath::Logger.initialize internal_logger
      Rubyang::Xpath::Logger.uninitialize
      expect(Rubyang::Xpath::Logger.initialized?).to be false
    end

    it "is true when initialized" do
      Rubyang::Xpath::Logger.initialize internal_logger
      expect(Rubyang::Xpath::Logger.initialized?).to be true
    end
  end

  describe '#new' do
    it "takes one argument" do
      expect { Rubyang::Xpath::Logger.new name }.not_to raise_error
    end
  end

  describe '#fatal' do
    let(:method){ :fatal }

    context 'Rubyang::Xpath::Logger is not initialized' do
      before :example do
        Rubyang::Xpath::Logger.uninitialize
      end
      it "does not call #fatal method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Xpath::Logger is initialized' do
      before :example do
        Rubyang::Xpath::Logger.initialize internal_logger
      end
      it "calls #fatal method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end

  describe '#error' do
    let(:method){ :error }

    context 'Rubyang::Xpath::Logger is not initialized' do
      before :example do
        Rubyang::Xpath::Logger.uninitialize
      end
      it "does not call #error method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Xpath::Logger is initialized' do
      before :example do
        Rubyang::Xpath::Logger.initialize internal_logger
      end
      it "calls #error method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end

  describe '#warn' do
    let(:method){ :warn }

    context 'Rubyang::Xpath::Logger is not initialized' do
      before :example do
        Rubyang::Xpath::Logger.uninitialize
      end
      it "does not call #warn method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Xpath::Logger is initialized' do
      before :example do
        Rubyang::Xpath::Logger.initialize internal_logger
      end
      it "calls #warn method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end

  describe '#info' do
    let(:method){ :info }

    context 'Rubyang::Xpath::Logger is not initialized' do
      before :example do
        Rubyang::Xpath::Logger.uninitialize
      end
      it "does not call #info method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Xpath::Logger is initialized' do
      before :example do
        Rubyang::Xpath::Logger.initialize internal_logger
      end
      it "calls #info method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end

  describe '#debug' do
    let(:method){ :debug }

    context 'Rubyang::Xpath::Logger is not initialized' do
      before :example do
        Rubyang::Xpath::Logger.uninitialize
      end
      it "does not call #debug method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Xpath::Logger is initialized' do
      before :example do
        Rubyang::Xpath::Logger.initialize internal_logger
      end
      it "calls #debug method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end
end
