# frozen_string_literal: true

control 'moosefs.cgiserv.config.moosefs-cgiserv' do
  title 'Verify the configuration file'

  describe file('/etc/default/moosefs-cgiserv') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include '# File managed by SaltStack at' }
    its('content') { should include '# MFSCGISERV_USER=nobody' }
    its('content') { should include '# MFSCGISERV_GROUP=nogroup' }
    its('content') { should include '# BIND_HOST=localhost' }
    its('content') { should include '# BIND_PORT=9425' }
    its('content') { should include '# ROOT_PATH=/usr/share/moosefs-cgi' }
    its('content') { should include '# DEMON_OPTS=' }
  end
end
