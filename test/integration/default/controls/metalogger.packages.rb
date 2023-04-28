# frozen_string_literal: true

control 'moosefs.metalogger.package.installed' do
  title 'The required package should be installed'

  package_name = 'moosefs-metalogger'
  describe package(package_name) do
    it { should be_installed }
  end
end
