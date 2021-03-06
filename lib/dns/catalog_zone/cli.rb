# The MIT License (MIT)
#
# Copyright (c) 2016 Manabu Sonoda
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'dns/catalog_zone'
require 'thor'

# The Cli class is used to catz cli application
module Dns
  module CatalogZone
    class Cli < Thor
      desc 'init', 'initializes a new environment by creating a CatalogZone'
      def init(_zonename = 'catalog.example', _type = 'file')
        unless File.exist? 'CatalogZone'
          FileUtils.cp Dns::CatalogZone.root_path + '/share/CatalogZone', 'CatalogZone'
        end
      end
      desc 'list', 'list setting'
      def list
        read_config
        puts "name\tsource\tsoftware\tzonename\n"
        @config.settings.each do |setting|
          puts "#{setting.name}\t#{setting.source}\t" \
               "#{setting.software}\t\t#{setting.zonename}\n"
        end
      end
      desc 'checkconf [setting]', 'check config'
      def checkconf(name = nil)
        read_config
        @config.settings.each do |setting|
          next unless name == setting.name || name.nil?
          setting.validate
        end
      end
      desc 'make [setting]', 'make config file'
      def make(name = nil)
        read_config
        @config.settings.each do |setting|
          next unless name == setting.name || name.nil?
          setting.validate
          catalog_zone = make_CatalogZone(setting)
          provider = make_config(setting, catalog_zone)
          output(setting, provider)
        end
      end

      private

      def read_config
        @config = Dns::CatalogZone::Config.read
      end

      def make_CatalogZone(setting)
        source = Dns::CatalogZone::Source.create(setting)
        Dns::CatalogZone::CatalogZone.new(setting.zonename, source.get)
      end

      def make_config(setting, catalog_zone)
        provider = Dns::CatalogZone::Provider.create(setting)
        provider.make(catalog_zone)
        provider
      end

      def output(setting, provider)
        output = Dns::CatalogZone::Output.create(setting)
        output.output(provider.write)
      end
    end
  end
end
