require 'serverspec'

# Required by serverspec
set :backend, :exec


describe package('outlyer-agent') do
  it { should be_installed }
end

describe file('/etc/outlyer/agent.yaml'), :if => os[:family] == 'debian' do
    it { should be_file }
    it { should be_mode 640 }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'outlyer' }
    its(:content) { should match /agent_key/ }
end
