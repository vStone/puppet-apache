require 'spec_helper'

describe 'apache::mod::passenger', :type => :class do

  context 'with a passenger module' do
    let (:pre_condition) {
      [ "class passenger {}", "class passenger::module {}" ]
    }

    describe 'with package => false' do
      let (:params) { { :package => false } }
      it { should_not include_class('passenger') }
      it { should_not contain_apache__sys__modpackage('passenger') }
      it { should contain_notify('Passenger is unmanaged') }
    end

    describe 'with package => undef' do
      let (:params) { { } }
      it { should include_class('passenger') }
      it { should_not contain_apache__sys__modpackage('passenger') }
    end

  end

  context 'with no passenger module' do
    describe 'with package => false' do
      let (:params) { { :package => false } }
      it { should_not contain_apache__sys__modpackage('passenger') }
      it { should contain_notify('Passenger is unmanaged') }
    end

    describe 'with package => custom' do
      let (:facts) { centos_facts }
      let (:params) { { :package => 'custom', } }
      it { should contain_apache__sys__modpackage('passenger').with_package('custom') }
    end

    describe 'with package => undef' do
      describe 'on centos' do
        let (:facts) { centos_facts }
        it { should contain_apache__sys__modpackage('passenger').with_package('mod_passenger') }
      end
      describe 'on debian' do
        let (:facts) { debian_facts }
        it { should contain_apache__sys__modpackage('passenger').with_package('libapache2-mod-passenger') }
      end
      describe 'on other oses' do
        it do
          expect {
            should contain_apache__sys__modpackage('passenger')
          }.to raise_error(Puppet::Error, /Your operatingsystem is not supported by apache::mod:passenger/)
        end
      end
    end

  end

end
