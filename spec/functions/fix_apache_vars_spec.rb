require 'spec_helper'

describe 'fix_apache_vars' do

  let (:scope) { PuppetlabsSpec::PuppetInternals.scope }

  tests =  {
    'foo%[bar]'   => 'foo%{bar}',
    'foo %[bar]'  => 'foo %{bar}',
    'foo %%[bar]' => 'foo %[bar]',
    '%{foobar}'   => '%{foobar}',
    '%[foobar]'   => '%{foobar}',
    '%%[foobar]'  => '%[foobar]',
    '%%%[foobar]' => '%%{foobar}',
    '%%%%[foobar]' => '%%%[foobar]',
    '%[first] blah %[second]' => '%{first} blah %{second}',
    '%[first] blah %%[second]' => '%{first} blah %[second]',
  }

  tests.each do |t,r|
    it "#{t.inspect} should convert to #{r.inspect}" do
      scope.function_fix_apache_vars([t]).should == r
    end
  end

end
