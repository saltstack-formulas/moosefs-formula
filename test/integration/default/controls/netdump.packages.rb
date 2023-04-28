# frozen_string_literal: true

control 'moosefs.netdump.package.cleaned' do
  title 'The required package should not be installed'

  package_name = 'moosefs-netdump'
  describe package(package_name) do
    it { should_not be_installed }
  end
end
