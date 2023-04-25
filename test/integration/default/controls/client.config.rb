# frozen_string_literal: true

control 'moosefs.client.config.mounts' do
  title 'The mount should be configured and active'

  # For /etc/fstab
  mount_options =
    %w[
      _netdev
      mfsdelayedinit
      noatime
      nodev
      nosuid
    ]

  # For /proc/mounts
  mounted_options =
    %w[
      rw
      nosuid
      nodev
      noatime
      user_id=0
      group_id=0
      allow_other
    ]

  # rubocop:disable Lint/AmbiguousBlockAssociation
  describe etc_fstab.where { device_name == '127.0.0.1:/' } do
    it { should be_configured }
    its('mount_point') { should cmp '/mnt' }
    its('file_system_type') { should cmp 'moosefs' }
    its('dump_options') { should cmp 0 }
    its('file_system_options') { should cmp 0 }
    its('mount_options') { should cmp [mount_options] }
  end
  # rubocop:enable Lint/AmbiguousBlockAssociation

  describe mount('/mnt') do
    it { should be_mounted }
    its('device') { should eq 'mfs#127.0.0.1:9421' }
    its('type') { should eq 'fuse' }
    mounted_options.each do |opt|
      its('options') { should include opt }
    end
  end

  describe directory('/mnt') do
    its('owner') { should eq 'man' }
    its('group') { should eq 'nogroup' }
    its('mode') { should cmp '0700' }
  end
end

control 'moosefs.client.config.mfsmount' do
  title 'Verify the configuration file'

  describe file('/etc/mfs/mfsmount.cfg') do
    it { should be_file }
    it { should be_owned_by 'root' }
    it { should be_grouped_into 'root' }
    its('mode') { should cmp '0644' }
    its('content') { should include '# File managed by SaltStack at' }
    its('content') { should include 'noatime' }
    its('content') { should include 'nodev' }
    its('content') { should include 'nosuid' }
  end
end
