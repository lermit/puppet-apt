require "#{File.join(File.dirname(__FILE__),'..','spec_helper.rb')}"

describe 'apt' do

  let(:title) { 'apt' }
  let(:node) { 'rspec.example42.com' }
  let(:facts) { { :ipaddress => '10.42.42.42' } }

  describe 'Test standard installation' do
    it { should contain_package('apt').with_ensure('present') }
    it { should contain_file('apt.conf').with_ensure('present') }
  end

  describe 'Test installation of a specific version' do
    let(:params) { {:version => '1.0.42' } }
    it { should contain_package('apt').with_ensure('1.0.42') }
  end

  describe 'Test decommissioning - absent' do
    let(:params) { {:absent => true} }

    it 'should remove Package[apt]' do should contain_package('apt').with_ensure('absent') end
    it 'should remove apt configuration file' do should contain_file('apt.conf').with_ensure('absent') end
  end

  describe 'Test customizations - template' do
    let(:params) { {:template => "apt/spec.erb" , :options => { 'opt_a' => 'value_a' } } }

    it 'should generate a valid template' do
      content = catalogue.resource('file', 'apt.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
    it 'should generate a template that uses custom options' do
      content = catalogue.resource('file', 'apt.conf').send(:parameters)[:content]
      content.should match "value_a"
    end

  end

  describe 'Test customizations - source' do
    let(:params) { {:source => "puppet://modules/apt/spec" , :source_dir => "puppet://modules/apt/dir/spec" , :source_dir_purge => true } }

    it 'should request a valid source ' do
      content = catalogue.resource('file', 'apt.conf').send(:parameters)[:source]
      content.should == "puppet://modules/apt/spec"
    end
    it 'should request a valid source dir' do
      content = catalogue.resource('file', 'apt.dir').send(:parameters)[:source]
      content.should == "puppet://modules/apt/dir/spec"
    end
    it 'should purge source dir if source_dir_purge is true' do
      content = catalogue.resource('file', 'apt.dir').send(:parameters)[:purge]
      content.should == true
    end
  end

  describe 'Test customizations - custom class' do
    let(:params) { {:my_class => "apt::spec" } }
    it 'should automatically include a custom class' do
      content = catalogue.resource('file', 'apt.conf').send(:parameters)[:content]
      content.should match "fqdn: rspec.example42.com"
    end
  end

  describe 'Test Puppi Integration' do
    let(:params) { {:puppi => true, :puppi_helper => "myhelper"} }

    it 'should generate a puppi::ze define' do
      content = catalogue.resource('puppi::ze', 'apt').send(:parameters)[:helper]
      content.should == "myhelper"
    end
  end

end

