# frozen_string_literal: true

control 'moosefs.master.package.installed' do
  title 'The required package should be installed'

  # Override by `platform_finger`
  package_name = 'moosefs-master'

  describe package(package_name) do
    it { should be_installed }
  end
end
