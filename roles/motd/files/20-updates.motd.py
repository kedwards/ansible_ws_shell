#!/usr/bin/python

import sys
import subprocess
import apt_pkg

DISTRO = subprocess.Popen(["lsb_release", "-c", "-s"],
                          stdout=subprocess.PIPE).communicate()[0].strip()

class OpNullProgress(object):
    '''apt progress handler which supresses any output.'''
    def update(self):
        pass
    def done(self):
        pass

def is_security_upgrade(pkg):
    '''
    Checks to see if a package comes from a DISTRO-security source.
    '''
    security_package_sources = [("Ubuntu", "%s-security" % DISTRO),
                               ("Debian", "%s-security" % DISTRO)]

    for (file, index) in pkg.file_list:
        for origin, archive in security_package_sources:
            if (file.archive == archive and file.origin == origin):
                return True
    return False

# init apt and config
apt_pkg.init()

# open the apt cache
try:
    cache = apt_pkg.Cache(OpNullProgress())
except SystemError, e:
    sys.stderr.write("Error: Opening the cache (%s)" % e)
    sys.exit(-1)

# setup a DepCache instance to interact with the repo
depcache = apt_pkg.DepCache(cache)

# take into account apt policies
depcache.read_pinfile()

# initialise it
depcache.init()

# give up if packages are broken
if depcache.broken_count > 0:
    sys.stderr.write("Error: Broken packages exist.")
    sys.exit(-1)

# mark possible packages
try:
    # run distro-upgrade
    depcache.upgrade(True)
    # reset if packages get marked as deleted -> we don't want to break anything
    if depcache.del_count > 0:
        depcache.init()

    # then a standard upgrade
    depcache.upgrade()
except SystemError, e:
    sys.stderr.write("Error: Couldn't mark the upgrade (%s)" % e)
    sys.exit(-1)

# run around the packages
upgrades = 0
security_upgrades = 0
for pkg in cache.packages:
    candidate = depcache.get_candidate_ver(pkg)
    current = pkg.current_ver

    # skip packages not marked as upgraded/installed
    if not (depcache.marked_install(pkg) or depcache.marked_upgrade(pkg)):
        continue

    # increment the upgrade counter
    upgrades += 1

    # keep another count for security upgrades
    if is_security_upgrade(candidate):
        security_upgrades += 1

    # double check for security upgrades masked by another package
    for version in pkg.version_list:
        if (current and apt_pkg.version_compare(version.ver_str, current.ver_str) <= 0):
            continue
        if is_security_upgrade(version):
            security_upgrades += 1
            break

print "%d updates to install." % upgrades
print "%d security updates." % security_upgrades
print "" # leave a trailing blank line
