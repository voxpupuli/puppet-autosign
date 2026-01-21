# frozen_string_literal: true

require 'spec_helper'

shared_examples_for 'base case' do
  it { is_expected.to compile.with_all_deps }
end

describe 'autosign' do
  context 'autosign class without any parameters' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:params) { {} }

        it_behaves_like 'base case'
        it { is_expected.to contain_package('autosign via puppet_gem').with_ensure('present') }
        it { is_expected.to contain_package('autosign via puppetserver_gem').with_ensure('present') }
      end
    end
  end

  context 'autosign class with some parameters' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:params) do
          {
            ensure: 'latest',
            puppetserver_ensure: 'latest',
            gem_source: 'https://rubygems.org',
            config: { 'jwt_token' => { 'secret' => 'hunter2' } },
          }
        end

        if %w[FreeBSD OpenBSD].include?(os_facts[:osfamily])
          base_configpath = '/usr/local/etc'
          base_journalpath = '/var/autosign'
        else
          base_configpath = '/etc'
          base_journalpath = '/var/lib/autosign'
        end

        it_behaves_like 'base case'

        it do
          is_expected.to contain_package('autosign via puppet_gem').
            with('ensure' => 'latest',
                 'source' => 'https://rubygems.org')
        end

        it do
          is_expected.to contain_package('autosign via puppetserver_gem').
            with('ensure' => 'latest',
                 'source' => 'https://rubygems.org')
        end

        it { is_expected.to contain_file("#{base_configpath}/autosign.conf").with_ensure('file') }
        it { is_expected.to contain_file("#{base_journalpath}/autosign.journal").with_ensure('file') }
        it { is_expected.to contain_file('/var/log/autosign.log').with_ensure('file') }
        it { is_expected.to contain_file(base_journalpath) }
      end
    end
  end

  context 'when running Puppet Enterprise' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) do
          os_facts.merge(is_pe: true, pe_server_version: '2017.3.2')
        end
        let(:params) { {} }

        it_behaves_like 'base case'
        it { is_expected.to contain_package('autosign via puppet_gem').with_ensure('present') }
        it { is_expected.to contain_package('autosign via puppetserver_gem').with_ensure('present') }

        it {
          is_expected.to contain_file('/var/log/puppetlabs/puppetserver/autosign.log').with(
            'ensure' => 'file',
            'owner' => 'pe-puppet',
            'group' => 'pe-puppet',
            'mode' => '0640'
          )
        }

        it {
          is_expected.to contain_file('/etc/puppetlabs/puppetserver/autosign.conf').with(
            'ensure' => 'file',
            'owner' => 'pe-puppet',
            'group' => 'pe-puppet',
            'mode' => '0640'
          )
        }

        it {
          is_expected.to contain_file('/opt/puppetlabs/server/autosign/autosign.journal').with(
            'ensure' => 'file',
            'owner' => 'pe-puppet',
            'group' => 'pe-puppet',
            'mode' => '0640'
          )
        }

        it {
          is_expected.to contain_file('/opt/puppetlabs/server/autosign').with(
            'ensure' => 'directory',
            'owner' => 'pe-puppet',
            'group' => 'pe-puppet',
            'mode' => '0750'
          )
        }
      end
    end
  end

  context 'when overriding options' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:params) do
          {
            ensure: '0.1.0',
            configfile: '/etc/autosign1.conf',
            manage_journalfile: false,
            manage_logfile: false,
          }
        end

        it_behaves_like 'base case'
        it { is_expected.to contain_package('autosign via puppet_gem').with_ensure('0.1.0') }
        it { is_expected.to contain_file('/etc/autosign1.conf').with_ensure('file') }
        it { is_expected.not_to contain_file('/var/lib/autosign/autosign.journal') }
        it { is_expected.not_to contain_file('/var/log/autosign.log') }
        it { is_expected.not_to contain_file('/var/lib/autosign') }
      end
    end
  end

  context 'autosign class with manage_package=false' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts) { os_facts }
        let(:params) do
          {
            manage_package: false,
          }
        end

        it { is_expected.not_to contain_package('autosign via puppet_gem') }
      end
    end
  end
end
