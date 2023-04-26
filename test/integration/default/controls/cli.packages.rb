# frozen_string_literal: true

control 'moosefs.cli.package.installed' do
  title 'The required package should be installed'

  package_name = 'moosefs-cli'
  describe package(package_name) do
    it { should be_installed }
  end
end
