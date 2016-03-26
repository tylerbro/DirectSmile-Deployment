# Install chocolatey itself
iex ((new-object net.webclient).DownloadString('https://chocolatey.org/install.ps1'))

# Install DirectSmile Server products prereq
choco install vcredist2005
choco install vcredist2008
choco install vcredist2010
choco install vcredist2013
choco install silverlight
choco upgrade silverlight4sdk
choco install silverlight5sdk
choco install redis-64
choco install msaccess2010-redist-x86
choco install msaccess2010-redist-x64