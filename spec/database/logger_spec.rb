# coding: utf-8
# vim: et ts=2 sw=2

require 'spec_helper'

RSpec.describe Rubyang::Database::Logger do
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
      expect { Rubyang::Database::Logger.initialize internal_logger }.not_to raise_error
    end

    it "initialize Rubyang::Database::Logger" do
      Rubyang::Database::Logger.initialize internal_logger
      expect(Rubyang::Database::Logger.initialized?).to be true
    end
  end

  describe '.uninitialize' do
    it "takes no arguments" do
      expect { Rubyang::Database::Logger.uninitialize }.not_to raise_error
    end

    it "uninitialize Rubyang::Database::Logger" do
      Rubyang::Database::Logger.initialize internal_logger
      Rubyang::Database::Logger.uninitialize
      expect(Rubyang::Database::Logger.initialized?).to be false
    end
  end

  describe '.initialized?' do
    it "is false when uninitialized" do
      Rubyang::Database::Logger.initialize internal_logger
      Rubyang::Database::Logger.uninitialize
      expect(Rubyang::Database::Logger.initialized?).to be false
    end

    it "is true when initialized" do
      Rubyang::Database::Logger.initialize internal_logger
      expect(Rubyang::Database::Logger.initialized?).to be true
    end
  end

  describe '#new' do
    it "takes one argument" do
      expect { Rubyang::Database::Logger.new name }.not_to raise_error
    end
  end

  describe '#fatal' do
    let(:method){ :fatal }

    context 'Rubyang::Database::Logger is not initialized' do
      before :example do
        Rubyang::Database::Logger.uninitialize
      end
      it "does not call #fatal method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Database::Logger is initialized' do
      before :example do
        Rubyang::Database::Logger.initialize internal_logger
      end
      it "calls #fatal method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end

  describe '#error' do
    let(:method){ :error }

    context 'Rubyang::Database::Logger is not initialized' do
      before :example do
        Rubyang::Database::Logger.uninitialize
      end
      it "does not call #error method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Database::Logger is initialized' do
      before :example do
        Rubyang::Database::Logger.initialize internal_logger
      end
      it "calls #error method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end

  describe '#warn' do
    let(:method){ :warn }

    context 'Rubyang::Database::Logger is not initialized' do
      before :example do
        Rubyang::Database::Logger.uninitialize
      end
      it "does not call #warn method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Database::Logger is initialized' do
      before :example do
        Rubyang::Database::Logger.initialize internal_logger
      end
      it "calls #warn method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end

  describe '#info' do
    let(:method){ :info }

    context 'Rubyang::Database::Logger is not initialized' do
      before :example do
        Rubyang::Database::Logger.uninitialize
      end
      it "does not call #info method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Database::Logger is initialized' do
      before :example do
        Rubyang::Database::Logger.initialize internal_logger
      end
      it "calls #info method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end

  describe '#debug' do
    let(:method){ :debug }

    context 'Rubyang::Database::Logger is not initialized' do
      before :example do
        Rubyang::Database::Logger.uninitialize
      end
      it "does not call #debug method of @@logger" do
        expect { logger.send(method){ method } }.not_to raise_error
      end
    end

    context 'Rubyang::Database::Logger is initialized' do
      before :example do
        Rubyang::Database::Logger.initialize internal_logger
      end
      it "calls #debug method of @@logger with '#\{name\}: ' prefix" do
        expect(logger.send(method){ method }).to eq "#{name}: #{method}"
      end
    end
  end
end
