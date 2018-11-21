# Pulp Installation Packages
# Private class
class pulp::install {
  if $pulp::container {
    ensure_packages(['podman'])
  } else {
    package { ['pulp-server', 'pulp-selinux', 'python-pulp-streamer']: ensure => $pulp::version, }

    if $pulp::messaging_transport == 'qpid' {
      ensure_packages(['python-gofer-qpid'], {
          ensure => $pulp::messaging_version,
        }
      )
    }

    if $pulp::messaging_transport == 'rabbitmq' {
      ensure_packages(['python-gofer-amqp'], {
          ensure => $pulp::messaging_version,
        }
      )
    }

    if $pulp::enable_katello {
      package { ['pulp-katello']: ensure => $pulp::version, }
    }

    if $pulp::enable_parent_node {
      package { ['pulp-nodes-parent']: ensure => $pulp::version, }
    }

    if $pulp::enable_rpm or $pulp::enable_iso {
      package { ['pulp-rpm-plugins']: ensure => $pulp::version, }
    }

    if $pulp::enable_deb {
      package { ['pulp-deb-plugins']: ensure => $pulp::version, }
    }

    if $pulp::enable_docker {
      package { ['pulp-docker-plugins']: ensure => $pulp::version, }
    }

    if $pulp::enable_puppet {
      package { ['pulp-puppet-plugins']: ensure => $pulp::version, }
    }

    if $pulp::enable_python {
      package { ['pulp-python-plugins']: ensure => $pulp::version, }
    }

    if $pulp::enable_ostree {
      ensure_packages(['ostree'])
      package { ['pulp-ostree-plugins']: ensure => $pulp::version, }
    }
  }
}
