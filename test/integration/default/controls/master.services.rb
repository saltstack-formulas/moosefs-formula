# frozen_string_literal: true

control 'moosefs.master.service.running' do
  title 'The service should be installed, enabled and running'

  # Override by `platform_finger`
  service_name = 'moosefs-master'

  describe service(service_name) do
    it { should be_installed }
    it { should be_enabled }
    it { should be_running }
  end
end
