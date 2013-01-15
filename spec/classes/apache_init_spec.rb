require 'spec_helper'

describe 'apache', :type => :class  do
  let (:node) { 'test.example.com' }

  describe 'with augeas'  do
    describe 'not available' do
      let (:facts) { { :augeasversion => :undef } }
      it do
        expect {
          include_class('apache')
          include_class('apache::setup')
        }.to raise_error(Puppet::Error, /requires augeas/)
      end
    end

    describe 'version < 0.9.0' do
      let(:facts) { { :augeasversion => '0.7.0' } }
      it do
        should raise_error(Puppet::Error, /requires a newer augeas version/)
      end
    end

    describe 'version = 0.9.0' do
      let (:facts) { { :augeasversion => '0.9.0' } }
      it do
        should_not raise_error(Puppet::Error)
      end
    end

    describe 'version > 0.10.0' do
      let (:facts) { { :augeasversion => '0.9.0' } }
      it do
        should_not raise_error(Puppet::Error)
      end
    end

  end


end
