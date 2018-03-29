# vim: ft=sls
# Init outlyeragent
{%- from "outlyeragent/map.jinja" import outlyeragent with context %}


{% if grains['os'] == 'Ubuntu' or grains['os'] == 'Debian' %}

outlyer_repo:
  pkgrepo.managed:
    - name: deb  https://packages.outlyer.com/debian unstable main
    - humanname: outlyer
    - file: /etc/apt/sources.list.d/outlyer.list
    # - key_url: https://packages.outlyer.com/outlyer-pubkey.gpg
    - keyid: ACB6D967
    - keyserver: keyserver.ubuntu.com
    - gpgcheck: 1

{% elif grains['os_family'] == 'RedHat' %}

outlyer_repo:
  file.managed:
    - name: /etc/pki/rpm-gpg/RPM-GPG-KEY-outlyer
    - source: https://packages.outlyer.com/outlyer-pubkey.gpg
    - source_hash: md5=cf5f8458bb68026eb1e7169e6aa001f6
  pkgrepo.managed:
    - name: outlyer
    - humanname: outlyer
    - baseurl: https://packages.outlyer.com/stable/el{{grains['osmajorrelease']}}/$basearch/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-outlyer

{% endif %}


outlyeragent_pkg:
  pkg.installed:
    - name: outlyer-agent 
    - refresh: True


outlyeragent_config:
  file.managed:
    - name: '/etc/outlyer/agent.yaml'
    - source: salt://outlyeragent/files/outlyer-agent.yaml.j2
    - user: root
    - group: outlyer
    - mode: 0640
    - template: jinja
    - require:
      - pkg: outlyer-agent


outlyer-agent:
  service:
    - running
    - enable: True
    - order: last
    - watch:
      - file: /etc/outlyer/agent.yaml
      - pkg: outlyer-agent
