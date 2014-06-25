#
# Required extra repositories.
#
class packagerepos () {
  
  if $osvariant == 'CernVM' {
    info('No extra package repos required for CernVM.')
  } else {
    case $osfamily {
      'RedHat': { include packagerepos::yumrepos }
      'Debian': { alert('No extra package repos available for the Debian OS family.') }
    }
  }
}
