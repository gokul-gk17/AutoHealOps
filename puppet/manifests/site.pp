node 'puppetagent' {

  service { 'devwrapped':
    ensure => running,
    enable => true,
  }

  service { 'nginx':
    ensure => running,
    enable => true,
  }

  file { '/etc/autohealops-managed.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => "Managed by Puppet - AutoHealOps\n",
  }

}
