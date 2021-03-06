# frozen_string_literal: true

require 'ostruct'

module KubsCLI
  RSpec.describe Install do
    ROOT = File.expand_path('../', File.dirname(__FILE__))
    DEPENDENCIES_FILE = File.join(ROOT, 'lib',
                                  'examples', 'dependencies.yaml')

    config = OpenStruct.new(dependencies: DEPENDENCIES_FILE)
    let(:install) { KubsCLI::Install.new(config) }

    context '#create_ary_from_yaml(file)' do
      it "Should create an array in the form \#{command} \#{value}" do
        ary = install.create_ary_from_yaml(DEPENDENCIES_FILE)
        expect(ary).to be_an_instance_of(Array)
      end

      it 'should include npm install -g' do
        ary = install.create_ary_from_yaml(DEPENDENCIES_FILE)
        expect(ary).to include(/(ufw)/)
      end

      it 'should include sudo apt install -y tmux' do
        ary = install.create_ary_from_yaml(DEPENDENCIES_FILE)
        expect(ary).to include(/(sudo apt install -y)/)
      end
    end
  end
end
