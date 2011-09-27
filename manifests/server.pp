class mysql::server {

    case $operatingsystem {
      gentoo: { include mysql::server::gentoo }
      centos: { include mysql::server::centos }
      ubuntu: { include mysql::server::ubuntu }
      debian: { include mysql::server::debian }
      default: { include mysql::server::base }
    }
    
    if $use_munin {
      case $operatingsystem {
        ubuntu: { include mysql::server::munin::debian }
        debian: { include mysql::server::munin::debian }
        default: { include mysql::server::munin::default }
      }
    }
    
}
