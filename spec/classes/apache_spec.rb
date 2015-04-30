require 'spec_helper'

describe 'apache', :type => :class do
  let (:facts) { centos_facts }

  describe 'without parameters' do

    it { should create_class('apache') }
    it { should include_class('apache::module') }
    it { should include_class('apache::setup') }
    it { should include_class('apache::service') }
    it { should contain_apache__listen('80') }
    it { should contain_apache__namevhost('80') }
    it { should_not contain_class('apache::security') }

  end

  describe 'with parameter' do
    describe 'defaults => false' do
      let (:params) { {
        :defaults => false,
      } }
      it { should_not contain_apache__listen('80') }
      it { should_not contain_apache__namevhost('80') }
    end
    describe 'harden => true' do
      let (:params) { { :harden => true } }
      it { should include_class('apache::security') }
    end
  end


end
