{% if grains['os'] == 'Ubuntu' or grains['os'] == 'Debian' %}

outlyer_repo:
  pkgrepo.managed:
    - name: deb  http://packages.outlyer.com/debian stable main
    - humanname: outlyer
    - file: /etc/apt/sources.list.d/outlyer.list
    - key_url: http://packages.outlyer.com/outlyer-pubkey.gpg
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-outlyer

{% elif grains['os_family'] == 'RedHat' %}

/etc/pki/rpm-gpg/RPM-GPG-KEY-outlyer:
  file.managed:
    - source: http://packages.outlyer.com/outlyer-pubkey.gpg
    - source_hash: md5=cf5f8458bb68026eb1e7169e6aa001f6
    - require_in:
      - pkgrepo: outlyer_repo

outlyer_repo:
  pkgrepo.managed:
    - name: outlyer
    - humanname: outlyer
    - baseurl: http://packages.outlyer.com/unstable/el{{grains['osmajorrelease']}}/$basearch/
    - gpgcheck: 1
    - gpgkey: file:///etc/pki/rpm-gpg/RPM-GPG-KEY-outlyer

{% endif %}

outlyer_install:
  pkg.installed:
    - name: outlyer-agent 
    - refresh: True
    # - skip_verify: True
 
/etc/outlyer/agent.yaml:
  file.managed:
    - source: salt://outlyer-agent/outlyer-agent.yaml.j2
    - template: jinja
    - context:
      outlyer_api_key: XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX 

outlyer-agent:
  service:
    - running
    - enable: True
    - order: last
    - watch:
      - file: /etc/outlyer/agent.yaml
      - pkg: outlyer_install
