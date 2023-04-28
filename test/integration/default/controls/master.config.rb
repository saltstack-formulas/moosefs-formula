# frozen_string_literal: true

control 'moosefs.master.config.mfsmaster' do
  title 'Verify the configuration file'

  describe file('/etc/mfs/mfsmaster.cfg') do
    it { should be_file }
    it { should be_owned_by 'mfs' }
    it { should be_grouped_into 'mfs' }
    its('mode') { should cmp '0640' }
    its('content') { should include '# File managed by SaltStack at' }
    its('content') { should include '# WORKING_USER = mfs' }
    its('content') do
      should include 'AUTH_CODE = yYyzqzZw5PvZ74pQAd8M1Uqa7PWGznlycVGTEzHDGG'
    end
  end
end

control 'moosefs.master.config.mfsexports' do
  title 'Verify the configuration file'

  describe file('/etc/mfs/mfsexports.cfg') do
    it { should be_file }
    it { should be_owned_by 'mfs' }
    it { should be_grouped_into 'mfs' }
    its('mode') { should cmp '0640' }
    its('content') { should include '# File managed by SaltStack at' }
    its('content') { should match(%r{127.0.0.1\s+/\s+rw,maproot=0}) }
  end
end

control 'moosefs.master.config.mfstopology' do
  title 'Verify the configuration file'

  describe file('/etc/mfs/mfstopology.cfg') do
    it { should be_file }
    it { should be_owned_by 'mfs' }
    it { should be_grouped_into 'mfs' }
    its('mode') { should cmp '0640' }
    its('content') { should include '# File managed by SaltStack at' }
  end
end

control 'moosefs.master.config.moosefs-master-default' do
  title 'Verify the configuration file'

  describe file('/etc/default/moosefs-master') do
    it { should be_file }
    it { should be_owned_by 'mfs' }
    it { should be_grouped_into 'mfs' }
    its('mode') { should cmp '0644' }
    its('content') { should include 'CFGFILE=/etc/mfs/mfsmaster.cfg' }
  end
end
