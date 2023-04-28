# frozen_string_literal: true

control 'moosefs.client.package.installed' do
  title 'The required package should be installed'

  package_name = 'moosefs-client'
  describe package(package_name) do
    it { should be_installed }
  end
end
