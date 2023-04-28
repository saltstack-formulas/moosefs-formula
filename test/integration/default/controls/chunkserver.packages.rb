# frozen_string_literal: true

control 'moosefs.chunkserver.package.installed' do
  title 'The required package should be installed'

  package_name = 'moosefs-chunkserver'
  describe package(package_name) do
    it { should be_installed }
  end
end
