# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'autosign' do
  before(:all) do
    apply_manifest("package { 'openvox-server': ensure => installed }", catch_failures: true)
  end

  it_behaves_like 'an idempotent resource' do
    let(:manifest) do
      <<~PUPPET
        class { 'autosign':
          config => {
            'jwt_token' => {
              'secret'   => 'autosignsecret',
              'validity' => 7200,
            },
          },
        }
      PUPPET
    end
  end

  ['/opt/puppetlabs/puppet/bin/gem', '/opt/puppetlabs/bin/puppetserver gem'].each do |gem|
    describe command("#{gem} list autosign") do
      its(:stdout) { is_expected.to match %r{^autosign } }
    end
  end

  describe file('/etc/autosign.conf') do
    it { is_expected.to be_file }
    it { is_expected.to be_mode 640 }
    it { is_expected.to be_owned_by 'puppet' }
    its(:content) { is_expected.to match %r{secret: autosignsecret} }
    its(:content) { is_expected.to match %r{journalfile: "?/var/lib/autosign/autosign.journal"?} }
  end

  describe file('/var/lib/autosign') do
    it { is_expected.to be_directory }
    it { is_expected.to be_owned_by 'puppet' }
  end

  describe file('/var/lib/autosign/autosign.journal') do
    it { is_expected.to be_file }
  end

  describe file('/var/log/autosign.log') do
    it { is_expected.to be_file }
    it { is_expected.to be_owned_by 'puppet' }
  end

  describe command('/opt/puppetlabs/puppet/bin/autosign -c /etc/autosign.conf generate -b foo.example.com') do
    its(:exit_status) { is_expected.to eq 0 }
    its(:stdout) { is_expected.to match %r{\A[\w-]+\.[\w-]+\.[\w-]+$} }
  end
end
