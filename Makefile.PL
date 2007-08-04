# Load the Module::Install bundled in ./inc/
use inc::Module::Install;

# Define metadata
name           'NetHack-Logfile';
all_from       'lib/NetHack/Logfile.pm';

requires       'Carp';
requires       'Exporter';

build_requires 'Test::More';
build_requires 'File::Temp';

auto_install;
WriteAll;

