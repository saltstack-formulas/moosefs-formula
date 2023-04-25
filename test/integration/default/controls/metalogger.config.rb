# frozen_string_literal: true

control 'moosefs.metalogger.config.mfsmetalogger' do
  title 'Verify the configuration file'

  describe file('/etc/mfs/mfsmetalogger.cfg') do
    it { should be_file }
    it { should be_owned_by 'mfs' }
    it { should be_grouped_into 'mfs' }
    its('mode') { should cmp '0640' }
    its('content') { should include '# File managed by SaltStack at' }
    its('content') { should include '# WORKING_USER = mfs' }
    its('content') { should include 'MASTER_HOST = moosefs.example.net' }
  end
end
