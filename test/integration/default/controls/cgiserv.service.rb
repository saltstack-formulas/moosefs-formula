# frozen_string_literal: true

control 'moosefs.cgiserv.service.running' do
  title 'The service should be installed, disabled and not running'

  service_name = 'moosefs-cgiserv'
  describe service(service_name) do
    it { should be_installed }
    it { should_not be_enabled }
    it { should_not be_running }
  end
end
