# frozen_string_literal: true

control 'moosefs.chunkserver.config.mfschunkserver' do
  title 'Verify the configuration file'

  describe file('/etc/mfs/mfschunkserver.cfg') do
    it { should be_file }
    it { should be_owned_by 'mfs' }
    it { should be_grouped_into 'mfs' }
    its('mode') { should cmp '0640' }
    its('content') { should include '# File managed by SaltStack at' }
    its('content') { should include '# WORKING_USER = mfs' }
    its('content') { should include 'MASTER_HOST = moosefs.example.net' }
    its('content') do
      should include 'AUTH_CODE = yYyzqzZw5PvZ74pQAd8M1Uqa7PWGznlycVGTEzHDGG'
    end
  end
end

control 'moosefs.chunkserver.config.mfshdd' do
  title 'Verify the configuration file'

  describe file('/etc/mfs/mfshdd.cfg') do
    it { should be_file }
    it { should be_owned_by 'mfs' }
    it { should be_grouped_into 'mfs' }
    its('mode') { should cmp '0640' }
    its('content') { should include '# File managed by SaltStack at' }
    its('content') { should include '/srv/moosefs-storage' }
  end
end
