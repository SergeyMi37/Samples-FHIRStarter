# Dockerfile:
#
# Build from the latest IRIS container image 
# Derive container image from InterSystems container image 
FROM store/intersystems/irishealth-community:2020.4.0.547.0

# Copy app file dependencies from the host to the container IRIS mgr dir:
USER root
COPY ./Installer.xml ./FHIRStarter_Export.xml ./ISCPATIENTtoFHIR.xsd $ISC_PACKAGE_INSTALLDIR/mgr/

# RUN a series of commands
# * Loading installer directives (create DB, etc. see Installer.xml)
#
# Use the new irisowner, IRIS instance owner
USER ${ISC_PACKAGE_MGRUSER}
RUN iris start $ISC_PACKAGE_INSTANCENAME \
    && iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(%SYSTEM.OBJ).Load(\"$ISC_PACKAGE_INSTALLDIR/mgr/Installer.xml\",\"cdk\")" \
    && iris session $ISC_PACKAGE_INSTANCENAME -U %SYS "##class(Demo.Installer).Install()" \
    && iris stop $ISC_PACKAGE_INSTANCENAME quietly
#--
