# frozen_string_literal: true

control 'moosefs.cgiserv.package.installed' do
  title 'The required package should be installed'

  package_name = 'moosefs-cgiserv'
  describe package(package_name) do
    it { should be_installed }
  end
end
